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
softkb_Input:
	lda pad1State
	and #$FF
	bne @softKB_CheckStart
	rts

@softKB_CheckStart:
	; --check for Start--
	lda pad1State
	and #PAD_START
	beq @softKB_CheckB

	; Start button: send text (equivalent of pressing Enter)
	jmp @end

@softKB_CheckB:
	; --check for B--
	lda pad1State
	and #PAD_B
	beq @softKB_CheckA

	; B button: backspace
	jmp @end

@softKB_CheckA:
	; --check for A--
	lda pad1State
	and #PAD_A
	beq @softKB_CheckSelect

	; A button: press selected key
	jmp @end

@softKB_CheckSelect:
	; --check for Select--
	lda pad1State
	and #PAD_SELECT
	beq @softKB_CheckDir

	; not sure what the Select button does yet. Shift toggle? Ctrl/Alt/Fn?

@softKB_CheckDir:
	; --check for U/D/L/R--
	lda pad1State
	and #PAD_UP|PAD_DOWN|PAD_LEFT|PAD_RIGHT
	beq @end

@softKB_CheckDirUp:
	; up
	lda pad1State
	and #PAD_UP
	beq @softKB_CheckDirDown

	; softkey cursor up
	lda softkbY
	bne @cursorUp

	; wrap
	lda #4
	sta softkbY
	bne @end			; branch always

@cursorUp:
	dec softkbY
	jmp @end

@softKB_CheckDirDown:
	; down
	lda pad1State
	and #PAD_DOWN
	beq @softKB_CheckDirLeft

	; softkey cursor down
	lda softkbY
	cmp #4
	bne @cursorDown

	; wrap
	lda #0
	sta softkbY
	beq @end			; branch always

@cursorDown:
	inc softkbY
	bne @end			; branch always

@softKB_CheckDirLeft:
	;left
	lda pad1State
	and #PAD_LEFT
	beq @softKB_CheckDirRight

	; softkey cursor left
	lda softkbX
	bne @cursorLeft

	; wrap
	lda #12
	sta softkbX
	bne @end			; branch always

@cursorLeft:
	dec softkbX
	bne @end			; branch always

@softKB_CheckDirRight:
	;right
	lda pad1State
	and #PAD_RIGHT
	beq @end

	; softkey cursor right
	lda softkbX
	cmp #12
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
