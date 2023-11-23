final: prev:

{
  buddy-mlir = final.callPackage ./buddy-mlir.nix { };
  rv32-gnu-toolchain = final.callPackage ./riscv-gnu-toolchain.nix { };
  rv64-gnu-toolchain = final.rv32-gnu-toolchain.overrideAttrs {
    configureFlags = [
      "--with-arch=rv64gcv"
      "--with-abi=lp64d"
    ];
  };
  rv32-pk = final.callPackage ./rv32-pk.nix {
    riscv-gnu-toolchain = final.rv32-gnu-toolchain;
  };
  rv64-pk = (final.rv32-pk.override {
    riscv-gnu-toolchain = final.rv64-gnu-toolchain;
  }).overrideAttrs {
    configureFlags = [
      "--with-arch=rv64gcv"
      "--with-abi=lp64d"
      "--host=riscv64-unknown-elf"
    ];
  };

  # The official spike hard-coded to use riscv64-embedded to run install check phrase.
  spike = prev.spike.overrideAttrs {
    doInstallCheck = false;
    installCheckPhase = null;
  };
}
