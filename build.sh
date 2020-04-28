rm -r target
mkdir -p target
nasm -f bin -o target/boot.flp src/boot.asm
mkdir -p target/iso
cp target/boot.flp target/iso/boot.flp
genisoimage -no-emul-boot -boot-load-size 4 -o target/boot.iso -b boot.flp target/iso/
