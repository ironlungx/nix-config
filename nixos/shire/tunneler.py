#!/usr/bin/env python3
import subprocess
import time
from datetime import datetime, timezone
import os
import signal
import requests
import sys
import yaml

# Global variables
ssh_process = None
config = {}


def load_config(secrets_file, ports_string):
    """Load configuration from YAML file and command line arguments"""
    global config

    # Load secrets from YAML file
    try:
        with open(secrets_file, "r") as f:
            secrets = yaml.safe_load(f)
    except FileNotFoundError:
        print(f"[ERROR] Secrets file not found: {secrets_file}")
        sys.exit(1)
    except yaml.YAMLError as e:
        print(f"[ERROR] Invalid YAML in secrets file: {e}")
        sys.exit(1)

    # Parse ports from command line argument
    tunnel_ports = []
    for pair in ports_string.split(","):
        if not pair.strip():
            continue
        try:
            local, remote = pair.split(":")
            tunnel_ports.append((int(local), int(remote)))
        except ValueError:
            print(f"[ERROR] Invalid port pair: '{pair}'")

    config = {
        "remote_host": secrets.get("remote_host"),
        "tunnel_ports": tunnel_ports,
        "check_interval": secrets.get("check_interval", 10),
        "failure_threshold": secrets.get("failure_threshold", 3),
        "webhook_url": secrets.get("webhook_url"),
        "mention_id": secrets.get("mention_id"),
    }

    # Validate required configuration
    if not config["remote_host"]:
        print("[ERROR] remote_host is required in secrets file")
        sys.exit(1)

    if not config["tunnel_ports"]:
        print("[ERROR] No valid tunnel ports configured")
        sys.exit(1)


def signal_handler(signum, frame):
    """Handle signals more reliably"""
    print(f"\n[INFO] Received signal {signum}. Cleaning up...")
    cleanup_and_exit()


