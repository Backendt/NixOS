{ config, lib, pkgs, ... }:

let
    profileName = "main";
in {
    programs.firefox = {
        enable = true;
        package = pkgs.unstable.firefox;

        policies = {
            DisableFirefoxStudies = true;
            DisableTelemetry = true;
            EnableTrackingProtection = {
                Value = true;
                Cryptomining = true;
                Fingerprinting = true;
                EmailTracking = true;
            };

            DisablePocket = true;
            DisableFirefoxAccounts = true;
            DisplayBookmarksToolbar = "always";
            DNSOverHTTPS = {
                Enabled = true;
                ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";
                Fallback = true;
            };

            ExtensionSettings = {
                "uBlock0@raymondhill.net" = {
                    installation_mode = "normal_installed";
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                };

                "firefox@ghostery.com" = {
                    installation_mode = "normal_installed";
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox@ghostery.com/latest.xpi";
                };

                # Bitwarden
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                    installation_mode = "normal_installed";
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/{446900e4-71c2-419f-a6a7-df9c091e268b}/latest.xpi";
                };

                # Spell checking (French)
                "fr-dicollecte@dictionaries.addons.mozilla.org" = {
                    installation_mode = "normal_installed";
                    install_url = "https://addons.mozilla.org/firefox/downloads/file/3581786/dictionnaire_francais1-7.0b.xpi";
                };
                
            };

            FirefoxHome = {
                TopSites = false;
                SponsoredTopSites = false;
                Highlights = false;
                Pocket = false;
                SponsoredPocket = false;
            };

            FirefoxSuggest = {
                SponsoredSuggestions = false;
                ImproveSuggest = false;
            };

            NoDefaultBookmarks = true;
            OfferToSaveLoginsDefault = false;
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;

            Cookies = {
                Behavior = "limit-foreign";
            };

            Bookmarks = [
                {
                    Title = "Github";        
                    URL = "https://github.com/";
                    Favicon = "https://github.com/favicon.ico";
                    Placement = "toolbar";
                }
                {
                    Title = "Mails";
                    URL = "https://mail.proton.me/u/0/inbox";
                    Favicon = "https://proton.me/favicon.ico";
                    Placement = "toolbar";
                }
                {
                    Title = "Youtube";
                    URL = "https://www.youtube.com/";
                    Favicon = "https://www.youtube.com/favicon.ico";
                    Placement = "toolbar";
                }
            ];
        };

        profiles."${profileName}" = {
            isDefault = true;
            search = {
                default = "DuckDuckGo";
                engines = {
                    "MyNixOS" = {
                        urls = [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
                        iconUpdateURL = "https://mynixos.com/favicon.ico";
                        definedAliases = [ "@nix" ];
                    };
                    "Archwiki" = {
                        urls = [{ template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; }];
                        iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
                        definedAliases = [ "@a" ];
                    };
                };
            };

            settings = {
                "browser.search.region" = "GB";
                "general.useragent.override" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:129.0) Gecko/20100101 Firefox/129.";
                "privacy.fingerprintingProtection" = true;
                "spellchecker.dictionary" = "fr,en-US,";
                "network.captive-portal-service.enabled" = false;

                # Enable DRM (/!\ Maintained by Google)
                "media.eme.enabled" = true;

            };
        };
    };

    # Allow extensions on private browsing
    home.file = let
        defaultFirefoxProfilePath = if pkgs.stdenv.hostPlatform.isDarwin then 
        "Library/Application Support/Firefox/Profiles/${profileName}" else
        ".mozilla/firefox/${profileName}";

        extensionPrefsPath = "${defaultFirefoxProfilePath}/extension-preferences.json";

        # Settings added to "extension-preferences.json"
        newPrefs = {
            # Our extensions
            "uBlock0@raymondhill.net" = {
                permissions = [
                  "internal:privateBrowsingAllowed"
                ];
                origins = [];
            };

            "firefox@ghostery.com" = {
                permissions = [
                  "internal:privateBrowsingAllowed"
                ];
                origins = [];
            };

            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                permissions = [
                  "internal:privateBrowsingAllowed"
                ];
                origins = [];
            };

            # Default firefox stuff
            "formautofill@mozilla.org" = {
                permissions = [
                    "internal:privateBrowsingAllowed"
                    "internal:svgContextPropertiesAllowed"
                ];
                origins = [];
            };
            
            "pictureinpicture@mozilla.org" = {
                permissions = [
                    "internal:privateBrowsingAllowed"
                    "internal:svgContextPropertiesAllowed"
                ];
                "origins" = [];
            };

            "screenshots@mozilla.org" = {
                permissions = [
                    "internal:privateBrowsingAllowed"
                    "internal:svgContextPropertiesAllowed"
                ];
                origins = [];
            };

            "webcompat-reporter@mozilla.org" = {
                permissions = [
                    "internal:privateBrowsingAllowed"
                    "internal:svgContextPropertiesAllowed"
                ];
                origins = [];
            };

            "webcompat@mozilla.org" = {
                permissions = [
                    "internal:privateBrowsingAllowed"
                    "internal:svgContextPropertiesAllowed"
                ];
                origins = [];
            };
            
            "default-theme@mozilla.org" = {
                permissions = [
                    "internal:privateBrowsingAllowed"
                    "internal:svgContextPropertiesAllowed"
                ];
                origins = [];
            };

            "addons-search-detection@mozilla.com" = {
                permissions = [
                    "internal:privateBrowsingAllowed"
                    "internal:svgContextPropertiesAllowed"
                ];
                origins = [];
            };
        };
    in {
        "${extensionPrefsPath}".text = (builtins.toJSON newPrefs);
    };
}
