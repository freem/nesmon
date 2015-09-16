nesmon - a native NES/Famicom monitor program
=============================================
! Super Warning !
This is a work in progress and is not "production ready".
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

================================================================================
1. Introduction
================================================================================
nesmon is a machine code monitor for the NES/Famicom. The platform is an odd
choice, but I really wanted to see if it could be done.

It is highly unlikely that you will be able to use this in a full project.

For those not familiar with the concept of a machine code monitor, please view
http://www.c64-wiki.com/index.php/Machine_Code_Monitor

================================================================================
2. Versions
================================================================================
Multiple versions of the monitor can be assembled. The versions are different
based on cart configuration.

Included profiles:
* NROM (Mapper 000)
* Sunsoft FME-7 (Mapper 069)
* Nintendulator Debugging Mapper (Mapper 100)

--------------------------------------------------------------------------------
2.1 Mapper 100 Version
--------------------------------------------------------------------------------
The Mapper 100 version is meant for use in Nintendulator.
This is the recommended version to run, as you are able to simulate a RAM cart.

"Mapper 100 (Debug) Bank Selection" dialog values for basic RAM cart operation:

(PRG section)
PRG $6000-$7FFF: 0, RAM(2)
PRG $8000-$9FFF: 2, RAM(2)
PRG $A000-$BFFF: 3, RAM(2)
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

(Horizontal Mirroring)
CHR $2000-$23FF: 0, Nametable(3)
CHR $2400-$27FF: 1, Nametable(3)
CHR $2800-$2BFF: 0, Nametable(3)
CHR $2C00-$2FFF: 1, Nametable(3)

(Vertical Mirroring)
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
the FME-7 allows for 512K total PRG-RAM (just banked).

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

Candidates:
* UxROM with PRG-RAM circuit
* Famicom Disk System

================================================================================
3. Usage
================================================================================
Holding Select on controller 1 for 3 seconds will toggle the monitor.
Holding Start+Select on controller 1 for 3 seconds will reboot the monitor.



================================================================================
4. Commands
================================================================================
(work in progress)
