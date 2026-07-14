{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.myhm.qutebrowser;
in
{
  options.myhm.qutebrowser.enable = lib.mkEnableOption "qutebrowser";

  config.home.packages =
    with pkgs;
    lib.mkIf cfg.enable [
      python3Packages.adblock
    ];
  config.programs.qutebrowser = lib.mkIf cfg.enable {
    enable = true;
    searchEngines = {
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&amp;go=Go&amp;ns0=1";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://wiki.nixos.org/index.php?search={}";
      g = "https://www.google.com/search?hl=en&amp;q={}";
      yt = "https://www.youtube.com/results?search_query={}";
      p = "https://www.perplexity.ai/?q={}";
    };
    settings.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36";

    extraConfig = builtins.readFile ./config.py;

    greasemonkey = [
      (pkgs.writeText "my-script.js" ''
        // ==UserScript==
        // @name            Auto adblock skipper on Youtube
        // @namespace       https://greasyfork.org/nl/users/1486038-JooostS
        // @version         3.2
        // @author          JooostS
        // @description     Auto-skips all ads and removes adblock popups on YouTube.
        // @description:de  Entfernt die lästige Popup-Nachricht zur Verwendung eines Adblockers auf YouTube.
        // @description:ru  Удаление всплывающего окна об использовании блокировщика рекламы на YouTube.
        // @description:uk  Видалення спливаючого вікна про використання блокувальника реклами на YouTube.
        // @description:zh  YouTube 广告拦截器弹出窗口移除器：移除 YouTube 上关于使用广告拦截器的烦人弹出窗口消息。
        // @description:ja  YouTube広告ブロッカーポップアップリムーバー：YouTubeで広告ブロッカーを使用する際の迷惑なポップアップメッセージを除去します。
        // @description:nl  YouTube Adblock Popup-verwijderaar: Verwijdert het vervelende pop-upbericht over het gebruik van een adblocker op YouTube.
        // @description:pt  Removedor de pop-up de bloqueador de anúncios do YouTube: Remove a mensagem irritante de pop-up sobre o uso de um bloqueador de anúncios no YouTube.
        // @description:es  Removedor de pop-up del bloqueador de anuncios de YouTube: Elimina el molesto mensaje emergente sobre el uso de un bloqueador de anúncios en YouTube.
        // @description:it  Rimozione del popup del blocco pubblicità di YouTube: Rimuove il fastidioso messaggio popup sull'uso di un blocco pubblicità su YouTube.
        // @description:ar  إزالة النافذة المنبثقة لمانع الإعلانات على يوتيوب: يزيل الرسالة المنبثقة المزعجة حول استخدام مانع الإعلانات على يوتيوب.
        // @description:fr  Supprimeur de popup de bloqueur de publicités YouTube : Supprime le message pop-up ennuyeux sur l'utilisation d'un bloqueur de publicités sur YouTube.
        // @match           *://www.youtube.com/*
        // @grant           GM_getValue
        // @grant           GM_setValue
        // @grant           GM_registerMenuCommand
        // @license         MIT
        // @downloadURL https://update.greasyfork.org/scripts/540098/Auto%20adblock%20skipper%20on%20Youtube.user.js
        // @updateURL https://update.greasyfork.org/scripts/540098/Auto%20adblock%20skipper%20on%20Youtube.meta.js
        // ==/UserScript==

        const config = GM_getValue('config', { allowedReloadPage: true });
        let video = null;
        let pausedByUser = false;
        let allowPauseVideoTimeoutId = 0;
        let observerAttached = false;

        function log(msg) {
          console.log(`[AdSkipper] $${msg}`);
        }

        // --- Skip button selectors (expanded for 2024/2025 YouTube UI) ---
        function getSkipButton() {
          return document.querySelector([
            '.ytp-skip-ad-button',
            '.ytp-ad-skip-button',
            '.ytp-ad-skip-button-modern',
            '[class*="skip-ad"]',
            '[class*="SkipAd"]',
            '.ytp-ad-skip-button-slot button',
            'button.ytp-ad-skip-button-modern',
          ].join(', '));
        }

        // --- Core ad skipper ---
        function skipAd() {
          const player = document.querySelector('#movie_player');
          if (!player) return;

          video = player.querySelector('video.html5-main-video');
          if (!video) return;

          const isAdShowing =
            player.classList.contains('ad-showing') ||
            player.classList.contains('ad-interrupting');

          if (isAdShowing) {
            const skipButton = getSkipButton();
            if (skipButton && skipButton.offsetParent !== null) {
              skipButton.click();
              log('Ad skipped via button.');
            } else {
              // Fast-forward through unskippable ad
              video.playbackRate = 16;
              if (isFinite(video.duration) && video.duration > 0) {
                video.currentTime = video.duration - 0.1;
              }
              log('Ad accelerated.');
            }
          } else {
            // Reset playback rate after ad
            if (video.playbackRate !== 1) {
              video.playbackRate = 1;
            }
          }
        }

        // --- Adblock / enforcement popup removal ---
        // YouTube now serves these in several different ways; cover all known variants.
        function removeAdblockPopups() {
          const popupSelectors = [
            // Classic enforcement dialog
            'tp-yt-paper-dialog:has(#feedback.ytd-enforcement-message-view-model)',
            '.yt-playability-error-supported-renderers:has(.ytd-enforcement-message-view-model)',
            // 2024 modal overlay variants
            'ytd-enforcement-message-view-model',
            '#enforcement-dialog',
            '#error-screen:has(.ytd-enforcement-message-view-model)',
            // "Ad blocker detected" interstitial
            '.yt-mealbar-promo-renderer',
            // Dialog that pauses the video asking to allow ads / subscribe
            'ytd-modal-with-title-and-button-renderer:has([class*="enforcement"])',
            // Newer: full-page paywall overlay
            '#paywallOverlay',
          ];

          let found = false;
          popupSelectors.forEach(sel => {
            document.querySelectorAll(sel).forEach(el => {
              el.remove();
              found = true;
              log(`Adblock popup removed: $${sel}`);
            });
          });

          if (found && config.allowedReloadPage) {
            log('Reloading page after popup removal.');
            location.reload();
          }

          // Unblock video if it was frozen by YouTube's enforcement
          unmuteAndUnfreezeVideo();
        }

        // YouTube sometimes mutes + pauses the video as part of enforcement.
        function unmuteAndUnfreezeVideo() {
          const player = document.querySelector('#movie_player');
          if (!player) return;

          video = player.querySelector('video.html5-main-video');
          if (!video) return;

          if (video.muted) {
            video.muted = false;
            log('Video unmuted.');
          }

          if (video.paused && !pausedByUser && !document.hidden) {
            video.play().catch(() => {});
            log('Video force-played after enforcement freeze.');
          }
        }

        // --- Dismiss "Skip Ads" / survey overlays that block interaction ---
        function dismissOverlays() {
          const overlaySelectors = [
            '.ytp-ad-overlay-close-button',
            '.ytp-ad-overlay-close-container button',
            '.ytp-suggested-action-badge-expanded',
          ];
          overlaySelectors.forEach(sel => {
            const el = document.querySelector(sel);
            if (el) {
              el.click();
              log(`Overlay dismissed: $${sel}`);
            }
          });
        }

        // --- Pause tracking ---
        function resumeVideoIfPausedUnexpectedly() {
          if (pausedByUser || document.hidden || !video) return;
          const remaining = video.duration - video.currentTime;
          if (remaining < 0.1) return;
          video.play().catch(() => {});
          log('Resumed video after unexpected pause.');
        }

        function enableVideoPause() {
          pausedByUser = true;
          clearTimeout(allowPauseVideoTimeoutId);
          allowPauseVideoTimeoutId = setTimeout(() => { pausedByUser = false; }, 600);
        }

        // --- MutationObserver on player + document body ---
        function observePlayer() {
          const player = document.querySelector('#movie_player');
          if (!player || !window.MutationObserver) return;
          if (observerAttached) return;

          const playerObserver = new MutationObserver(() => {
            skipAd();
            removeAdblockPopups();
            dismissOverlays();
          });
          playerObserver.observe(player, { childList: true, subtree: true, attributes: true });

          // Also observe body for enforcement overlays injected outside the player
          const bodyObserver = new MutationObserver(() => {
            removeAdblockPopups();
          });
          bodyObserver.observe(document.body, { childList: true, subtree: true });

          observerAttached = true;
          log('MutationObservers attached.');
        }

        // --- CSS: hide ad elements ---
        function applyCustomStyles() {
          const style = document.createElement('style');
          style.textContent = `
            /* In-player ad banners and slots */
            #player-ads,
            #masthead-ad,
            ytd-ad-slot-renderer,
            ytd-rich-item-renderer:has(.ytd-ad-slot-renderer),
            ytd-reel-video-renderer:has(.ytd-ad-slot-renderer),
            .ytp-suggested-action,
            .ytp-ad-image-overlay,
            .ytp-ad-overlay-slot,
            .ytp-ad-module,
            .ytd-promoted-video-renderer,
            ytd-display-ad-renderer,
            /* 2024/2025 additions */
            ytd-action-companion-ad-renderer,
            ytd-video-masthead-ad-v3-renderer,
            ytd-in-feed-ad-layout-renderer,
            ytd-banner-promo-renderer,
            ytd-statement-banner-renderer,
            ytd-shopping-video-annotation-renderer,
            ytd-primetime-promo-renderer,
            .ytd-merch-shelf-renderer,
            /* Endscreen / cards */
            .ytp-endscreen-content,
            .ytp-ce-element,
            .ytp-pause-overlay {
              display: none !important;
            }
          `;
          document.head.appendChild(style);
          log('Custom styles applied.');
        }

        // --- Greasemonkey menu ---
        function initializeMenuCommands() {
          GM_registerMenuCommand(
            `Reload page if ad can't be skipped: $${config.allowedReloadPage ? 'Yes' : 'No'}`,
            () => {
              config.allowedReloadPage = !config.allowedReloadPage;
              GM_setValue('config', config);
              initializeMenuCommands();
            }
          );
        }

        // --- Event listeners ---
        function setupEventListeners() {
          // Track user-initiated pauses via keyboard
          window.addEventListener('keydown', e => {
            if (['KeyK', 'MediaPlayPause', 'Space'].includes(e.code)) enableVideoPause();
          });
          window.addEventListener('keyup', e => {
            if (e.code === 'Space') enableVideoPause();
          });

          // Track user-initiated pauses via click on player
          document.addEventListener('click', e => {
            const player = document.querySelector('#movie_player');
            if (player && player.contains(e.target)) enableVideoPause();
          });

          // Re-attach observer on SPA navigation
          document.addEventListener('yt-navigate-finish', () => {
            observerAttached = false;
            video = null;
            observePlayer();
            skipAd();
            removeAdblockPopups();
          });

          // Also handle YouTube's newer navigation event
          document.addEventListener('yt-page-data-updated', () => {
            observerAttached = false;
            observePlayer();
          });
        }

        // --- Init ---
        function init() {
          applyCustomStyles();
          observePlayer();
          setupEventListeners();
          initializeMenuCommands();

          // Periodic safety net (catches anything the observer misses)
          setInterval(() => {
            skipAd();
            removeAdblockPopups();
            dismissOverlays();
          }, 1000);

          // Slower check for frozen/muted video
          setInterval(() => {
            resumeVideoIfPausedUnexpectedly();
          }, 2000);

          log('Script initialized (v3.2).');
        }

        init();
      '')
    ];

  };

}
