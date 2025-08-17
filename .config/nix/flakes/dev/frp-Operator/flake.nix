{
  description = "frp-Operator development environment";

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
        bash
        gh
        gnumake42
        go
        kubernetes-helm
        nodejs_22
        skaffold
        zsh
      ];

      shellHook = ''
        export SHELL="/run/current-system/sw/bin/zsh"
        sudo ln -sfn /run/current-system/sw/bin/bash /bin/bash
        exec zsh
      '';
    };
  };
}
