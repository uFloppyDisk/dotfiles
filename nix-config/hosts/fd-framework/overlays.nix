final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: rec {
    version = "0.11.6";
    src = final.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v${version}";
      # Get this hash by running the build once and letting nix tell you
      hash = "sha256-GdfCaKNe/qPaUV2NJPXY+ATnQNWnyFTFnkOYDyLhTNg=";
    };
  });
}
