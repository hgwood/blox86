rm -r target
mkdir -p target
nasm -f bin -o target/blox86.bin src/main.asm
mkdir -p target/iso
cp target/blox86.bin target/iso/blox86.bin
genisoimage -no-emul-boot -boot-load-size 4 -o target/blox86.iso -b blox86.bin target/iso/
rm -r target/iso
