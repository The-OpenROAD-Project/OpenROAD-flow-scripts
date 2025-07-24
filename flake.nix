{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    openroad-abc-src = {
      url = "git+file:tools/OpenROAD/third-party/abc";
      flake = false;
    };
    openroad-opensta-src = {
      url = "git+file:tools/OpenROAD/src/sta";
      flake = false;
    };
    openroad-flake = {
      url = "git+file:tools/OpenROAD";
      flake = true;
    };
    yosys-abc-src = {
      url = "git+file:tools/yosys/abc";
      flake = false;
    };
    yosys-cxxopts-src = {
      url = "git+file:tools/yosys/libs/cxxopts";
      flake = false;
    };
    yosys-flake = {
      url = "git+file:tools/yosys";
      flake = true;
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    openroad-abc-src,
    openroad-opensta-src,
    openroad-flake,
    yosys-abc-src,
    yosys-cxxopts-src,
    yosys-flake,
  }: flake-utils.lib.eachDefaultSystem (
    system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        openroad = (openroad-flake.packages.${system}.default.overrideAttrs (previousAttrs: {
          prePatch = builtins.concatStringsSep "\n" [
            (''
              cp -r --preserve=mode ${openroad-opensta-src} src/sta
              chmod -R +w src/sta
              cp -r --preserve=mode ${openroad-abc-src} third-party/abc
              chmod -R +w third-party/abc
            '')
            (previousAttrs.prePatch or "")
          ];
        }));
        yosys-abc = pkgs.stdenv.mkDerivation {
          name = "yosys-abc";
          src = "${yosys-abc-src}";
          nativeBuildInputs = [ pkgs.cmake ];
          buildInputs = [ pkgs.readline ];
          installPhase = ''
            runHook preInstall
            install -Dm755 'abc' "$out/bin/abc"
            install -Dm444 'libabc.a' "$out/lib/libabc.a"
            runHook postInstall
          '';
          buildPhase = ''
            make ABC_USE_PIC=1 abc libabc.a
          '';
        };
        yosys = (yosys-flake.packages.${system}.default.overrideAttrs (previousAttrs: {
          prePatch = builtins.concatStringsSep "\n" [
            (''
              cp -r --preserve=mode ${yosys-cxxopts-src} libs/cxxopts
              chmod -R +w libs/cxxopts
            '')
            (previousAttrs.prePatch or "")
          ];
          installPhase = ''
            make install PREFIX=$out ABCEXTERNAL=yosys-abc
            ln -s ${yosys-abc}/bin/abc $out/bin/yosys-abc
          '';
        }));
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          openroad
          yosys-abc
          yosys
          pkgs.time
          pkgs.klayout
          pkgs.verilator
          pkgs.perl
          pkgs.python3
          pkgs.python3Packages.pandas
          pkgs.python3Packages.numpy
          pkgs.python3Packages.firebase-admin
          pkgs.python3Packages.click
          pkgs.python3Packages.pyyaml
          pkgs.python3Packages.yamlfix
        ];
      };
      packages.openroad = openroad;
      packages.yosys-abc = yosys-abc;
      packages.yosys = yosys;
    }
  );
}
