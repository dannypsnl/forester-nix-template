{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    forest-server = {
      url = "github:kentookura/forest-server?rev=b639db42be56a0241e2903cc27d2a8a317a6cfbf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    forester = {
      url = "sourcehut:~jonsterling/ocaml-forester?rev=ff43ce64865ffdc8a4394abbbd3dae6bc9f82471";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              forest-server = inputs.forest-server.packages.${system}.default;
              forester = inputs.forester.packages.${system}.default;
            })
          ];
        };
        stdenv = pkgs.stdenv;

        build = pkgs.writeShellScriptBin "build" ''
          forester build --dev forest.toml
        '';

        cleanup = pkgs.writeShellScriptBin "cleanup" ''
          rm -rvf output
          pushd deploy
          rm -rvf output
          popd
        '';

        release = pkgs.writeShellScriptBin "release" ''
          pushd deploy
          forester build forest.toml
          popd
        '';

        sharedInputs = with pkgs; [
          # tools
          forester
          forest-server
          texlive.combined.scheme-full
          libxslt
          # commands
          build
          release
          cleanup
        ];

        forest = stdenv.mkDerivation {
          name = "your forest";
          src = ./.;
          installPhase = ''
            mkdir -p $out/bin
            cp ${pkgs.forest-server}/bin/forest $out/bin/forest
            cp ${pkgs.forester}/bin/forester $out/bin/forester
          '';
          dontConfigure = true;
          dontBuild = true;
          buildInputs = sharedInputs;
        };
      in
      with pkgs; {
        packages = {
          default = forest;
        };
        devShells.default = mkShell {
          buildInputs = sharedInputs;
        };

        formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      });
}
