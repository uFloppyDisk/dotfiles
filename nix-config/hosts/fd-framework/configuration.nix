{ pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-e6f28a04-2919-4bdf-bf22-a07e4b9245ba".device = "/dev/disk/by-uuid/e6f28a04-2919-4bdf-bf22-a07e4b9245ba";
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
  ];
  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 28d";
  };

  networking.hostName = "fd-framework"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
  	enable = true;
    wifi.powersave = false;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # Configure fingerprint service
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:ctrl_modifier";
  };

  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [ 
    protonup-qt
    wineWowPackages.stable
    wineWowPackages.waylandFull
    winetricks
  ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.floppydisk = {
    isNormalUser = true;
    description = "Pawel Bartusiak";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
  	extraSpecialArgs = { inherit inputs; };
    users = {
      "floppydisk" = import ./home.nix;
    };
  };

  programs.firefox.enable = false;
  fd.hyprland.enable = true;

  networking.firewall.allowedTCPPorts = [
    53317 # Localsend
  ];
  networking.firewall.allowedUDPPorts = [
    53317 # Localsend
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
