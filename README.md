# 💾 dotfiles

### Prerequisites
<details>
    <summary><b>GNU stow</b></summary>

*Debian/Ubuntu:* `sudo apt install stow`\
*Arch Linux:* `sudo pacman -S stow`\
*OSX:* `brew install stow`

</details>

<details>
    <summary><b>ripgrep</b></summary>

[Install guide](https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation)

</details>

## Installation
1. Install prerequisites
2. Clone this repo to any folder
3. Navigate to repo directory and stow it\
`stow -R .`

## Language support

#### Dotnet
Source: [Setup Roslyn with Mason](https://github.com/seblyng/roslyn.nvim?tab=readme-ov-file#-installation)
<details>
    <summary>Latest LSP</summary>

Install `roslyn` using `:MasonInstall roslyn` or through the popup menu `:Mason`. 
</details>
<details>
  <summary>Compatibility <i>(older versions of .NET)</i></summary>
  
  1. Navigate to [this feed](https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl), search for `Microsoft.CodeAnalysis.LanguageServer` and download the version matching your OS and architecture.
  2. Unzip the downloaded `.nupkg` and copy the contents of `<zip root>/content/LanguageServer/<yourArch>` inside:
     - **Linux**: `~/.local/share/nvim/roslyn`
     - **Windows**: `%LOCALAPPDATA%\nvim-data\roslyn`
       > **_TIP:_** You can also specify a custom path to the roslyn folder in the setup function.
  3. Check if it's working by running `dotnet Microsoft.CodeAnalysis.LanguageServer.dll --version` in the `roslyn` directory from **step 2**.

</details>
