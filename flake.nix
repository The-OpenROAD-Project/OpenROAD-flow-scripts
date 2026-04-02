{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    openroad = {
      type = "git";
      url = "https://github.com/The-OpenROAD-Project/OpenROAD";
      submodules = true;
      rev = "ce7ee82f49a965e90de5dfc8de6e4d7d32534984";
    };
    yosys = {
      type = "git";
      url = "https://github.com/YosysHQ/yosys";
      submodules = true;
      ref = "nella/carry-save-adders";
      rev = "0909e462c3efc2ecd9395e1d69485f9ad4027857";
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
