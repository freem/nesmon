;==============================================================================;
; nesmon/src/routines_ppu.asm
; Routines that use the PPU hardware
;==============================================================================;

;==============================================================================;
; ppu_clearNT (Different from corelib version)
; Clears the specified nametable and attributes.

; xxx: this could probably be even simpler, if blargg's code is any indication.

; Differences from freemco NES corelib:
; * Parameter moved from A to X.
; * Parameter now sets the upper PPU address byte, saving 4 bytes of ROM and
;   some awkward code.
; * Attribute section no longer split from tiles.

; (Params)
; X            Upper byte of nametable address ($20,$24,$28,$2C)

; (Clobbers)
; A,X,Y

ppu_clearNT:
	stx PPU_ADDR
	lda #0
	sta PPU_ADDR

	ldy #$FF
	ldx #4
@writeData:
	sta PPU_DATA
	dey
	bne @writeData
	dex
	bne @writeData

	rts

;==============================================================================;
; ppu_clearCHR (Different from corelib version)
; Clears a 4K CHR-RAM page.

; Differences from freemco NES corelib:
; * Parameter moved from A to X.
; * Loop counters in X and Y are now set from A instead of immediates for a
;   savings of 2 bytes.

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

;==============================================================================;
; ppu_WaitVBL
; Wait for VBlank via a flag

ppu_WaitVBL:
	bit PPU_STATUS
	lda #1
	sta vblanked
@waitNMI:
	lda vblanked
	bne @waitNMI
	rts

;==============================================================================;
; ppu_HideSprites
; Hides all sprites by moving them off-screen.

; (Clobbers)
; A            Used for data writing
; X            Used for index into OAM_BUF

ppu_HideSprites:
	ldx #0
	lda #$FF
@hideSpr:
	sta OAM_BUF,x
	inx
	bne @hideSpr
	rts

;==============================================================================;
; ppu_WriteString
; Writes a string of data to the PPU. (Rendering must be off)

; (Params)
; tmp00,tmp01  Pointer to data to write
; A            Length of data to write

; (Clobbers)
; A            Used for loading/writing data
; X            Nametable address, length counter
; Y            Nametable address

ppu_WriteString:
	; set PPU address
	ldx tmp00
	ldy tmp01
	stx PPU_ADDR
	sty PPU_ADDR

	tax
	ldy #0
	; write string
@writeLoop:
	lda (tmp00),y
	sta PPU_DATA
	iny
	dex
	bne @writeLoop

	rts

;==============================================================================;


;==============================================================================;
; The VRAM Buffer
;==============================================================================;
; It seems like every project I make has different requirements. Since RAM
; space on this project is at a premium, the VRAM Buffer design is going to be
; slightly different than the successful Fire Simulator version.

; addr1 addr2 sz/fl data
; Mostly the same, but with one major difference: Size is now Size/Flags.

; Size/Flags:
; 00000000
; ||_____|
; |   |
; |   |_____ Data length (0-127)
; |_________ Repeat flag

; If the Repeat flag is set, only one byte follows the data; it is repeated
; until the length has been reached.

; vramBufWritePos is the current index into vramBuf (where new data will go).
;==============================================================================;
; routine for full initialization of vram buffer
vramBuf_Init:
	jsr vramBuf_Reset
	jmp vramBuf_Clear

;==============================================================================;
; vramBuf_Reset
; Reset VRAM Buffer related variables.

; (Clobbers)
; A            Used for resetting vars

vramBuf_Reset:
	lda #0
	sta vramBufWritePos
	rts

;==============================================================================;
; vramBuf_Clear
; Clear VRAM Buffer data.

; (Clobbers)
; A            Used for resetting vars
; X            Used for indexing into vramBufData

vramBuf_Clear:
	; clear buffer data
	lda #0
	ldx #64
@clearLoop:
	sta vramBufData,x
	dex
	bne @clearLoop

	rts

;==============================================================================;
; vramBuf_NewEntry
; Initializing a new VRAM Buffer section (PPU address, data length)

; Note: Does not check if adding a new item will exceed VRAM Buffer size.

; (Params)
; tmp00        PPU address high
; tmp01        PPU address low
; tmp02        Data length/flags

