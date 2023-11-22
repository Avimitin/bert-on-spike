# Reproduce the bert spike error

```bash
mkdir -p build
nix develop
make
nix build .#rv32-pk -L
spike --isa=rv32gcv ./result/bin/pk ./build/bert.elf
```

# Debug mode

```console
$ spike --isa=rv32gcv ./result/bin/pk ./build/bert.elf
bbl loader
z  00000000 ra 0001cef4 sp 7ffffcd0 gp 010fd780
tp 00000000 t0 00000000 t1 00000001 t2 014d4644
s0 7ffffd44 s1 00000000 a0 014d4658 a1 014d4680
a2 00000001 a3 00000000 a4 7ffffce8 a5 00000000
a6 00037af0 a7 00000001 s2 00000000 s3 00000000
s4 00000000 s5 00000000 s6 00000000 s7 00000000
s8 00000000 s9 00000000 sA 00000000 sB 00000000
t3 00000000 t4 00000000 t5 00000000 t6 00000000
pc 0001cf24 va/inst 02047427 sr 80006620
^---------^
Store/AMO access fault!

$ spike -d --isa=rv32gcv ./result/bin/pk ./build/bert.S
: until pc 0 1cf24
: r 1
core   0: 0x0001cf24 (0x02047427) vse64.v v8, (s0)
core   0: exception trap_store_address_misaligned, epc 0x0001cf24
core   0:           tval 0x7ffffd44
```
