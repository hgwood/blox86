rm -r target
mkdir -p target
nasm -f bin -o target/boot.bin src/boot.asm
mkdir -p target/iso
cp target/boot.bin target/iso/boot.bin
genisoimage -no-emul-boot -boot-load-size 4 -o target/boot.iso -b boot.bin target/iso/
