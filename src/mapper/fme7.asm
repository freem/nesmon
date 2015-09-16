;==============================================================================;
; nesmon/src/mapper/fme7.asm
; Sunsoft FME-7 Mapper related code
;==============================================================================;
; It's highly likely that this won't work properly.
;==============================================================================;
; fme7_Setup
; FME-7 mapper setup

fme7_Setup:
	; set up CHR banks
	; (POSSIBLE SPACE OPTIMIZATION POINT)
	ldx #0
.rept 8
	stx $8000
	stx $A000
	inx
.endr

	; PRG Bank 0 ($6000-$7FFF)
	ldx #$08
	lda #%01000000|0
	stx $8000
	sta $A000

	; PRG Bank 1 ($8000-$9FFF)
	ldx #$09
	lda #3
	stx $8000
	sta $A000

	; PRG Bank 2 ($A000-$BFFF)
	ldx #$0A
	lda #2
	stx $8000
	sta $A000

	; PRG Bank 2 ($C000-$DFFF)
	ldx #$0B
	lda #0
	stx $8000
	sta $A000

	; set default nametable mirroring
	ldx #$0C
	; 0=vertical mirroring, 1=horizontal; this is flipped from the header
	lda #HDR_MIRRORING
	eor #1
	stx $8000
	sta $A000

	; reset IRQ counter
	ldx #$0E
	ldy #$0F
	lda #$FF
	stx $8000
	sta $A000
	sty $8000
	sta $A000

	; disable mapper IRQs
	ldx #$0D
	lda #%00000000
	stx $8000
	sta $A000

	rts

;==============================================================================;
