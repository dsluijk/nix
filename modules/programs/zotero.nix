{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.programs.zotero;
in {
  options.modules.programs.zotero = {
    enable = mkBoolOpt false;
    firefox = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        zotero
      ];

      home.file.".zotero/zotero/profiles.ini" = {
        executable = false;
        text = ''
          [Profile0]
          Name=default
          IsRelative=1
          Path=nixos.default
          Default=1

          [General]
          StartWithLastProfile=1
          Version=2
        '';
      };

      home.file.".zotero/zotero/nixos.default/user.js" = {
        executable = false;
        text = ''
          user_pref("extensions.zotero.dataDir", "/home/${config.modules.user.username}/.local/share/zotero");
          user_pref("extensions.zotero.useDataDir", true);
          user_pref("extensions.zotero.export.citePaperJournalArticleURL", true);
          user_pref("extensions.zotero.automaticTags", false);
          user_pref("extensions.zotero.export.quickCopy.setting", "export=b6e39b57-8942-4d11-8259-342c46ce395f");
        '';
      };

      programs.firefox.policies = mkIf cfg.firefox {
        ExtensionSettings = {
          "zotero@chnm.gmu.edu" = {
            install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
            installation_mode = "force_installed";
          };
          "{809ea8a3-a45d-41a2-9cb0-e7c7d7321db5}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/{809ea8a3-a45d-41a2-9cb0-e7c7d7321db5}/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

    modules = {
      impermanence = {
        safe.userFolders = [
          ".zotero"
          ".local/share/zotero"
        ];
      };
    };
  };
}
