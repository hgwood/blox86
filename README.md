# blox86

A text-based block-breaking game. It is written in x86 16-bits assembly, and runs on top of a BIOS in real mode.

It is compiled into a flat executable. It does not respect any binary format, and thus is not compatible with any OS.
The only way to run it is to boot a machine with it. A machine with a BIOS. It not compatible with UEFI.
The only tested environment is a VirtualBox VM without UEFI enabled.

It was made as an entry to a small contest organized by my co-workers. I learned assembly specifically for this project, so the code is probably not good at all.

## How to run 🚀

- Install VirtualBox.
- Build the bootable ISO with `docker-compose run --rm build`.
- Create a VM and mount `target/boot.iso` into the CD drive.
- Run the VM.

## Game controls

- Left/right arrow: move
- Space: pause
- I: invincible mode, the ball will always bounce off the bottom of the arena

## Tweaking gameplay

Edit `src/constants.asm` to change how the game behaves.
