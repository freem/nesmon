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
	; module variables (todo)

	; cursor defines
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
	; TEMPORARY HACK
	lda #1
	sta activeKBType
	; end TEMPORARY HACK

	; --system variable initialization--
	lda #0
	sta edcursorX
	sta curLineEnd
	sta curNumChars
	sta editScrollY
	sta editScrollNT

	; clear line buffer
	jsr editor_ClearLineBuf

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

	; build date
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
	jsr ppu_WaitVBL

	; --cursor (visual)--
	; reset cursor cell
	ldx #1
	stx edcurDispX
	inx
	stx edcurDispY

	; this is a system variable, but it makes more sense to define it here
	lda #1
	sta editLineNum

	; blinkenstein 3d
	lda #0
	sta edcurBlink
	sta timer1

	; --software keyboard--
	jsr vramBuf_Init

	; temporary shoving this off-screen (was $2220)
	lda #$26
	ldx #$20
	sta softkbPos
	stx softkbPos+1
	jsr softkb_Show

	lda #1
	sta runNormalVBuf
	jsr ppu_WaitVBL

	; execution falls through
;==============================================================================;
; editor_MainLoop
; Editor module main loop

editor_MainLoop:
	; --before vblank--
	jsr editor_HandleInput	; handle input
	jsr editor_UpdateCursorSprite

	lda activeKBType
	bne @skipSoftKBUpdate
	; update software keyboard cursor or whatever
	jsr softkb_Update

@skipSoftKBUpdate:
	; --vblank--
	jsr ppu_WaitVBL

	; --after vblank--
	inc timer1
	lda timer1
	cmp #20					; this value subject to change (currently 1/3 of 60)
	bne @noBlinking

	; reset timer
	lda #0
	sta timer1
	; change blink state
	lda edcurBlink
	eor #1
	sta edcurBlink

@noBlinking:
	jsr editor_GetInput		; get input for next frame

	jmp editor_MainLoop

;==============================================================================;
; editor_GetCursorPos
; Returns the PPU address of the cursor's current position

editor_GetCursorPos:
	; in the basic case, it goes like this:
	; addr = $2000
	; addr += edcurDispX+1 ; easy
	; addr += (edcurDispY * $20; <<5) ; need to account for upper NT addr

	; say you're on row 8; 8<<5 is 256.
	; You need to be able to store 4 bits of the overflow

	rts

;==============================================================================;
; editor_PrintLine
; Prints a line of text to the screen.

editor_PrintLine:
	; find current position

	rts

;==============================================================================;
; editor_UpdateCursorSprite
; Updates the cursor sprite.

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
	; subtract 1 for proper positioning
	sec
	sbc #1
	sta CURSOR_SPRITE_Y

	; sprite frame
	lda #CURSOR_TILE_ON
	clc
	adc edcurBlink
	sta CURSOR_SPRITE_TILE

	; sprite attributes
	; todo: hide sprite behind letter when on non-solid frame?
	lda #%00000000
	sta CURSOR_SPRITE_ATTR

	rts

;==============================================================================;
; editor_GetInput
; Gets input for this frame.

editor_GetInput:
	; --controller input--
	jsr io_ReadJoySafe

	; check which keyboard is active and get its input accordingly
	lda activeKBType
	bne @hwKeyboard

	; --software keyboard input--
	; soft keyboard input relies on the joypad input
	jmp softkb_Input

@hwKeyboard:
	; --hardware keyboard input--

	; get ReadKeys routine from the jump table
	lda hardkbJumpTable
	sta tmp00
	iny
	lda hardkbJumpTable+1
	sta tmp01

	; set up routine
	ldy #KBROUTINE_GETKEYS
	lda (tmp00),y
	sta tmp02
	iny
	lda (tmp00),y
	sta tmp03

	; do ReadKeys
	jmp (tmp02)

;==============================================================================;
; editor_HandleInput
; Handles the input

editor_HandleInput:
	; oh boy this is going to be fun!

	; --joypad--
	; we only need a few things here

	; --software keyboard--
@handleInput_SoftKB:
	;jsr softkb_Input

	; --hardware keyboard--
@handleInput_HWKB:
	; [SPECIAL KEYS]
	; Enter: typically sends the current line to the command parser

	rts

;==============================================================================;
; editor_ClearLineBuf
; Clears the contents of the line buffer.

editor_ClearLineBuf:
	lda #0
	ldx #30
@clearBuf:
	sta curLineBuf,x
	dex
	bpl @clearBuf
	rts
