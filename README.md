# blox86

A text-based block-breaking game. It is written in x86 16-bits assembly, and
runs on top of a BIOS in real mode.

It is compiled into a flat executable. It does not respect any binary format,
and thus is not compatible with any OS. The only way to run it is to boot a
machine with it. A machine with a BIOS. It not compatible with UEFI. The only
tested environment is a VirtualBox VM without UEFI enabled.

## Why?

My co-workers organized a contest where the goal was to write a text-based
block-breaking game (under a deadline). Any tech could be used, so I ceased the
opportunity to learn new stuff. The initial challenge I imposed to myself was:
let's make this with as little dependencies as possible. Can I write a program
that doesn't even need an OS?

So what did I learn?

- [How does a BIOS-based PC
  start?](https://wiki.osdev.org/System_Initialization_(x86))
- [What makes a program
  bootable?](http://mikeos.sourceforge.net/write-your-own-os.html)
- x86 CPUs, for compatibilty reasons, start in [a 16-bits mode called "real
  mode"](https://wiki.osdev.org/Real_mode). Transitioning to 32 or 64-bits modes
  (aka [protected mode](https://wiki.osdev.org/Protected_Mode) and [long
  mode](https://wiki.osdev.org/Long_Mode) respectively) requires code. Programs
  running in these "more advanced" mode loose access to the BIOS API.
- The BIOS has an API that a program can use (if in real mode) to communicate
  with devices like the keyboard, screen, drives, clock.
- The 8086 and 80186 [instruction
  sets](https://en.wikipedia.org/wiki/X86_instruction_listings) and
  [registers](https://en.wikipedia.org/wiki/X86#16-bit).
- [The NASM language](https://www.nasm.us/).
- Programming using only 8 and 16-bits integers, especially with regards to
  calculating the ball trajectory.
- Programming without any logs or debugger.

## Disclaimer

Since I've learned pretty much everything for this project, the code is probably
not good at all and should not be taken as an example for anything.

## How to run 🚀

- Install VirtualBox.
- Build the bootable ISO with `docker-compose run --rm build`.
- Create a VM and mount `target/blox86.iso` into the CD drive.
- Run the VM.

## Game mechanics

### Controls

- ⬅/➡: move
- Space: pause
- `I`: invincible mode (the ball will always bounce off the bottom of the arena)

### Tweaking gameplay

Edit `src/constants.asm` to change how the game behaves. You'll have to rebuild
the program to apply the changes.

### How collisions work

Collisions are handled as follows:
1. Update the horizontal ball position according to its horizontal speed
2. If the new position is taken by a wall or block, rewind to the original
   position, reverse the horizontal speed, and restart. Notice that the position
   that is checked here is *not* the next ball position as the vertical position
   has not been updated yet. This means balls that move horizontally bounce off
   blocks next to them, irrelevant of their vertical movement (see figure 1).
3. Do the same for the vertical axis. Notice that this time, the horizontal
   position has already been updated. This means that balls that move both
   vertically and horizontally do *not* hit blocks above or below them (see
   figure 2).

Figure 1: ball bounces off a block on its right (`H` is a block, numbers are
successive positions of the ball).

```
------
| 4  |
|  3H|
| 2  |
|1   |
------
```

Figure 2: ball does not bounce off a block above it.

```
------
|  H4|
|  3 |
| 2  |
|1   |
------
```

This is especially important in player interactions. When the ball is above the
edge of the player and the ball's next position is not 'inside' the player, the
ball *will* go through and the player will lose, as shown in figure 3.

Figure 3: player is surprised by the collision system!

```
-------
| 1   |
|  2  |
|   3 |
| TTT4|
-------
```

This implementation was chosen because it is easy to code, and time was limited
in the context of the contest.
