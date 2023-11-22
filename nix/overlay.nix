final: prev:

{
  buddy-mlir = final.callPackage ./buddy-mlir.nix { };
  rv32-gnu-toolchain = final.callPackage ./riscv-gnu-toolchain.nix { };
  rv32-pk = final.callPackage ./rv32-pk.nix { };

  # The official spike hard-coded to use riscv64-embedded to run install check phrase.
  spike = prev.spike.overrideAttrs {
    doInstallCheck = false;
    installCheckPhase = null;
  };
}
