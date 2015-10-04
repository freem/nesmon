;==============================================================================;
; nesmon/src/nesmon.asm
; Main file (lays out the program binary)
;==============================================================================;
; Global includes/defines
.include "nes.inc"
.include "ram.inc"
.include "opcodes.inc"

; nesmon configuration
.include "config.inc"

;==============================================================================;
; ROM header(s)

; Mapper 100 for Nintendulator
.ifdef M100
	.include "header/mpr100.asm"
.endif

; NROM for most other emulators
.ifdef NROM
	.include "header/nrom.asm"
.endif

; FME-7 for its superior banking capability
.ifdef FME7
	.include "header/fme7.asm"
.endif

.ifndef NROM
	.ifndef M100
	.ifndef FME7
		.error "Unknown or undefined mapper type; Must define one of {M100, NROM, FME7}"
	.endif ; FME7
	.endif ; M100
.endif

;==============================================================================;
; [Program Code]
; The limitations of current emulators means that we need to throw at least one
; full 16K bank into a ROM. No, I don't want to do what Galaxian does.

; I am really hoping my code doesn't expand too much, but it is a bit more
; complicated than just a bootloader.
;==============================================================================;

.org $C000

; Cart identification
cartSignature:
	;    ----------------
	.db "NES MONITOR ROM "
	.incbin "datetime.bin"
	;    ----------------

; version information
cartVersion:
	.db $00 ; major
	.db $00 ; minor

; mapper/hardware type (defined at assemble time)
; All entries should be 16 characters, left-aligned with spaces.
cartType:
.ifdef NROM
	;    ----------------
	.db "NROM            "
.endif
.ifdef M100
	;    ----------------
	.db "Nintendulator100"
.endif
.ifdef FME7
	;    ----------------
	.db "FME-7           "
.endif

; reset detection string
resetString: .db "nesmon"

;------------------------------------------------------------------------------;
; pretty important!
.include "nmi.asm"
.include "irq.asm"
.include "reset.asm"

;------------------------------------------------------------------------------;
; mapper routines (if needed)
.ifdef FME7
	.include "mapper/fme7.asm"
.endif

;------------------------------------------------------------------------------;
; character set
.include "charsets_1bpp/charset.asm"

;------------------------------------------------------------------------------;
; general system routines
.include "routines_ppu.asm"
.include "routines_io.asm"
.include "routines_wram.asm"

;==============================================================================;
; general nesmon routines
;==============================================================================;
; nesmon_ClearModuleRAM
; Clears Module RAM. Should be called in every module's init routine, unless
; that routine is meant to modify Module RAM. :V

nesmon_ClearModuleRAM:
	lda #0
	tax
@clearModuleRam:
	sta moduleRAM,x
	inx
	cpx #64
	bne @clearModuleRam
	rts

;==============================================================================;
; keyboard routines
.include "input/keyboard.inc"
.include "input/kb_soft.asm" ; always include software keyboard

.ifndef KB_FAMIBASIC
	.ifndef KB_SUBOR
		.error "At least one hardware keyboard (KB_FAMIBASIC, KB_SUBOR) must be enabled."
	.endif
.endif

; caveat: only allows one hardware keyboard at a time
; switchable keyboard support may exist in the future.

.ifdef KB_FAMIBASIC
	.include "input/kb_famibasic.asm"
.else
	.ifdef KB_SUBOR
	.include "input/kb_subor.asm"
	.endif
.endif

;==============================================================================;
; [nesmon default modules]
; --editor--
.include "modules/editor.asm"    ; editor program (main interface)
.include "modules/commands.asm"  ; command parser and handler
; --assembler--
.include "modules/microasm.asm"  ; micro 6502 assembler

;------------------------------------------------------------------------------;
; [nesmon optional modules]
.ifndef WITHOUT_CHRVIEW
.include "modules/chrview.asm"   ; CHR Viewer/Editor ("chrview") module
.endif

.ifndef WITHOUT_TAPE
.include "modules/tapemod.asm"   ; Cassette tape module
.endif

;==============================================================================;
; Vectors

.org $FFFA
	.dw NMI ; NMI
	.dw Reset ; Reset
	.dw IRQ ; IRQ (Monitor entry!)
