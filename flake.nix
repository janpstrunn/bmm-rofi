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
      bmm-rofi = pkgs.stdenv.mkDerivation {
        name = "bmm-rofi";
        src = ./src;
        nativeBuildInputs = [pkgs.makeWrapper pythonWithPackages];
        installPhase = ''
          mkdir -p $out/bin
          cp bmm-rofi $out/bin/bmm-rofi
          chmod +x $out/bin/bmm-rofi
          wrapProgram "$out/bin/bmm-rofi" \
            --prefix PATH : "${pkgs.lib.makeBinPath [pythonWithPackages]}"
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
