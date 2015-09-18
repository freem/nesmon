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

;==============================================================================;
; editor_Init
; Setup for the editor module

editor_Init:
	; do real initialization

	; init display
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

	; execution falls through
;==============================================================================;
; editor_MainLoop
; Editor module main loop

editor_MainLoop:
	; --before vblank--
	; react to input

	; --vblank--
	jsr ppu_WaitVBL

	; --after vblank--
	; get input for next frame

	jmp editor_MainLoop

;==============================================================================;
; editor_PrintLine
; Prints a line of text to the screen.

