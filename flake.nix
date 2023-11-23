{
  description = "vector";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }@inputs:
    let
      overlay = import ./nix/overlay.nix;
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
        in
        {
          legacyPackages = pkgs;
          devShells = {
            default = pkgs.mkShell {
              buildInputs = with pkgs; [
                rv32-gnu-toolchain
                buddy-mlir
                spike
              ];
            };
            rv64 = pkgs.mkShell {
              buildInputs = with pkgs; [
                pkgsCross.riscv64.gcc
                buddy-mlit
                spike
              ];
            };
          };
        }
      )
    // { inherit inputs; overlays.default = overlay; };
}
