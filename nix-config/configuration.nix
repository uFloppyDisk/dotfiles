{ pkgs, lib, ... }:

{
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/hyprland.nix
  ];

  # Localizations
  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.printing.enable = true;

  # Certificates
  security.pki.certificates = [
    # FloppyCert
    ''
      -----BEGIN CERTIFICATE-----
      MIIB0TCCAXagAwIBAgIQArJAp5OmpOrVlHPQ80xY/TAKBggqhkjOPQQDAjAyMRMw
      EQYDVQQKEwpGbG9wcHlDZXJ0MRswGQYDVQQDExJGbG9wcHlDZXJ0IFJvb3QgQ0Ew
      HhcNMjUwNTA2MDAxMjQ1WhcNMzUwNTA0MDAxMjQ1WjA6MRMwEQYDVQQKEwpGbG9w
      cHlDZXJ0MSMwIQYDVQQDExpGbG9wcHlDZXJ0IEludGVybWVkaWF0ZSBDQTBZMBMG
      ByqGSM49AgEGCCqGSM49AwEHA0IABPoxB+lrC6UCmYKWUK23ktaaYDy7PocTD4bg
      GJltXCNONoAMVMrf1Z43K6ZGgBj1bRqkXV8xYxAUPi+NTCcmU8qjZjBkMA4GA1Ud
      DwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBRdNLIeEqV6
      Q0p+i0sSa8qX+845NzAfBgNVHSMEGDAWgBTwWmooBdl3eKfEUVsPFDHiQ98Z7TAK
      BggqhkjOPQQDAgNJADBGAiEA3+nuyOJsd2FIhEsP8MxDax4ixgwBmu9AXgAhPI5o
      BeQCIQDJdeQLzMxRwx6wIEOaAN1gMrxRLbgaoujpNNmFQdGxcg==
      -----END CERTIFICATE-----
    ''
  ];

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = lib.mkDefault true;

  environment.systemPackages = import ./packages.nix { inherit pkgs; };
  environment.shells = with pkgs; [ zsh ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      custom = "$HOME/.config/zsh/omz/custom";
      theme = "fd";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
