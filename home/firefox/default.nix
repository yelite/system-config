{
  config,
  pkgs,
  lib,
  inputs,
  hostPlatform,
  ...
}: let
  # We don't use the flake.packages, instead we use callPackage from our own nixpkgs instance
  # to create derivations from the <flake-dir>/default.nix. Otherwise plugins with unfree license
  # will refuse to be evaluated, regardless of the config of our own nixpkgs instance.
  addonsPkgs = pkgs.callPackage inputs.firefox-addons {};
in {
  imports = [./darwin-profile-fix.nix];
  config = lib.mkIf (config.myConfig.firefox.enable) {
    programs.firefox = {
      enable = true;
      package =
        if hostPlatform.isDarwin
        then pkgs.firefox-devedition-bin
        else pkgs.firefox-devedition;
      policies = {
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        Cookies = {RejectTracker = true;};
        FirefoxHome = {
          Search = false;
          Pocket = false;
          SponsoredTopSites = false;
          SponsoredPocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };

        DontCheckDefaultBrowser = true;

        ExtensionSettings = {
          "ebay@search.mozilla.org".installation_mode = "blocked";
          "amazondotcom@search.mozilla.org".installation_mode = "blocked";
          "bing@search.mozilla.org".installation_mode = "blocked";
          "wikipedia@search.mozilla.org".installation_mode = "blocked";
        };
      };
      profiles = let
        profilename =
          if hostPlatform.isDarwin
          then "main.dev-edition-default"
          else "dev-edition-default";
      in {
        # https://github.com/nix-community/home-manager/issues/4703
        # has to prefix profile name with dev-edition
        "${profilename}" = {
          id = 0;
          isDefault = true;

          userChrome = ''
            #TabsToolbar {
              visibility: collapse;
            }
            /* Hide sidebar header (except Bookmarks, History, Sync'd Tabs) */
            #sidebar-box:not([sidebarcommand="viewBookmarksSidebar"]):not([sidebarcommand="viewHistorySidebar"]):not([sidebarcommand="viewTabsSidebar"])
              > #sidebar-header {
                visibility: collapse;
              }

            #sidebar-splitter {
              width: 3px !important;
            }
          '';

          extensions.packages = with addonsPkgs; [
            ublock-origin
            localcdn
            privacy-badger
            facebook-container
            multi-account-containers
            sponsorblock
            search-by-image
            sidebery
            tampermonkey
            bitwarden
            react-devtools
          ];

          settings = {
            # Based on https://github.com/xenoxanite/melted.flakes/blob/566ee0a3c4703aba471ee5cc44a2d584f7ba7020/home/programs/firefox/default.nix#L4-L4

            "browser.compactmode.show" = true;
            "browser.toolbars.bookmarks.visibility" = "never";
            # restore session
            "browser.startup.page" = 3;
            "browser.newtabpage.activity-stream.system.showSponsored" = false;

            # Enable userChrome.css
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

            # Autoplay
            "media.autoplay.block-event.enabled" = true;
            "media.autoplay.default" = 5;

            # Use system dns
            "network.trr.mode" = 5;

            # UI
            # "browser.tabs.inTitlebar" = 0;
            "ui.key.accelKey" = 224;

            # Enable HTTPS only mode
            "dom.security.https_only_mode" = true;

            # Show punycode in URLs to prevent homograph attacks
            "network.IDN_show_punycode" = true;

            # Extensions
            "extensions.enabledScopes" = 5;
            "extensions.webextensions.restrictedDomains" = "";

            # Disable annoying firefox functionality
            "browser.translations.automaticallyPopup" = false;
            "extensions.formautofill.creditCards.enabled" = false;
            "extensions.pocket.enabled" = false;
            "privacy.webrtc.legacyGlobalIndicator" = false; # Sharing indicator
            "signon.autofillForms" = false;
            "signon.rememberSignons" = false;

            # From betterfox
            "content.notify.interval" = 100000;
            "gfx.canvas.accelerated.cache-items" = 4096;
            "gfx.canvas.accelerated.cache-size" = 512;
            "gfx.content.skia-font-cache-size" = 20;
            "browser.cache.jsbc_compression_level" = 3;
            "media.memory_cache_max_size" = 65536;
            "image.mem.decode_bytes_at_a_time" = 32768;
            "network.buffer.cache.size" = 262144;
            "network.buffer.cache.count" = 128;
            "network.http.pacing.requests.enabled" = false;
            "network.dns.disablePrefetch" = true;
            "layout.css.grid-template-masonry-value.enabled" = true;
            "dom.enable_web_task_scheduling" = true;
            "layout.css.has-selector.enabled" = true;
            "dom.security.sanitizer.enabled" = true;

            "network.cookie.sameSite.noneRequiresSecure" = true;
            "browser.uitour.enabled" = true;
            "privacy.globalprivacycontrol.enabled" = true;
            "security.OCSP.enabled" = 0;
            "security.remote_settings.crlite_filters.enabled" = true;
            "security.pki.crlite_mode" = 2;
            "security.ssl.treat_unsafe_negotiation_as_broken" = true;
            "browser.xul.error_pages.expert_bad_cert" = true;
            "security.tls.enable_0rtt_data" = false;
            "privacy.history.custom" = true;

            "security.insecure_connection_text.enabled" = true;
            "security.insecure_connection_text.pbmode.enabled" = true;
            "browser.search.separatePrivateDefault.ui.enabled" = true;

            "browser.urlbar.update2.engineAliasRefresh" = true;
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;

            "browser.formfill.enable" = false;
            "signon.formlessCapture.enabled" = false;
            "signon.privateBrowsingCapture.enabled" = false;
            "network.auth.subresource-http-auth-allow" = 1;
            "editor.truncate_user_pastes" = false;
            "pdfjs.enableScripting" = false;
            "extensions.postDownloadThirdPartyPrompt" = false;
            "network.http.referer.XOriginTrimmingPolicy" = 2;
            "browser.safebrowsing.downloads.remote.enabled" = false;
            "permissions.default.geo" = 2;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "data: =";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.coverage.opt-out" = true;
            "toolkit.coverage.opt-out" = true;
            "toolkit.coverage.endpoint.base" = "";
            "toolkit.telemetry.pioneer-new-studies-available" = false;
            permissions = {"default.desktop-notification" = false;};
            "browser.ping-centre.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "app.shield.optoutstudies.enabled" = false;
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";

            "breakpad.reportURL" = "";
            "browser.tabs.crashReporting.sendReport" = false;

            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

            "captivedetect.canonicalURL" = "";
            "network.captive-portal-service.enabled" = false;

            # Peskyfox
            "browser.privatebrowsing.vpnpromourl" = "";
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "browser.discovery.enabled" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            "browser.preferences.moreFromMozilla" = false;
            "browser.aboutConfig.showWarning" = false;
            "browser.aboutwelcome.enabled" = false;
            # Dark theme
            "layout.css.prefers-color-scheme.content-override" = 0;
            "browser.urlbar.suggest.engines" = false;
            "browser.urlbar.suggest.calculator" = true;
            "browser.urlbar.unitConversion.enabled" = true;
            "browser.urlbar.trending.featureGate" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.download.manager.addToRecentDocs" = false;
            "browser.download.open_pdf_attachments_inline" = true;
            "browser.menu.showViewImageInfo" = true;
            "findbar.highlightAll" = true;
            "layout.word_select.eat_space_to_next_word" = false;

            # Smoothfox
            "apz.overscroll.enabled" = true;
            "mousewheel.min_line_scroll_amount" = 10;
            "general.smoothScroll.mouseWheel.durationMinMS" = 80;
            "general.smoothScroll.currentVelocityWeighting" = "0.15";
            "general.smoothScroll.stopDecelerationWeighting" = "0.6";

            # webrtc local testing
            "media.peerconnection.ice.loopback" = true;
          };
        };
      };
    };
  };
}
