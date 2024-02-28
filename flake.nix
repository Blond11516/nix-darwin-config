{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    me = "etiennelevesque";

    configuration = { pkgs, lib, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
          pkgs.bat
          pkgs.btop
          pkgs.direnv
          pkgs.curl
          pkgs.flyctl
          pkgs.hyperfine
          pkgs.jq
          pkgs.mob
          pkgs.nil
          pkgs.git
          pkgs.just

          # MacOS App packages
          pkgs.discord
          pkgs.slack
          pkgs.rectangle
          pkgs.obsidian
          pkgs.iterm2
          pkgs.darwin.discrete-scroll
          pkgs.dbeaver
          pkgs.vscode
          pkgs.jetbrains.idea-ultimate
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      programs.zsh.promptInit = "";
      programs.zsh.enableCompletion = true;
      programs.zsh.enableSyntaxHighlighting = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";

      nixpkgs.config.allowUnfree = true;

      # Copy applications installed via Nix to ~ so Spotlight can index them
      # Inspired from https://github.com/andreykaipov/self/blob/384292d67c76b4a0df2308f51f8eb39abb36725c/.config/nix/packages/default.nix#L35-L64
      # Related issue: https://github.com/LnL7/nix-darwin/issues/214
      system.activationScripts.applications.text = pkgs.lib.mkForce (''
        IFS=$'\n'
        USER_HOME=/Users/${me}
        NIX_APPS_DIRECTORY=/Applications/Nix\ Apps

        echo "Setting up $NIX_APPS_DIRECTORY"

        hashApp() {
            path="$1/Contents/MacOS"; shift

            for bin in $(find "$path" -perm +111 -type f -maxdepth 1 2>/dev/null); do
                md5sum "$bin" | cut -b-32
            done | md5sum | cut -b-32
        }

        mkdir -p $NIX_APPS_DIRECTORY

        for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
            name="$(basename "$app")"

            src="$(/usr/bin/stat -f%Y "$app")"
            dst="$NIX_APPS_DIRECTORY/$name"

            hash1="$(hashApp "$src")"
            hash2="$(hashApp "$dst")"

            if [ "$hash1" != "$hash2" ]; then
                echo "Current hash of '$name' differs than the Nix store's. Overwriting..."
                cp -R "$src" $NIX_APPS_DIRECTORY
                echo "Done"
            fi
        done
      '');
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Etienne-Levesque-MacBook-Pro-16-inch-2019
    darwinConfigurations."Etienne-Levesque-MacBook-Pro-16-inch-2019" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Etienne-Levesque-MacBook-Pro-16-inch-2019".pkgs;
  };
}
