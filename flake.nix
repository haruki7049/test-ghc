{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inputs = inputs; } {
      systems = import inputs.systems;

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        { pkgs, lib, ... }:
        let
          test-ghc = pkgs.haskellPackages.developPackage { root = lib.cleanSource ./.; };
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.cabal-fmt.enable = true;
            programs.ormolu.enable = true;
          };

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