def cleanup_and_exit():
    """Clean up resources and exit"""
    global ssh_process
    if ssh_process and ssh_process.poll() is None:
        try:
            print("[INFO] Terminating SSH process...")
            os.killpg(os.getpgid(ssh_process.pid), signal.SIGTERM)
            ssh_process.wait(timeout=5)
        except Exception as e:
            print(f"[WARN] Error terminating SSH process: {e}")
            try:
                os.killpg(os.getpgid(ssh_process.pid), signal.SIGKILL)
            except Exception:
                pass

    # Also kill any remaining tunnel processes (only those with -N flag)
    try:
        subprocess.run(
            ["pkill", "-f", f"ssh.*-N.*{config['remote_host']}"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except Exception:
        pass

    print("[INFO] Cleanup complete. Exiting.")
    sys.exit(0)


def get_ssh_cmd():
    cmd = [
        "ssh",
        "-o",
        "ServerAliveInterval=30",
        "-o",
        "ServerAliveCountMax=3",
        "-o",
        "ExitOnForwardFailure=yes",
        "-o",
        "ConnectTimeout=10",
        "-o",
        "StrictHostKeyChecking=accept-new",
        "-N",  # Don't execute remote command, just forward ports
    ]
    for local, remote in config["tunnel_ports"]:
        cmd += ["-R", f"{remote}:localhost:{local}"]
    cmd += [config["remote_host"]]
    print(f"SSH command: {' '.join(cmd)}")
    return cmd


def timestamp():
    return datetime.now(timezone.utc).isoformat()


def send_embed(title, description, color):
    if not config["webhook_url"]:
        return
    payload = {
        "embeds": [
            {
                "title": title,
                "description": description,
                "color": color,
                "timestamp": timestamp(),
            }
        ]
    }
    try:
        requests.post(config["webhook_url"], json=payload, timeout=5)
    except requests.RequestException:
        pass


def send_critical_alert():
    if not config["webhook_url"] or not config["mention_id"]:
        return
    fields = [
        {
            "name": "Tunnels",
            "value": "\n".join(
                f"{local} → {remote}" for local, remote in config["tunnel_ports"]
            ),
        }
    ]
    payload = {
        "content": f"<@{config['mention_id']}>",
        "embeds": [
            {
                "title": "🚨 SSH Tunnel Repeated Failure",
                "description": f"Tunnel to **{config['remote_host']}** failed **{config['failure_threshold']}** times in a row.",
                "color": 16711680,
                "fields": fields,
                "timestamp": timestamp(),
            }
        ],
    }
    try:
        requests.post(config["webhook_url"], json=payload, timeout=5)
    except requests.RequestException:
        pass


def is_tunnel_active():
    global ssh_process

    # Check if our specific SSH process is still running
    if ssh_process and ssh_process.poll() is None:
        return True

    # If we don't have a tracked process, check for tunnel processes with -N flag
    result = subprocess.run(
        ["pgrep", "-f", f"ssh.*-N.*{config['remote_host']}"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return result.returncode == 0


def start_tunnel():
    global ssh_process
    try:
        # Kill any existing tunnel processes (only those with -N flag)
        subprocess.run(
            ["pkill", "-f", f"ssh.*-N.*{config['remote_host']}"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        time.sleep(1)  # Give processes time to die

        print("[INFO] Starting SSH tunnel...")
        ssh_process = subprocess.Popen(
            get_ssh_cmd(),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            preexec_fn=os.setsid,
        )

        # Wait longer for SSH to establish connection and set up port forwarding
        print("[INFO] Waiting for SSH connection to establish...")
        time.sleep(5)

        # Check if process is still running
        if ssh_process.poll() is not None:
            stdout, stderr = ssh_process.communicate()
            print(
                f"[ERROR] SSH process died immediately. Return code: {ssh_process.returncode}"
            )
            if stdout:
                print(f"[ERROR] SSH stdout: {stdout.decode().strip()}")
            if stderr:
                print(f"[ERROR] SSH stderr: {stderr.decode().strip()}")
            return False

        print("[INFO] SSH process is running, tunnel should be active")
        return True

    except Exception as e:
        print(f"[ERROR] Exception in start_tunnel: {str(e)}")
        return False


def main():
    # Parse command line arguments
    if len(sys.argv) != 3:
        print("Usage: tunneler.py <secrets_file> <ports>")
        print("Example: tunneler.py /etc/tunneler/secrets.yaml '25565:25565,1000:2000'")
        sys.exit(1)

    secrets_file = sys.argv[1]
    ports_string = sys.argv[2]

    # Load configuration
    load_config(secrets_file, ports_string)

    # Set up signal handlers
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    try:
        print("[INFO] SSH tunnel keeper started")
        print(f"[INFO] Remote host: {config['remote_host']}")
        print(f"[INFO] Tunnel ports: {config['tunnel_ports']}")
        print(f"[INFO] Check interval: {config['check_interval']}s")

        send_embed(
            "🟢 Tunnel Monitor Started",
            f"Monitoring SSH tunnel to **{config['remote_host']}**.",
            3066993,
        )

        failure_count = 0

        while True:
            try:
                if not is_tunnel_active():
                    print("[WARN] Tunnel is down. Reestablishing...")
                    success = start_tunnel()

                    if not success:
                        failure_count += 1
                        print(
                            f"[ERROR] Failed attempt {failure_count}/{config['failure_threshold']}"
                        )
                        send_embed(
                            f"⚠️ Tunnel Failure {failure_count}/{config['failure_threshold']}",
                            f"Could not establish tunnel to **{config['remote_host']}**.",
                            15105570,
                        )
                        if failure_count >= config["failure_threshold"]:
                            send_critical_alert()
                            failure_count = 0
                    else:
                        print("[INFO] Tunnel reestablished.")
                        send_embed(
                            "🔄 Tunnel Reestablished",
                            f"Tunnel to **{config['remote_host']}** is back online.",
                            3447003,
                        )
                        failure_count = 0
                else:
                    failure_count = 0

                # Use interruptible sleep
                for _ in range(config["check_interval"]):
                    time.sleep(1)

            except KeyboardInterrupt:
                print("\n[INFO] Keyboard interrupt received")
                break

    except Exception as e:
        print(f"[ERROR] Unexpected error in main loop: {e}")
    finally:
        cleanup_and_exit()


if __name__ == "__main__":
    main()
