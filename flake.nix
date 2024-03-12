{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    cf-keylayout = {
      url = "github:joallard/homebrew-cf-keylayout";
      flake = false;
    };
    firefox-profile-switcher = {
      url = "github:null-dev/homebrew-firefox-profile-switcher";
      flake = false;
    };
  };
  
  outputs = { self, nix-darwin, nix-homebrew, homebrew-bundle, cf-keylayout, firefox-profile-switcher, ... }:
  let
    constants = import ./constants.nix;
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Etienne-Levesque-MacBook-Pro-16-inch-2019
    darwinConfigurations."${constants.deviceName}" = nix-darwin.lib.darwinSystem {
      modules = [
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            # enableRosetta = true;

            # User owning the Homebrew prefix
            user = constants.user;

            # Optional: Declarative tap management
            taps = {
              "homebrew/bundle" = homebrew-bundle;
              "joallard/cf-keylayout" = cf-keylayout;
              "null-dev/firefox-profile-switcher" = firefox-profile-switcher;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;

            autoMigrate = true;
          };
        }
        (import ./configuration.nix { inherit self; })
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."${constants.deviceName}".pkgs;
  };
}
