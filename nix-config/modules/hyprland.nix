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
    security.pam.services.hyprlock = {};

    programs.hyprland = {
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      enable = true;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      copyq
      dunst
      hackneyed
      hyprshot
      kitty
      libnotify
      pavucontrol
      rofi-wayland
      swww
      waybar
      networkmanagerapplet
      brightnessctl
      playerctl
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
