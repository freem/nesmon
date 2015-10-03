nesmon - a native NES/Famicom monitor program
=============================================
! Super Warning !
This is a work in progress and is not "production ready".

(Hell, at this point, it doesn't even output keyboard strokes to the screen!
It does manage to read them... as long as you're using the Family BASIC
keyboard and not the Subor or PEC-586 ones.)

================================================================================
[Table of Contents]
 1.      Introduction
 2.      Versions
  2.1    Mapper 100 Version
  2.2    FME-7 Version
  2.3    NROM Version
  2.4    Future Versions?
 3.      Usage
 4.      Commands
 ?.      Assembling from Source

================================================================================
1. Introduction
================================================================================
nesmon is a machine code monitor for the NES/Famicom. The platform is an odd
choice, but I really wanted to see if it could be done.

It is highly unlikely that you will be able to use this in a full project.

For those not familiar with the concept of a machine code monitor, please view
http://www.c64-wiki.com/index.php/Machine_Code_Monitor
until I stop being lazy and edit this further.

================================================================================
2. Versions
================================================================================
Multiple versions of the monitor can be assembled. The versions are different
based on cart configuration.

Included profiles:
* Nintendulator Debugging Mapper (Mapper 100)
* Sunsoft FME-7 (Mapper 069)
* NROM (Mapper 000)

--------------------------------------------------------------------------------
2.1 Mapper 100 Version
--------------------------------------------------------------------------------
The Mapper 100 version is meant for use in Nintendulator.
This is the recommended version to run, as you are able to simulate a RAM cart
with the correct settings.

"Mapper 100 (Debug) Bank Selection" dialog values for basic RAM cart operation:

(PRG section)
PRG $6000-$7FFF: 0, RAM(2)
PRG $8000-$9FFF: 1, RAM(2)
PRG $A000-$BFFF: 2, RAM(2)
PRG $C000-$DFFF: 0, ROM(1)
PRG $E000-$FFFF: 1, ROM(1)

I am not sure what the numbers for the top three banks should be.

(Tile data section)
CHR $0000-$03FF: 0, RAM(2)
CHR $0400-$07FF: 1, RAM(2)
CHR $0800-$0BFF: 2, RAM(2)
CHR $0C00-$0FFF: 3, RAM(2)
CHR $1000-$13FF: 4, RAM(2)
CHR $1400-$17FF: 5, RAM(2)
CHR $1800-$1BFF: 6, RAM(2)
CHR $1C00-$1FFF: 7, RAM(2)

(for Horizontal Mirroring)
CHR $2000-$23FF: 0, Nametable(3)
CHR $2400-$27FF: 1, Nametable(3)
CHR $2800-$2BFF: 0, Nametable(3)
CHR $2C00-$2FFF: 1, Nametable(3)

(for Vertical Mirroring)
CHR $2000-$23FF: 0, Nametable(3)
CHR $2400-$27FF: 0, Nametable(3)
CHR $2800-$2BFF: 1, Nametable(3)
CHR $2C00-$2FFF: 1, Nametable(3)

--------------------------------------------------------------------------------
2.2 FME-7 Version
--------------------------------------------------------------------------------
Sunsoft's FME-7 mapper IC allows for fine-grained 8KB PRG banking and 1KB CHR
banking. However, no known FME-7 game uses CHR-RAM, so it's unknown if this
combination will work on hardware.

Only the $6000-$7FFF section may be used as RAM (without modifications?), but
the FME-7 allows for 512K total PRG-RAM (banked).

--------------------------------------------------------------------------------
2.3 NROM Version
--------------------------------------------------------------------------------
The last resort is the NROM version. The only PRG-RAM available is $6000-$7FFF,
without bankswitching. It's worth noting that NROM with CHR-RAM is a very
unorthodox setup, and may not be supported on every emulator.

--------------------------------------------------------------------------------
2.4 Future Versions?
--------------------------------------------------------------------------------
There may be other versions in the future. Some are on more realistic boards
and can be added easily, others will require different branches.

