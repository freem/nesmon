;==============================================================================;
; nesmon/src/routines_wram.asm
; Routines that involve WRAM access/modification
;==============================================================================;
; Routine naming: wram_*
;==============================================================================;

;==============================================================================;
; WRAM Checks
;==============================================================================;
; wram_Check6000
; Check for WRAM at $6000.

wram_Check6000:
	lda $6000
	sta tmp00			; save original value
	lda #$AA
	sta $6000			; write new value
	lda $6000
	cmp tmp00			; compare
	beq @noWRAM6000

	; WRAM exists at $6000 (and hopefully up to $7FFF)
	lda cartPRGRAM
	ora #%00000001
	sta cartPRGRAM

	; clear things we've messed with
	lda #0
	sta $6000
	sta tmp00
	beq @end

@noWRAM6000:
	lda cartPRGRAM
	and #%11111110
	sta cartPRGRAM

@end:
	rts

;==============================================================================;
