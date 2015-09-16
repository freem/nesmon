;==============================================================================;
; nesmon/src/routines_ppu.asm
; Routines that use the PPU hardware
;==============================================================================;

;==============================================================================;
; ppu_clearNT (Different from corelib version)
; Clears the specified nametable and attributes.

; xxx: this could probably be even simpler, if blargg's code is any indication.
; xxx: My code handles tiles and attributes separately for some reason.

; Differences from freemco NES corelib:
; * Parameter moved from A to X.
; * Parameter now sets the upper PPU address byte, saving 4 bytes of ROM and
;   some awkward code.

; (Params)
; X            Upper byte of nametable address ($20,$24,$28,$2C)

; (Clobbers)
; A,X,Y

ppu_clearNT:
	stx PPU_ADDR
	lda #0
	sta PPU_ADDR

	; clear tiles
	ldy #$C0
	ldx #4
@writeTiles:
	sta PPU_DATA
	dey
	bne @writeTiles
	dex
	bne @writeTiles

	; clear attrib
	ldy #64
@writeAttrib:
	sta PPU_DATA
	dey
	bne @writeAttrib

	rts

;==============================================================================;
; ppu_clearCHR (Different from corelib version)
; Clears a 4K CHR-RAM page.

; Differences from freemco NES corelib:
; * Parameter moved from A to X.
; * X and Y are now set from A instead of immediates for a savings of 2 bytes.

; xxx: could possibly be optimized further? (loop logic)

; (Params)
; X            Upper byte of PPU address ($00,$10)

; (Clobbers)
; A,X,Y

ppu_clearCHR:
	stx PPU_ADDR
	lda #0
	sta PPU_ADDR
	tax
	tay
@clearCHR:
	; tiles are 2bpp
	sta PPU_DATA
	sta PPU_DATA
	inx
	bne @clearCHR
	iny
	cpy #8
	bne @clearCHR

	rts

;==============================================================================;
; ppu_load1BPPCHR_c0
; Loads 1BPP CHR data into CHR-RAM using the first color.

; (Params)
; A -> tmp02   Number of tiles to load
; X            PPU address high byte
; Y            PPU address low byte
; tmp00,tmp01  Pointer to 1BPP CHR data to load

; (Clobbers)
; A,X,Y,tmp00,tmp01,tmp02,tmp03

ppu_load1BPPCHR_c0:
	; save numtiles
	sta tmp02
	; set ppu address
	stx PPU_ADDR
	sty PPU_ADDR

	; loop logic
	ldx #0
	ldy #0
@writeTiles1:
	; first half
	lda (tmp00),y
	sta PPU_DATA
	iny
	cpy #8				; 8 bytes = half of a tile
	bne @writeTiles1

	; second half
	lda #0
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA

	; advance pointer
	clc
	lda tmp00
	adc #$08
	sta tmp00
	bcc @noTop
	inc tmp01

@noTop:
	ldy #0
	inx
	cpx tmp02
	bne @writeTiles1

	rts
