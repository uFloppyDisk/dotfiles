{
  description = "keybr.com development flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = { nixpkgs ,... }: let
    system = "x86_64-linux";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs {
        inherit system;
      };
    in pkgs.mkShell {
      packages = with pkgs; [
        nodejs_22
        zsh
      ];

      shellHook = ''
        export SHELL="/run/current-system/sw/bin/zsh"
        echo "node `node --version`"
        exec zsh
      '';
    };
  };
}
