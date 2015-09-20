;==============================================================================;
; nesmon/src/modules/editor.asm
; Editor module
;==============================================================================;
; The nesmon editor is a simple line editor. This editor provides the core
; functionality of the nesmon toolset, as commands are entered here.

; With space at a premium, we try to avoid storing a complete buffer of the
; visible text.
;==============================================================================;
; Routine naming: editor_*
;==============================================================================;
.ignorenl
	CURSOR_SPRITE_Y = OAM_BUF+4
	CURSOR_SPRITE_TILE = OAM_BUF+5
	CURSOR_SPRITE_ATTR = OAM_BUF+6
	CURSOR_SPRITE_X = OAM_BUF+7

	CURSOR_TILE_ON  = 1
	CURSOR_TILE_OFF = 2
.endinl

;==============================================================================;
; editor_Init
; Setup for the editor module

editor_Init:
	; --system variable initialization--

	; set user NMI
	;ldx #<editor_VBlank
	;ldy #>editor_VBlank
	;stx userNMILoc
	;sty userNMILoc+1

	; clear module ram
	jsr nesmon_ClearModuleRAM

	; --module variable initialization--

	; --welcome message--
	; prepare header
	ldx #$20
	ldy #$21
	lda #15
	stx tmp00
	sty tmp01
	sta tmp02
	jsr vramBuf_NewEntry

	ldx #<cartSignature
	ldy #>cartSignature
	stx tmp00
	sty tmp01
	lda #15
	jsr vramBuf_AddFromPtr

	ldx #$20
	ldy #$31
	lda #14
	stx tmp00
	sty tmp01
	sta tmp02
	jsr vramBuf_NewEntry

	ldx #<(cartSignature+16)
	ldy #>(cartSignature+16)
	stx tmp00
	sty tmp01
	lda #14
	jsr vramBuf_AddFromPtr

	lda #1
	sta runNormalVBuf

	; --cursor--
	; reset cursor cell
	ldx #1
	stx edcurDispX
	inx
	stx edcurDispY

	; execution falls through
;==============================================================================;
; editor_MainLoop
; Editor module main loop

editor_MainLoop:
	; --before vblank--
	jsr editor_HandleInput	; handle input
	jsr editor_UpdateCursorSprite

	; --vblank--
	jsr ppu_WaitVBL

	; --after vblank--
	jsr editor_GetInput		; get input for next frame
	

	jmp editor_MainLoop

;==============================================================================;
editor_VBlank:
	rts

;==============================================================================;
; editor_PrintLine
; Prints a line of text to the screen.
editor_PrintLine:
	rts

;==============================================================================;
; editor_UpdateCursorSprite
; Updates the cursor sprite
editor_UpdateCursorSprite:
	; sprite X position
	lda edcurDispX
	; multiply by 8
	asl
	asl
	asl
	sta CURSOR_SPRITE_X

	; sprite Y position
	lda edcurDispY
	; multiply by 8
	asl
	asl
	asl
	; subtract 1
	sec
	sbc #1
	sta CURSOR_SPRITE_Y

	; sprite frame
	; xxx: should blink every second (60/50 frames depending on NTSC/PAL)
	lda #CURSOR_TILE_ON
	sta CURSOR_SPRITE_TILE

	; sprite attributes
	lda #%00000000
	sta CURSOR_SPRITE_ATTR

	rts

;==============================================================================;
; editor_GetInput
; Gets input for this frame.

editor_GetInput:
	; --controller input--

	; check which keyboard is active and get its input accordingly
	lda activeKBType
	bne @hwKeyboard

	; --software keyboard input--
	jmp @end

@hwKeyboard:
	; --hardware keyboard input--

	; get ReadKeys routine (xxx: broken)
	lda hardkbJumpTable
	sta tmp00
	iny
	lda hardkbJumpTable+1
	sta tmp01

	ldy #2				; xxx: hardcoded index into Keyboard Driver Jump Table
	lda (tmp00),y
	sta tmp02
	iny
	lda (tmp00),y
	sta tmp03
	; do ReadKeys
	jmp (tmp02)

@end:
	rts

;==============================================================================;
; editor_HandleInput
; Handles the input

editor_HandleInput:
	rts
