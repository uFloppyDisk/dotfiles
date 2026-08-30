final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: rec {
    version = "0.12.4";
    src = final.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v${version}";
      # Get this hash by running the build once and letting nix tell you
      hash = "sha256-KSLFsrnoEOV712cnUtA8s4EoISp+ON36jslKxSvDthQ=";
    };
  });
}
