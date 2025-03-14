{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    openroad = {
      type = "git";
      url = "https://github.com/The-OpenROAD-Project/OpenROAD";
      submodules = true;
      rev = "ec1bf1a13902813b722f8341c432cd09714d9e55";
    };
    yosys = {
      type = "git";
      url = "https://github.com/The-OpenROAD-Project/yosys";
      submodules = true;
      rev = "c4b5190229616f7ebf8197f43990b4429de3e420";
    };
  };
  outputs = { self, nixpkgs, flake-utils, openroad, yosys }: flake-utils.lib.eachDefaultSystem (
    system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          openroad.packages.${system}.default
          yosys.packages.${system}.default
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
    }
  );
}
