;==============================================================================;
; nesmon/src/header/mpr100.asm
; NES 2.0 header for Mapper 100 (exclusively for Nintendulator)
;==============================================================================;
; Primarily made so I can see what Nintendulator's Mapper 100/Debug Mapper is
; all about. I think it's what I'm looking for in terms of RAM cart emulation.
;==============================================================================;
; Configuration
.ignorenl
	; Mirroring: 0=Horizontal, 1=Vertical
	HDR_MIRRORING = 0

	; Battery-backed SRAM
	HDR_BATTERY = 0

	HDR_PRGRAM_SIZE
	HDR_PRGRAMB_SIZE
.endinl
;==============================================================================;
; begin header
	.db "NES",$1A
	.db 1	;number of 16K PRG ROM pages
	.db 0	;number of 8K CHR ROM pages (or 0 for CHR-RAM)

	;flags 6
	.db %01000000 | HDR_BATTERY<<1 | HDR_MIRRORING
	;    |  |||||
	;    |  |||||_ Mirroring (set above)
	;    |  ||||__ Battery backed SRAM (set above)
	;    |  |||___ 512 byte "Trainer" at $7000-$71FF
	;    |  ||____ Four screen mode
	;    |__|_____ Mapper number bits 3-0

	;flags 7
	.db %01101000
	;    |  |||||
	;    |  |||||_ VS system
	;    |  ||||__ Playchoice 10
	;    |  ||L___ NES 2.0 indicator
	;    |__|_____ Mapper number bits 7-4

	;Byte 8/Mapper Variant
	.db %00000000
	;    |__||__|
	;      |   |
	;      |   |___ Mapper number bits 11-8
	;      |_______ Submapper number (0=no submapper)

	;Byte 9/ROM size upper bits
	.db %00000000
	;    |__||__|
	;      |   |
	;      |   |___ PRG ROM
	;      |_______ CHR ROM

	;Byte 10/RAM size
	.db %00000000
	;    |__||__|
	;      |   |
	;      |   |___ Non-battery backed PRG RAM
	;      |_______ Battery backed PRG RAM/Serial EEPROM

	;Byte 11/Video RAM size
	.db %00000111
	;    |__||__|
	;      |   |
	;      |   |___ Non-battery backed CHR RAM
	;      |_______ Battery backed CHR RAM

	;Byte 12/TV System
	.db %00000000
	;          ||
	;          ||_ NTSC/PAL flag (0=NTSC, 1=PAL)
	;          |__ Dual compatibility flag (game detects and adjusts accordingly)

	;Byte 13/VS Hardware
	.db %00000000
	;    |__||__|
	;      |   |
	;      |   |___ PPU
	;      |_______ Mode

	.db $00,$00 ;filler
