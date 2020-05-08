# blox86

A text-based block-breaking game. It is written in 8086 16-bits assembly, and runs on top of a BIOS in real mode.

It was made as an entry to a small contest organized by my co-workers. I learned assembly specifically for this project, so the code is probably not good at all. The game is not compatible with UEFI. The only tested environment is a VirtualBox VM without UEFI enabled.

## How to run 🚀

- Install VirtualBox.
- Build the bootable ISO with `docker-compose run --rm build`.
- Create a VM and mount `target/boot.iso` into the CD drive.
- Run the VM.

## Game controls

- Left/right arrow: move
- Space: pause
