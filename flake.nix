{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inputs = inputs; } {
      systems = import inputs.systems;
      perSystem = { pkgs, lib, ... }:
      let
        test-ghc = pkgs.haskellPackages.developPackage {
          root = lib.cleanSource ./.;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.ghc
            pkgs.cabal-install
          ];
        };

        packages = {
          inherit test-ghc;
          default = test-ghc;
        };
      };
    };
}