; (Clobbers)
; A            Various loads
; Y            Used for indexing into vramBufData

vramBuf_NewEntry:
	; get current buffer location
	ldy vramBufWritePos

	; write ppu addr hi
	lda tmp00
	sta vramBufData,y
	iny
	; write ppu addr lo
	lda tmp01
	sta vramBufData,y
	iny
	; write data length/flags
	lda tmp02
	sta vramBufData,y

	; update current buffer location
	iny
	sty vramBufWritePos

	rts

;==============================================================================;
; vramBuf_AddFromPtr
; Adds data from a pointer to the VRAM Buffer.

; Note: Does not check if length of data will exceed VRAM Buffer size.

; (Params)
; tmp00,tmp01  Pointer to data to write
; A            Length of data to write

; (Clobbers)
; X            Used for indexing into vramBufData
; Y            Used for indexing into pointer

vramBuf_AddFromPtr:
	sta tmp02
	ldx vramBufWritePos
	ldy #0
@writeLoop:
	lda (tmp00),y
	sta vramBufData,x
	inx
	iny
	cpy tmp02
	bne @writeLoop
	stx vramBufWritePos
	rts

;==============================================================================;
; vramBuf_AddByte
; Adds a single byte to the VRAM Buffer.

; Note: Does not check if length of data will exceed VRAM Buffer size.

; (Params)
; A            Byte to write

; (Clobbers)
; Y            Used for indexing into vramBufData

vramBuf_AddByte:
	; get current buffer location
	ldy vramBufWritePos
	; store byte
	sta vramBufData,y
	; update current buffer location
	iny
	sty vramBufWritePos
	rts

;==============================================================================;
; vramBuf_AddFill (Different from Fire Simulator)
; Adds a single byte to the VRAM Buffer a specified number of times.

; Differences from Fire Simulator:
; * Converted to use RLE (Flags $80)

; Note: Does not check if length of data will exceed VRAM Buffer size.

; (Params)
; A           Byte to write
; X           Number of times to write

; (Clobbers)
; Y            Used for indexing into vramBufData

vramBuf_AddFill:
	ldy vramBufWritePos
	sta tmp01

	; set RLE flag
	txa
	ora #$80
	sta vramBufData,y

	; set tile
	iny
	sta vramBufData,y

	; update write position
	iny
	sty vramBufWritePos
	rts

;==============================================================================;
; vramBuf_Transfer
; Transfer data from the VRAM Buffer to the PPU.

; It is very important that this routine be as simple as possible, in order to
; maximize the amount of data we can send.

; Notes:
; * Buffer boundaries are only checked at the beginning of nextSection.

; todo: the new termination logic is bleh.
; for example:
; if the buffer location overflows.
; if the buffer isn't cleared.
; and so on.

vramBuf_Transfer:
	; check to see if we should run this
	lda runNormalVBuf
	bne @continue
	rts

@continue:
	; start at the beginning of the buffer
	ldy #0

@nextSection:
	; check if we have reached the physical end of the buffer
	cpy #64
	beq @end

	; get ppu addr high
	lda vramBufData,y
	sta tmp00
	iny

	; get ppu addr low
	lda vramBufData,y
	sta tmp01
	iny

	; get data length
	lda vramBufData,y
	sta tmp02
	iny

	; check if data length is 0
	; if so, we are done handling writes for this frame.
	lda tmp02
	beq @end

	; set new PPU address
	lda tmp00
	ldx tmp01
	sta PPU_ADDR
	stx PPU_ADDR

	; check if this is rle
	lda tmp02
	bmi @doRLE

	ldx #0
@writeLoop:
	; get byte
	lda vramBufData,y
	; write data to ppu
	sta PPU_DATA
	iny
	; check loop logic for section
	inx
	cpx tmp02
	bne @writeLoop
	; jump back to top
	beq @nextSection
	bne @end

@doRLE:
	; get real length
	and #$7F
	tax
@writeRLE:
	; get and write byte
	lda vramBufData,y
	sta PPU_DATA
	; loop logic
	dex
	bne @writeRLE

	; jump back to top
	iny
	bne @nextSection

@end:
	; finished running this update
	lda #0
	sta runNormalVBuf
	rts
