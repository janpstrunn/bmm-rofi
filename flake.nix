{
  description = "A flake to run bmm-rofi with Python dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      pythonWithPackages = pkgs.python3.withPackages (ps: [
        ps.requests
        ps.beautifulsoup4
      ]);
      rustPlatform = pkgs.rustPlatform;
      bmm = rustPlatform.buildRustPackage {
        pname = "bmm";
        version = "0.3.0";
        src = pkgs.fetchFromGitHub {
          owner = "dhth";
          repo = "bmm";
          rev = "v0.3.0";
          hash = "sha256-sfAUvvZ/LKOXfnA0PB3LRbPHYoA+FJV4frYU+BpC6WI=";
        };
        cargoLock = {
          lockFile = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/dhth/bmm/refs/heads/main/Cargo.lock";
            hash = "sha256-DiNwacz6AZnS0QO3EUHK8tzBCO+zwyDWrwrbp2r3UEA=";
          };
        };
      };
      bmm-rofi = pkgs.stdenv.mkDerivation {
        name = "bmm-rofi";
        src = ./src;
        nativeBuildInputs = [
          bmm
          pkgs.makeWrapper
          pkgs.rofi
          pythonWithPackages
        ];
        installPhase = ''
          mkdir -p $out/bin
          cp bmm-rofi $out/bin/bmm-rofi
          chmod +x $out/bin/bmm-rofi
          wrapProgram "$out/bin/bmm-rofi" \
            --prefix PATH : "${pkgs.lib.makeBinPath [pythonWithPackages bmm pkgs.rofi]}"
        '';
        meta = {
          description = "bmm-rofi";
          homepage = "https://github.com/janpstrunn/bmm-rofi";
          license = pkgs.lib.licenses.mit;
        };
      };
    in {
      packages.default = bmm-rofi;
      apps.default = {
        type = "app";
        program = "${bmm-rofi}/bin/bmm-rofi";
      };
    });
}
