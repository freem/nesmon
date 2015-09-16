;==============================================================================;
; nesmon/src/nesmon.asm
; Main file (lays out the program binary)
;==============================================================================;
; Global includes/defines
.include "nes.inc"
.include "ram.inc"
.include "opcodes.inc"

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

.org $C000

;------------------------------------------------------------------------------;
; pretty important!
.include "nmi.asm"
.include "irq.asm"
.include "reset.asm"

;------------------------------------------------------------------------------;
; character set
.include "charsets_1bpp/charset.asm"

;------------------------------------------------------------------------------;
; general system routines
.include "routines_ppu.asm"
.include "routines_io.asm"

;------------------------------------------------------------------------------;
; keyboard routines
.include "input/kb_soft.asm" ; always include software keyboard

.ifndef KB_FAMIBASIC
	.ifndef KB_SUBOR
		.error "At least one hardware keyboard (KB_FAMIBASIC, KB_SUBOR) must be enabled."
	.endif
.endif

; caveat: only use one hardware keyboard at a time
.ifdef KB_FAMIBASIC
	.include "input/kb_famibasic.asm"
.else
	.ifdef KB_SUBOR
	.include "input/kb_subor.asm"
	.endif
.endif

;------------------------------------------------------------------------------;
; nesmon default modules
.include "modules/microasm.asm"
.include "modules/editor.asm"

;==============================================================================;
; Vectors

.org $FFFA
	.dw NMI ; NMI
	.dw Reset ; Reset
	.dw IRQ ; IRQ (Monitor!)

;==============================================================================;