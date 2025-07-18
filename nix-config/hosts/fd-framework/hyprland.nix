{ pkgs, ... }:

let
  startScript = pkgs.pkgs.writeShellScriptBin "start" ''
    swww-daemon &
    swww img ${./wallpaper.png} &

    nm-applet --indicator &

    waybar &

    dunst
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      input = {
        kb_options = "caps:ctrl_modifier,caps:nocaps";
      };

      bind = [
        "$mainMod, Space, exec, rofi -show"
      ];

      exec-once = ''${startScript}/bin/start'';
    };
  };
}
