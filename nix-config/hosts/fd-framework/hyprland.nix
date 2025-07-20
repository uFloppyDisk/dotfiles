{ pkgs, ... }:

let
  startScript = pkgs.pkgs.writeShellScriptBin "start" ''
    swww-daemon &
    swww img ${./wallpaper.png} --resize=no &

    hyprctl setcursor Adwaita 24 &

    nm-applet --indicator &

    waybar &

    dunst
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = [
        "eDP-1, preferred, auto, auto"
        "DP-4, preferred, auto-left, auto"
        ", preferred, auto, 1"
      ];

      "$terminal" = "kitty";
      "$filemanager" = "nautilus --new-window";
      "$menu" = "rofi -show";

      env = {
        xcursor_size = 24;
        hyprcursor_size = 24;
      };

      general = {
          gaps_in = 5;
          gaps_out = 10;

          border_size = 2;

          # https://wiki.hyprland.org/configuring/variables/#variable-types for info about colors
          col.active_border = "rgba(251,44,54,1)";
          col.inactive_border = "rgba(70,8,9,1)";

          # set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true;
          hover_icon_on_border = true;

          # please see https://wiki.hyprland.org/configuring/tearing/ before you turn this on
          allow_tearing = false;

          layout = "dwindle";
      };

      decoration = {
          rounding = 0;
          rounding_power = 2;

          # change transparency of focused and unfocused windows;
          active_opacity = 1.0;
          inactive_opacity = 0.9;

          new_optimizations = true;

          # shadow = {
          #     enabled = true;
          #     range = 4;
          #     render_power = 3;
          #     color = "rgba(1a1a1aee)";
          # };

          # https://wiki.hyprland.org/configuring/variables/#blur;
          blur = {
              enabled = true;
              size = 5;
              passes = 2;

              vibrancy = 0.1696;
          };
      };

      animations = {
          enabled = "yes, please :)";

          # default animations, see https://wiki.hyprland.org/configuring/animations/ for more;
          bezier = [
            "easeoutquint,0.23,1,0.32,1"
            "easeinoutcubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostlinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeoutquint"
            "windows, 1, 4.79, easeoutquint"
            "windowsin, 1, 4.1, easeoutquint, popin 87%"
            "windowsout, 1, 1.49, linear, popin 87%"
            "fadein, 1, 1.73, almostlinear"
            "fadeout, 1, 1.46, almostlinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeoutquint"
            "layersin, 1, 4, easeoutquint, fade"
            "layersout, 1, 1.5, linear, fade"
            "fadelayersin, 1, 1.79, almostlinear"
            "fadelayersout, 1, 1.39, almostlinear"
            "workspaces, 1, 1.94, almostlinear, fade"
            "workspacesin, 1, 1.21, almostlinear, fade"
            "workspacesout, 1, 1.94, almostlinear, fade"
          ];
      };

      dwindle = {
          pseudotile = true; # master switch for pseudotiling. enabling is bound to mainmod + p in the keybinds section below
          preserve_split = true; # you probably want this
      };

      master = {
          new_status = "master";
      };

      misc = {
          force_default_wallpaper = 0; # set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = true; # if true disables the random hyprland logo / anime girl background. :(
          disable_splash_rendering = true;
          animate_manual_resizes = true;
          vfr = true;
          vrr = 2;
      };

      input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "caps:ctrl_modifier,caps:nocaps";
          kb_rules = "";

          follow_mouse = 1;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

          touchpad = {
              natural_scroll = false;
              disable_while_typing = true;
              tap-to-click = true;
              drag_lock = true;
              scroll_factor = 0.5;
          };
      };

      gestures = {
          workspace_swipe = false;
      };

      device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
      };

      "$mainmod" = "super"; # sets "windows" key as main modifier

      bind = [
        "$mainmod, space, exec, $menu"
        "$mainmod, t, exec, $terminal"
        "$mainmod, e, exec, $filemanager"

        "$mainmod, q, killactive,"
        "$mainmod shift, q, exit,"

        "$mainmod, f, togglefloating,"
        "$mainmod, m, fullscreen, 1"
        "$mainmod, p, pseudo," # dwindle
        "$mainmod, u, togglesplit," # dwindle

        "$mainmod, h, movefocus, l"
        "$mainmod, l, movefocus, r"
        "$mainmod, k, movefocus, u"
        "$mainmod, j, movefocus, d"

        "$mainmod shift, h, movewindow, l"
        "$mainmod shift, l, movewindow, r"
        "$mainmod shift, k, movewindow, u"
        "$mainmod shift, j, movewindow, d"

        "$mainmod alt, h, resizeactive, -5% 0"
        "$mainmod alt, l, resizeactive, 5% 0"
        "$mainmod alt, k, resizeactive, 0 -5%"
        "$mainmod alt, j, resizeactive, 0 5%"

        "$mainmod, 1, workspace, 1"
        "$mainmod, 2, workspace, 2"
        "$mainmod, 3, workspace, 3"
        "$mainmod, 4, workspace, 4"
        "$mainmod, 5, workspace, 5"
        "$mainmod, 6, workspace, 6"
        "$mainmod, 7, workspace, 7"
        "$mainmod, 8, workspace, 8"
        "$mainmod, 9, workspace, 9"
        "$mainmod, 0, workspace, 10"
        "$mainmod shift, 1, movetoworkspace, 1"
        "$mainmod shift, 2, movetoworkspace, 2"
        "$mainmod shift, 3, movetoworkspace, 3"
        "$mainmod shift, 4, movetoworkspace, 4"
        "$mainmod shift, 5, movetoworkspace, 5"
        "$mainmod shift, 6, movetoworkspace, 6"
        "$mainmod shift, 7, movetoworkspace, 7"
        "$mainmod shift, 8, movetoworkspace, 8"
        "$mainmod shift, 9, movetoworkspace, 9"
        "$mainmod shift, 0, movetoworkspace, 10"
        "$mainmod, s, togglespecialworkspace, magic"
        "$mainmod shift, s, movetoworkspace, special:magic"
        "$mainmod, mouse_down, workspace, e+1"
        "$mainmod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mainmod, mouse:272, movewindow"
        "$mainmod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        "suppressevent maximize, class:.*;"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0;"
        "opacity 1.0, zen-beta"
        "opacity 1.0, zen"
      ];

      exec-once = ''${startScript}/bin/start'';
    };
  };
}
