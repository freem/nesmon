;==============================================================================;
; nesmon/src/input/kb_soft.asm
; Software Keyboard (Joypad)
;==============================================================================;
; In the worst case (and most common) scenario, there is no keyboard connected
; to the console at all. This can be for various reasons, none of which are
; important. When no keyboard is available, the joypad must be used.

; Enter the software keyboard. Unlike the hardware keyboards, the software
; keyboard uses an on-screen display for input.

; (Unshifted Layout)
; 1 2 3 4 5 6 7 8 9 0 - = BKSP
;  Q W E R T Y U I O P [ ] \
;   A S D F G H J K L ; ' ENTR
; FN Z X C V B N M , . / SHIFT
; ESC  CTRL  SPACE  ALT  CLOSE

; (Shifted Layout)
; ! @ # $ % ^ & * ( ) _ + BKSP
;  Q W E R T Y U I O P [ ] \
;   A S D F G H J K L : " ENTR
; FN Z X C V B N M < > ? SHIFT
; ESC  CTRL  SPACE  ALT  CLOSE

; The viewable space with the keyboard open is 30x16 tiles
; (30x15 if you want padding from the keyboard's top separator)

; As this keyboard is supported by default, there is no need for a jump table.
;==============================================================================;
; Routine naming: softkb_*
;==============================================================================;
KBSignature_Soft:
	.db "KB_SOFTKB"
	.db $00 ; driver version number

;==============================================================================;
.ignorenl
	; software keyboard cursor defines
	SOFTKB_CURSOR_SPR1 = OAM_BUF+8
	SOFTKB_CURSOR_SPR2 = OAM_BUF+$C
	SOFTKB_CURSOR_SPR3 = OAM_BUF+$10
	SOFTKB_CURSOR_SPR4 = OAM_BUF+$14
.endinl

; keyboard strings
str_SoftKB_Row1:
	.db "1 2 3 4 5 6 7 8 9 0 - = BKSP"
str_SoftKB_Row2:
	.db " Q W E R T Y U I O P [ ] ",$5C
str_SoftKB_Row3:
	.db "  A S D F G H J K L ; ' ENTR"
str_SoftKB_Row4:
	.db "FN Z X C V B N M , . / SHIFT"
str_SoftKB_Row5:
	.db "ESC  CTRL  SPACE  ALT  CLOSE"

str_SoftKB_Row1Shift:
	.db "! @ # $ % ^ & * ( ) _ + BKSP"

; todo: cursor sprite (tiles $03,$04,$05,$06)

; todo: tables for base X/Y position based on softkbX, softkbY

tbl_softkbRowMaxItems:
	.db 12
	.db 12
	.db 11
	.db 11
	.db 4

tbl_softkbRowCursorX:
	.dw tbl_softkbRow1CursorX
	.dw tbl_softkbRow2CursorX
	.dw tbl_softkbRow3CursorX
	.dw tbl_softkbRow4CursorX
	.dw tbl_softkbRow5CursorX

tbl_softkbRow1CursorX:
	.db  16, 32, 48, 64, 80, 96,112,128,144,160,176,192,220
tbl_softkbRow2CursorX:
	.db  24, 40, 56, 72, 88,104,120,136,152,168,184,200,216
tbl_softkbRow3CursorX:
	.db  32, 48, 64, 80, 96,112,128,144,160,176,192,220
tbl_softkbRow4CursorX:
	.db  20, 40, 56, 72, 88,104,120,136,152,168,184,216
tbl_softkbRow5CursorX:
	.db  24, 68,120,168,216

tbl_softkbCursorY:
	.db 143
	.db 159
	.db 175
	.db 191
	.db 207

tbl_softkbRowCursorSize:
	.dw tbl_softkbRow1CursorSize
	.dw tbl_softkbRow2CursorSize
	.dw tbl_softkbRow3CursorSize
	.dw tbl_softkbRow4CursorSize
	.dw tbl_softkbRow5CursorSize

; 0=normal; nonzero: number of characters
tbl_softkbRow1CursorSize:
	.db 0,0,0,0,0,0,0,0,0,0,0,0,5
tbl_softkbRow2CursorSize:
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0
tbl_softkbRow3CursorSize:
	.db 0,0,0,0,0,0,0,0,0,0,0,5
tbl_softkbRow4CursorSize:
	.db 3,0,0,0,0,0,0,0,0,0,0,6
tbl_softkbRow5CursorSize:
	.db 4,5,6,4,6

;==============================================================================;
softkb_Show:
	; run after holding A+B for 3 seconds, or when no hardware keyboard found

	; softkbPos has base nametable address

	; top line
	lda softkbPos
	sta tmp00
	lda softkbPos+1
	sta tmp01
	lda #$80|32
	sta tmp02
	jsr vramBuf_NewEntry
	lda #$08
	jsr vramBuf_AddByte

	; row 1
	lda softkbPos
	sta tmp00
	lda softkbPos+1
	clc
	adc #$22
	sta tmp01

	lda #28
	sta tmp02
	jsr vramBuf_NewEntry

	lda #<str_SoftKB_Row1
	ldx #>str_SoftKB_Row1
	sta tmp00
	stx tmp01
	lda #28
	jsr vramBuf_AddFromPtr

	; row 2
	lda softkbPos
	sta tmp00
	lda softkbPos+1
	clc
	adc #$62
	sta tmp01

	lda #26
	sta tmp02
	jsr vramBuf_NewEntry

	lda #<str_SoftKB_Row2
	ldx #>str_SoftKB_Row2
	sta tmp00
	stx tmp01
	lda #26
	jsr vramBuf_AddFromPtr

	; need to flush buffer to screen before setting up next rows
	lda #1
	sta runNormalVBuf
	jsr ppu_WaitVBL
	jsr vramBuf_Init

	; row 3
	lda softkbPos
	sta tmp00
	lda softkbPos+1
	clc
	adc #$A2
	sta tmp01

	lda #28
	sta tmp02
	jsr vramBuf_NewEntry

	lda #<str_SoftKB_Row3
	ldx #>str_SoftKB_Row3
	sta tmp00
	stx tmp01
	lda #28
	jsr vramBuf_AddFromPtr

	; row 4
	clc
	lda softkbPos
	adc #1
	sta tmp00
	lda softkbPos+1
	adc #$E2
	sta tmp01

	lda #28
	sta tmp02
	jsr vramBuf_NewEntry

	lda #<str_SoftKB_Row4
	ldx #>str_SoftKB_Row4
	sta tmp00
	stx tmp01
	lda #28
	jsr vramBuf_AddFromPtr

	; need to flush buffer to screen again before setting up final rows
	lda #1
	sta runNormalVBuf
	jsr ppu_WaitVBL
	jsr vramBuf_Init

	; row 5
	clc
	lda softkbPos
	adc #1
	sta tmp00
	lda softkbPos+1
	adc #$22
	sta tmp01

	lda #28
	sta tmp02
	jsr vramBuf_NewEntry

	lda #<str_SoftKB_Row5
	ldx #>str_SoftKB_Row5
	sta tmp00
	stx tmp01
	lda #28
	jsr vramBuf_AddFromPtr

	; bottom line
	clc
	lda softkbPos
	adc #1
	sta tmp00
	lda softkbPos+1
	adc #$40
	sta tmp01
	lda #$80|32
	sta tmp02
	jsr vramBuf_NewEntry
	lda #$08
	jsr vramBuf_AddByte

	rts

;==============================================================================;
softkb_Hide:
	; typically run on selecting "Close" (or by typing on hardware keyboard?)

	; hide cursor (spr.2-5)

	; hide keyboard
	jsr vramBuf_Init

	; softkbPos has base nametable address

	; first row
	lda softkbPos
	sta tmp00
	lda softkbPos+1
	sta tmp01
	lda #$80|32
	sta tmp02
	jsr vramBuf_NewEntry
	lda #$00
	jsr vramBuf_AddByte

	; second row
	lda softkbPos
	sta tmp00
	lda softkbPos+1
	clc
	adc #$20
	sta tmp01
	lda #$80|32
	sta tmp02
	jsr vramBuf_NewEntry
	lda #$00
	jsr vramBuf_AddByte

	; third row
	lda softkbPos
	sta tmp00
	lda softkbPos+1
	clc
	adc #$60
	sta tmp01
	lda #$80|32
	sta tmp02
	jsr vramBuf_NewEntry
	lda #$00
	jsr vramBuf_AddByte

	; this is the maximum amount we can transfer before running into problems
	lda #1
	sta runNormalVBuf
	jsr ppu_WaitVBL

	; fourth row
	lda softkbPos
	sta tmp00
	lda softkbPos+1
	clc
	adc #$A0
	sta tmp01
	lda #$80|32
	sta tmp02
	jsr vramBuf_NewEntry
	lda #$00
	jsr vramBuf_AddByte

	; fifth row
	clc
	lda softkbPos
	adc #1
	sta tmp00
	lda #0
	sta tmp01
	lda #$80|32
	sta tmp02
	jsr vramBuf_NewEntry
	lda #$00
	jsr vramBuf_AddByte

	; sixth row
	clc
	lda softkbPos
	adc #1
	sta tmp00
	lda softkbPos+1
	adc #$20
	sta tmp01
	lda #$80|32
	sta tmp02
	jsr vramBuf_NewEntry
	lda #$00
	jsr vramBuf_AddByte

	; running into the limit again
	lda #1
	sta runNormalVBuf
	jsr ppu_WaitVBL

	; last row
	clc
	lda softkbPos
	adc #1
	sta tmp00
	lda softkbPos+1
	adc #$40
	sta tmp01
	lda #$80|32
	sta tmp02
	jsr vramBuf_NewEntry
	lda #$00
	jsr vramBuf_AddByte

	lda #1
	sta runNormalVBuf
	jsr ppu_WaitVBL

	rts

;==============================================================================;
softkb_Redraw:
	; called on toggling Shift

	; softkbPos has base nametable address

	; row 1 needs to change
	

	; five other keys need to get changed (; ' , . / become : " < > ?)

	rts

;==============================================================================;
softkb_Update:
	; temporary variable usage
	; tmp00: base Y position
	; tmp01: base X position

	; update cursor sprite display (sprites 2-5)
	; tiles $03-$06

	; example positions for softkbX=0, softkbY=0
	; base: x=16,y=143

	; todo: use softkbX, softkbY

	; get base addresses for this key
	ldy softkbY
	lda tbl_softkbCursorY,y
	sta tmp00

	lda softkbY
	asl
	tay
	lda tbl_softkbRowCursorX,y
	sta tmp01
	lda tbl_softkbRowCursorX+1,y
	sta tmp02
	ldy softkbX
	lda (tmp01),y
	sta tmp01

	; -- cursor sprite 1/4 --
	; Y position
	lda tmp00
	sec
	sbc #6
	sta SOFTKB_CURSOR_SPR1

	; X position
	lda tmp01
	sec
	sbc #6
	sta SOFTKB_CURSOR_SPR1+3

	; tile and attributes
	lda #$03
	sta SOFTKB_CURSOR_SPR1+1
	lda #$01
	sta SOFTKB_CURSOR_SPR1+2

	; -- cursor sprite 2/4 --
	; Y position
	lda tmp00
	sec
	sbc #6
	sta SOFTKB_CURSOR_SPR2

	; X position
	lda tmp01
	clc
	adc #6
	sta SOFTKB_CURSOR_SPR2+3

	; tile and attributes
	lda #$04
	sta SOFTKB_CURSOR_SPR2+1
	lda #$01
	sta SOFTKB_CURSOR_SPR2+2

	; -- cursor sprite 3/4 --
	; Y position
	lda tmp00
	clc
	adc #6
	sta SOFTKB_CURSOR_SPR3

	; X position
	lda tmp01
	sec
	sbc #6
	sta SOFTKB_CURSOR_SPR3+3

	; tile and attributes
	lda #$05
	sta SOFTKB_CURSOR_SPR3+1
	lda #$01
	sta SOFTKB_CURSOR_SPR3+2

	; -- cursor sprite 4/4 --
	; Y position
	lda tmp00
	clc
	adc #6
	sta SOFTKB_CURSOR_SPR4

	; X position
	lda tmp01
	adc #6
	sta SOFTKB_CURSOR_SPR4+3

	; tile and attributes
	lda #$06
	sta SOFTKB_CURSOR_SPR4+1
	lda #$01
	sta SOFTKB_CURSOR_SPR4+2

	; current key may require a different set of sizes...
	lda softkbY
	asl
	tay
	lda tbl_softkbRowCursorSize,y
	sta tmp01
	lda tbl_softkbRowCursorSize+1,y
	sta tmp02
	ldy softkbX
	lda (tmp01),y
	beq @end

	; this key has a nonstandard size.
	; we'll need to modify the X position of each sprite.
	sta tmp00

	lsr
	tay
@fixSpr1X:
	; left side
	lda SOFTKB_CURSOR_SPR1+3
	sec
	sbc tmp00
	sta SOFTKB_CURSOR_SPR1+3
	sta SOFTKB_CURSOR_SPR3+3

	; right side
	lda SOFTKB_CURSOR_SPR2+3
	clc
	adc tmp00
	sta SOFTKB_CURSOR_SPR2+3
	sta SOFTKB_CURSOR_SPR4+3

	dey
	bne @fixSpr1X

@end:
	rts

;==============================================================================;
softkb_Input:
	lda pad1Trigger
	and #$FF
	beq @end

@softKB_CheckStart:
	; --check for Start--
	lda pad1Trigger
	and #PAD_START
	beq @softKB_CheckB

	; Start button: send text (equivalent of pressing Enter)
	jmp @end

@softKB_CheckB:
	; --check for B--
	lda pad1Trigger
	and #PAD_B
	beq @softKB_CheckA

	; B button: backspace
	jmp @end

@softKB_CheckA:
	; --check for A--
	lda pad1Trigger
	and #PAD_A
	beq @softKB_CheckSelect

	; A button: press selected key
	jmp @end

@softKB_CheckSelect:
	; --check for Select--
	lda pad1Trigger
	and #PAD_SELECT
	beq @softKB_CheckDir

	; not sure what the Select button does yet. Shift toggle? Ctrl/Alt/Fn?

@softKB_CheckDir:
	; --check for U/D/L/R--
	lda pad1Trigger
	and #PAD_UP|PAD_DOWN|PAD_LEFT|PAD_RIGHT
	beq @end
	jmp softkb_HandleCursor

@end:
	rts

;==============================================================================;
softkb_HandleCursor:
	; todo: this needs to be handled better, especially with relation to
	; the last three rows (and the last row especially)

	; up
	lda pad1Trigger
	and #PAD_UP
	beq @softKB_CheckDirDown

	; softkey cursor up
	; this code is mostly good. could stand to have some overrides on the last row
	lda softkbY
	bne @cursorUp

	; wrap
	lda #4
	sta softkbY
	bne @cursorUpCheck			; branch always

@cursorUp:
	dec softkbY

@cursorUpCheck:
	; set new X if needed
	ldy softkbY
	lda tbl_softkbRowMaxItems,y
	cmp softkbX
	bcs @cursorUpOK
	sta softkbX

@cursorUpOK:
	jmp @end

;------------------------------------------------;
@softKB_CheckDirDown:
	; down
	lda pad1Trigger
	and #PAD_DOWN
	beq @softKB_CheckDirLeft

	; softkey cursor down
	; this code is mostly good, but needs to use data from tbl_softkbRowMaxItems
	lda softkbY
	cmp #4
	bne @cursorDown

	; wrap
	lda #0
	sta softkbY
	beq @cursorDownCheck			; branch always

@cursorDown:
	inc softkbY

@cursorDownCheck:
	; set new X if needed
	ldy softkbY
	lda tbl_softkbRowMaxItems,y
	cmp softkbX
	bcs @cursorDownOK
	sta softkbX

@cursorDownOK:
	bne @end			; branch always

;------------------------------------------------;
@softKB_CheckDirLeft:
	;left
	lda pad1Trigger
	and #PAD_LEFT
	beq @softKB_CheckDirRight

	; softkey cursor left
	lda softkbY
	cmp #4
	beq @cursorLeftRow5
	cmp #2
	bcs @cursorLeftRows34

	; rows 1 and 2
	lda softkbX
	bne @cursorLeft
	; wrap
	lda #12
	sta softkbX
	bne @end			; branch always

@cursorLeftRows34:
	; rows 3 and 4
	lda softkbX
	bne @cursorLeft
	; wrap
	lda #11
	sta softkbX
	bne @end			; branch always

@cursorLeftRow5:
	; row 5
	lda softkbX
	bne @cursorLeft
	; wrap
	lda #4
	sta softkbX
	bne @end			; branch always

@cursorLeft:
	dec softkbX
	bne @end			; branch always

;------------------------------------------------;
@softKB_CheckDirRight:
	;right
	lda pad1Trigger
	and #PAD_RIGHT
	beq @end

	; softkey cursor right
	lda softkbY
	cmp #4
	beq @cursorRightRow5
	cmp #2
	bcs @cursorRightRows34

	; rows 1 and 2
	lda softkbX
	cmp #12
	bne @cursorRight
	; wrap
	lda #0
	sta softkbX
	beq @end			; branch always

@cursorRightRows34:
	; rows 3 and 4
	lda softkbX
	cmp #11
	bne @cursorRight
	; wrap
	lda #0
	sta softkbX
	beq @end			; branch always

@cursorRightRow5:
	; row 5
	lda softkbX
	cmp #4
	bne @cursorRight
	; wrap
	lda #0
	sta softkbX
	beq @end			; branch always

@cursorRight:
	inc softkbX

@end:
	rts

;==============================================================================;
softkb_HandleKey:
	
	rts
