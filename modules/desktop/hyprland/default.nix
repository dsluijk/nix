{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland = {
    enable = mkBoolOpt false;
    xwayland = mkBoolOpt true;
    polkit = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    modules = {
      programs = {
        kitty.enable = true;
        nautilus.enable = true;
      };
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = cfg.xwayland;
    };

    home-manager.users.${config.modules.user.username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        inputs.hyprwm-contrib.packages.${system}.grimblast
        brightnessctl
        playerctl
      ];

      gtk = {
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = cfg.xwayland;
        settings = {
          "$mod" = "SUPER";
          "$terminal" = "kitty";
          "$fileManager" = "nautilus";
          "exec-once" = [
            "sleep 0.5 && hyprlock --immediate"
          ];
          misc = {
            "force_default_wallpaper" = 0;
            "disable_hyprland_logo" = true;
          };
          general = {
            gaps_out = 8;
          };
          decoration = {
            rounding = 3;
            active_opacity = 0.95;
            inactive_opacity = 0.8;
          };
          windowrulev2 = [
            # Floating, resize, and dimming folder opening.
            "float,title:(Open Folder)"
            "dimaround,title:(Open Folder)"
            "size 50% 70%,title:(Open Folder)"
            "center,title:(Open Folder)"

            # Floating, resize, and dimming file saving.
            "float,title:(Save As)"
            "dimaround,title:(Save As)"
            "size 50% 70%,title:(Save As)"
            "center,title:(Save As)"

            # Floating, resize, and dimming polkit.
            "float,class:(lxqt-policykit-agent)"
            "dimaround,class:(lxqt-policykit-agent)"
            "size 20% 25%,class:(lxqt-policykit-agent)"
            "center,class:(lxqt-policykit-agent)"

            "opacity 1.0 override 0.95 override,class:(firefox)"
            "opacity 1.0 override 0.95 override,initialtitle:(Visual\ Studio\ Code)"
          ];
          env = [
            "XCURSOR_SIZE,24"
            "QT_QPA_PLATFORMTHEME,qt5ct"
            "ELECTRON_OZONE_PLATFORM_HINT,wayland"
            "NIXOS_OZONE_WL,1"
          ];
          gestures = {
            workspace_swipe = true;
          };
          bind =
            [
              "$mod, Space, exec, walker"
              "$mod, F, fullscreen, 0"
              "$mod, Return, exec, $terminal"
              "$mod, W, killactive,"
              "$mod, E, exec, $fileManager"
              "$mod, V, togglefloating,"
              "$mod, L, exec, hyprlock --immediate"
              ", Print, exec, grimblast copy area"
            ]
            ++ (
              builtins.concatLists (
                builtins.genList
                (
                  x: let
                    ws = let
                      c = (x + 1) / 10;
                    in
                      builtins.toString (x + 1 - (c * 10));
                  in [
                    "$mod, ${ws}, workspace, ${toString (x + 1)}"
                    "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
                  ]
                )
                10
              )
            );
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
          bindel = [
            ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ",XF86MonBrightnessUp, exec, brightnessctl s 7%+"
            ",XF86MonBrightnessDown, exec, brightnessctl s 7%-"
          ];
          bindl = [
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPrev, exec, playerctl previous"
          ];
        };
      };
    };
  };
}
