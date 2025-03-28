{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.firefox;
in {
  options.modules.programs.firefox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      programs.firefox = {
        enable = true;
        policies = {
          PasswordManagerEnabled = false;
          OfferToSaveLogins = false;
          OverrideFirstRunPage = "";
          DisablePocket = true;
          DisableFirefoxStudies = true;
          DisableTelemetry = true;
          PrimaryPassword = false;
          SearchEngines = {
            Default = "ddg";
            PreventInstalls = true;
          };
          UserMessaging = {
            WhatsNew = false;
            ExtensionRecommendations = false;
            FeatureRecommendations = false;
            UrlbarInterventions = false;
            SkipOnboarding = true;
            MoreFromMozilla = false;
            Locked = true;
          };
          FirefoxHome = {
            SponsoredTopSites = false;
            Pocket = false;
            SponsoredPocket = false;
            Locked = true;
          };
          ExtensionSettings = {
            "*".installation_mode = "blocked";
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
              installation_mode = "force_installed";
            };
            "sponsorBlocker@ajay.app" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
              installation_mode = "force_installed";
            };
            "simple-tab-groups@drive4ik" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/simple-tab-groups/latest.xpi";
              installation_mode = "force_installed";
            };
            "langpack-nl@firefox.mozilla.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/nederlands-nl-language-pack/latest.xpi";
              installation_mode = "force_installed";
            };
            "nl-NL@dictionaries.addons.mozilla.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/file/3776797/woordenboek_nederlands-4.20.19.xpi";
              installation_mode = "force_installed";
            };
          };
          "3rdparty" = {
            Extensions = {
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                environment = {
                  base = "https://vault.dany.dev";
                };
              };
            };
          };
          Preferences = {
            "browser.contentblocking.category" = {
              Value = "strict";
              Status = "locked";
            };
            "browser.toolbars.bookmarks.visibility" = {
              Value = "never";
              Status = "locked";
            };
            "browser.startup.page" = {
              Value = 3;
              Status = "locked";
            };
            "browser.newtabpage.activity-stream.showSponsored" = {
              Value = false;
              Status = "locked";
            };
            "browser.newtabpage.activity-stream.showSearch" = {
              Value = false;
              Status = "locked";
            };
            "browser.newtabpage.activity-stream.telemetry" = {
              Value = false;
              Status = "locked";
            };
            "browser.newtabpage.activity-stream.system.showSponsored" = {
              Value = false;
              Status = "locked";
            };
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = {
              Value = false;
              Status = "locked";
            };
            "browser.newtabpage.activity-stream.section.highlights.rows" = {
              Value = 2;
              Status = "locked";
            };
            "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = {
              Value = false;
              Status = "locked";
            };
            "browser.newtabpage.activity-stream.feeds.section.highlights" = {
              Value = true;
              Status = "locked";
            };
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = {
              Value = false;
              Status = "locked";
            };
            "browser.newtabpage.pinned" = {
              Status = "locked";
              Value = ''
                [
                  {
                    "url": "https://mail.dany.dev",
                    "label": "Webmail",
                    "searchTopSite": false
                  }
                ]
              '';
            };
            "browser.uiCustomization.state" = {
              Status = "locked";
              Value = ''
                {
                  "placements": {
                    "widget-overflow-fixed-list": [],
                    "unified-extensions-area": [],
                    "nav-bar": [
                      "back-button",
                      "forward-button",
                      "stop-reload-button",
                      "urlbar-container",
                      "downloads-button",
                      "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action",
                      "ublock0_raymondhill_net-browser-action",
                      "simple-tab-groups_drive4ik-browser-action"
                    ],
                    "toolbar-menubar": ["menubar-items"],
                    "TabsToolbar": [
                      "tabbrowser-tabs",
                      "new-tab-button"
                    ],
                    "PersonalToolbar": ["import-button", "personal-bookmarks"]
                  },
                  "seen": [
                    "developer-button",
                    "ublock0_raymondhill_net-browser-action",
                    "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                  ],
                  "dirtyAreaCache": ["nav-bar", "unified-extensions-area", "PersonalToolbar"],
                  "currentVersion": 20,
                  "newElementCount": 3
                }
              '';
            };
            "browser.translations.neverTranslateLanguages" = {
              Value = "nl";
              Status = "locked";
            };
          };
        };
        profiles.default = {
          search = {
            force = true;
            default = "ddg";
            order = ["ddg" "google"];

            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };

              "NixOS Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };

              "NixOS Wiki" = {
                urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
                icon = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = ["@nw"];
              };

              "Home-Manager Settings" = {
                urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}";}];
                icon = "https://home-manager-options.extranix.com/images/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = ["@hm"];
              };

              "ddg".metaData.alias = "@d";
              "google".metaData.alias = "@g";
            };
          };
        };
      };

      home = {
        sessionVariables = {
          MOZ_ENABLE_WAYLAND = 1;
        };
      };
    };

    modules.impermanence = {
      safe.userFolders = [
        ".mozilla/firefox/default"
      ];
    };
  };
}
