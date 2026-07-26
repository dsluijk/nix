{
  config,
  lib,
  vscode-extensions,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.development.latex;
in {
  options.modules.development.latex = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules = {
      programs.vscode = {
        settings = {
          ltex.ltex-ls.path = pkgs.ltex-ls-plus;
          "[latex]" = {
            editor.defaultFormatter = "James-Yu.latex-workshop";
          };

          "[bibtex]" = {
            "editor.defaultFormatter" = "James-Yu.latex-workshop";
          };
        };

        extensions = with vscode-extensions; [
          pwintz.dryer-lint
          james-yu.latex-workshop
          ltex-plus.vscode-ltex-plus
        ];
      };
    };

    programs = {
    };

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        (pkgs.texlive.combine {
          inherit
            (pkgs.texlive)
            scheme-full
            latexmk
            scheme-basic
            dvisvgm
            dvipng # for preview and export as html
            wrapfig
            amsmath
            ulem
            hyperref
            capt-of
            arimo
            ;
          #(setq org-latex-compiler "lualatex")
          #(setq org-preview-latex-default-process 'dvisvgm)
        })

        # Some fonts we use
        liberation_ttf
        roboto-slab
        nerd-fonts.cousine
      ];
    };
  };
}
