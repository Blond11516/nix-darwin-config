{ self }:
{ pkgs, config, ... }:
let
  constants = import ./constants.nix;
in
{
  imports = [];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = pkgs.callPackage ./packages.nix { inherit pkgs; };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh = {
      enable = true;
      promptInit = "";
      enableCompletion = true;
      enableSyntaxHighlighting = true;
    };
    vim = {
      enable = true;
    };
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = constants.system;

  nixpkgs.config.allowUnfree = true;

  homebrew = import ./homebrew.nix;

  networking = {
    computerName = constants.deviceName;
  };

  # Copy applications installed via Nix to ~ so Spotlight can index them
  # Inspired from https://github.com/andreykaipov/self/blob/384292d67c76b4a0df2308f51f8eb39abb36725c/.config/nix/packages/default.nix#L35-L64
  # Related issue: https://github.com/LnL7/nix-darwin/issues/214
  system.activationScripts.applications.text = pkgs.lib.mkForce (''
    IFS=$'\n'
    USER_HOME=/Users/${constants.user}
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
            rm -rf $dst
            cp -R "$src" $NIX_APPS_DIRECTORY
            echo "Done"
        fi
    done
  '');
}