Candidates, in no particular order:
* Famicom Disk System (Disk System's RAM cart gives 32KB of PRG-RAM at $6000-$DFFF)
* MMC1 (bankswitchable PRG-RAM, up to 32K)
* MMC5 (64KB of PRG-RAM, can map $6000-$DFFF to PRG-RAM; MMC5 ICs hard to source)
* MMC6 (1KB PRG-RAM at $7000-$7FFF)
* UxROM with PRG-RAM circuit
* VRC7 (Similar PRG/CHR banking setup to FME-7, but only 8K of PRG-RAM)

2.4.1 Famicom Disk System
-------------------------
The main problem is that the FDS BIOS sits at $E000-$FFFF, and the monitor will
need to sit slightly above that. At nesmon's full size (16K), that's half of the
available PRG-RAM space, which is less than ideal.

Since a Disk System version would need a different codebase anyways, some of
nesmon's code could be replaced with calls to the relevant FDS BIOS routines.

2.4.2 MMC1
----------
The MMC1 allows you to have up to 32K of PRG-RAM (banked in 8KB sections).
However, there are only 6 games with 32K of PRG-RAM, and only one of those was
released outside of Japan. (Technically it's five games, as "Sangokushi II" and
"Romance of the Three Kingdoms II" are the Japanese/English versions.)

If you don't want to chop up a Koei cart, your options are even more slim...
Modifying a "Final Fantasy I & II" cart or "The Best Play Pro Yakyuu Special"
are the only other choices.

2.4.3 MMC5
----------
This is another category where Koei games dominate the list of real carts. MMC5
is also the board that all non-Japanese releases of "Castlevania III" are on.

"MMC5 ICs hard to source" is noted above. As far as I know, there are no
hardware clones of the MMC5 available for use on carts. Some flashcarts can run
MM5 games (with varying levels of support).

Not mentioned above is the 1KB of EXRAM, which can be used for program code
or data. However, it can also be used for other purposes.

The ability to map PRG-RAM from $6000-$DFFF makes the MMC5 a decent substitute
for a FDS RAM adaptor cart.

2.4.4 MMC6
----------
This is a highly unlikely candidate, but it's listed here for completion.

2.4.5 UxROM with PRG-RAM circuit
--------------------------------
An alternative to the NROM with CHR-RAM setup.

2.4.6 VRC7
----------
(todo)


================================================================================
3. Usage
================================================================================
nesmon is best used with a hardware keyboard. However, the official keyboard was
only released in Japan and will only easily work on Famicoms without hardware
modification.

Holding the A and B buttons on controller 1 for 3 seconds will display the
software keyboard (if it isn't already shown).

Holding Select on controller 1 for 3 seconds will toggle the monitor.
Holding Start+Select on controller 1 for 3 seconds will reboot the monitor.

================================================================================
4. Commands
================================================================================
(work in progress)

================================================================================
?. Assembling from Source
================================================================================
To get the most out of nesmon, you'll need to set up a development environment
for NES work. Since I use the nonstandard .ignorenl/.endinl directives, the
source requires asm6f [https://github.com/freem/asm6f/] to assemble.

Lua 5.x is required for running the datetime script.
I can't reliably guarantee that every system is going to have the GNU datetime
command (nor Lua, but it's easier to get Lua installed on other OSes), so I'm
using a simple Lua script for generating the date and time.

The build process uses a Makefile, but each command can be run without needing
GNU Make.

With GNU Make, the process is simple:
1) Start a terminal/command prompt.

2) cd to the nesmon "src" directory.

3) Open "Makefile" in a text editor and edit any customization options.

4) Run one of the following commands:
 4.1) "make all" (or just "make")
 This will build all of the targets mentioned below (aside from clear)

 4.2) "make nrom"
 This will create an NROM configuration of nesmon.

 4.3) "make m100"
 This will create a Nintendulator Debugging Mapper (mapper 100) nesmon.

 4.4) "make fme7"
 This will create a FME-7 configuration of nesmon.
 
 4.5) "make clean"
 This will delete the binaries and .nl files. Don't run this one the first time :p

5) Find a way to run the tool.

For emulators, you just run the NES image.
If you're using the Nintendulator Debugging Mapper (mapper 100), remember to
open the "Game" menu, set the options above, hit "Apply", then Reset the system.

The hardware side, is, well, harder. Pun aside, you'll need to have some way of
loading nesmon (preferably with a custom RAM cart). I currently do not have any
schematics or plans for such a cart, though a RAM cart (or flash cart) could work.

