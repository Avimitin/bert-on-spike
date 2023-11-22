{ stdenvNoCC, rv32-gnu-toolchain, fetchFromGitHub, autoreconfHook }:

stdenvNoCC.mkDerivation rec {
  pname = "riscv-pk";
  version = "unstable-710c23a";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "riscv-pk";
    rev = "710c23a5bbeecf171ac86d6e39d275af8f176354";
    sha256 = "sha256-jW+4RRXcu9UQFk1TxSCNHi/C1dRQu27QlLPG66tY2T4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    rv32-gnu-toolchain
  ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  configureFlags = [
    "--with-arch=rv32gcv"
    "--with-abi=ilp32f"
    "--host=riscv32-unknown-elf"
  ];

  configureScript = "../configure";

  hardeningDisable = [ "all" ];

  postInstall = ''
    mv $out/* $out/.cleanup
    mv $out/.cleanup/* $out
    rmdir $out/.cleanup
  '';
}
