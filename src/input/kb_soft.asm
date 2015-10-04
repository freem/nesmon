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
softkb_Show:
	; run after holding A+B for 3 seconds, or when no hardware keyboard found

	; softkbPos has base nametable address

	rts

;==============================================================================;
softkb_Hide:
	; typically run on selecting "Close" (or by typing on hardware keyboard?)

	; softkbPos has base nametable address
	; clear out the rows

	rts

;==============================================================================;
softkb_Redraw:
	; called on toggling Shift

	; softkbPos has base nametable address

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
