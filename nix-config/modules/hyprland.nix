{ pkgs, lib, inputs, config, ... }:

let
  cfg = config.fd.hyprland;
in {
  options = {
    fd.hyprland = {
      enable = lib.mkEnableOption "setup FD hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      enable = true;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      kitty
      waybar
      libnotify
      dunst
      swww
      rofi-wayland
      pavucontrol
      copyq
      hyprshot
      (pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        })
      )
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
