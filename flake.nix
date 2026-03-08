{
  description = "fast prism flake";
  nixConfig = {
    trusted-substituters = [
      "https://prismlauncher.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="      
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
      systems = (with inputs.nixpkgs.lib; with platforms; mkMerge [ linux darwin netbsd freebsd openbsd ]);
      perSystem = { config, self', inputs', pkgs, system, final, ... }: {
        packages = let prism = inputs.prismlauncher.packages.${system}; in {
          default = self'.packages.prism-fast;
        } // (import ./prism.nix { inherit pkgs system prism; });
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ self'.packages.default ];
        };
      };
    };
}
