CXX := riscv32-unknown-elf-g++

CXXFLAGS := -mabi=ilp32f -march=rv32gcv -fno-PIC -Iinclude
LDFLAGS := -static -mcmodel=medany

.PHONY: all
all: build/bert.elf

build/bert.S: src/bert-with-weights.mlir
	buddy-opt $^ \
		--linalg-bufferize \
		--convert-linalg-to-loops \
		--func-bufferize \
		--arith-bufferize \
		--tensor-bufferize \
		--finalizing-bufferize \
		--convert-vector-to-scf \
		--convert-scf-to-cf \
		--expand-strided-metadata \
		--lower-affine \
		--convert-vector-to-llvm \
		--memref-expand \
		--arith-expand \
		--convert-arith-to-llvm \
		--finalize-memref-to-llvm \
		--convert-math-to-llvm \
		--llvm-request-c-wrappers \
		--convert-func-to-llvm \
		--reconcile-unrealized-casts | \
	buddy-translate --mlir-to-llvmir | \
	buddy-llc -O3 -mtriple riscv32 -target-abi ilp32 \
		-mattr=+m,+v,+zve32f -filetype=asm -riscv-v-vector-bits-min=128 \
		-o $@

build/spike-main.o: src/spike-main.cpp
	$(CXX) $^ $(CXXFLAGS) -c -o $@

build/bert.elf: build/spike-main.o build/bert.S
	$(CXX) $^ $(CXXFLAGS) $(LDFLAGS) -o $@

.PHONY: clean
clean:
	rm -f build/*.o build/*.elf
