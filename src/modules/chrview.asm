;==============================================================================;
; nesmon/src/modules/chrview.asm
; CHR Data Viewer/Editor
;==============================================================================;
; The CHR Data Viewer/Editor (also known as "chrview") allows you to view and
; edit the CHR data. Please note: editing will require CHR-RAM.
;==============================================================================;
; Routine naming: chrview_*
;==============================================================================;
; [Module RAM definitions]
; you'd think these would be GOOD to have in the NL, but conflicting addresses
; make this a bummer.

	; remember, 64 bytes maximum.
.ignorenl
	CHRVIEW_CURSORPOS     = moduleRAM		; current cursor position
	CHRVIEW_SECTION       = moduleRAM+$01	; current active section/command (0=main menu,1=select tile,2=select color,3=edit tile,4=COLORS,5=SWAPCOL,6=options,7=CHRBANK)
	CHRVIEW_TILE_ADDR_H   = moduleRAM+$02	; ppu address of current tile (low byte)
	CHRVIEW_TILE_ADDR_L   = moduleRAM+$03	; ppu address of current tile (high byte)
	; add new stuff here (up to $0F)
	;--everything below this line is fixed--;
	CHRVIEW_TILEBUF_EDIT  = moduleRAM+$10	; (16 bytes)
	;---------------------------------------;
	CHRVIEW_TILEBUF_UNDO  = moduleRAM+$20	; (16 bytes)
	;---------------------------------------;
	CHRVIEW_CLIPBOARD_BUF = moduleRAM+$30	; (16 bytes)
	;--no more free space after this line!--;
.endinl

;==============================================================================;
; [Tables]

; nametable addresses for cursors
tbl_chrview_MenuCursorAddr:
	.db $23,$01		;  0: Colors
	.db $23,$21		;  1: CHRBANK
	.db $23,$41		;  2: SWAPCOL
	.db $23,$0A		;  3: HFlip
	.db $23,$2A		;  4: VFlip
	.db $23,$4A		;  5: Clear
	.db $23,$11		;  6: Cut
	.db $23,$31		;  7: Copy
	.db $23,$51		;  8: Paste
	.db $23,$18		;  9: Undo
	.db $23,$38		; 10: Option
	.db $23,$58		; 11: Exit

;==============================================================================;
; [Strings]

str_chrview_HeaderText:		.db "CHR DATA VIEWER/EDITOR"

vbstr_chrview_PixColor:
	.db $22,$14,6,"PIXEL COLOR"

; --Menu Choices--
vbstr_chrview_Colors:
	.db $23,$02,6,"COLORS"

vbstr_chrview_CHRBank:
	.db $23,$22,7,"CHRBANK"

vbstr_chrview_SwapCol:
	.db $23,$42,7,"SWAPCOL"

vbstr_chrview_HFlip:
	.db $23,$0B,5,"HFLIP"

vbstr_chrview_VFlip:
	.db $23,$2B,5,"VFLIP"

vbstr_chrview_Clear:
	.db $23,$4B,5,"CLEAR"

vbstr_chrview_Cut:
	.db $23,$12,3,"CUT"

vbstr_chrview_Copy:
	.db $23,$32,4,"COPY"

vbstr_chrview_Paste:
	.db $23,$52,5,"PASTE"

vbstr_chrview_Undo:
	.db $23,$19,4,"UNDO"

vbstr_chrview_Option:
	.db $23,$39,6,"OPTION"

vbstr_chrview_Exit:
	.db $23,$59,4,"EXIT"

;==============================================================================;
chrview_Init:
	; --system variable initialization--

	; clear module ram
	jsr nesmon_ClearModuleRAM

	; --module variable initialization--
	lda #0
	sta CHRVIEW_CURSORPOS

	; you need to turn off de light
	lda int_ppuMask
	and #%11100111
	sta PPU_MASK

	; clear primary nametable
	ldx #$20
	jsr ppu_clearNT

	; set up screen display
	jsr chrView_InitDisplay

	; ok turn it back on again
	lda int_ppuMask
	sta PPU_MASK

;------------------------------------------------------------------------------;
chrview_MainLoop:
	; --before vblank--
	jsr chrview_HandleInput

	; --vblank--
	jsr ppu_WaitVBL

	; --after vblank--
	; get input

@mainLoop_end:
	jmp chrview_MainLoop

;------------------------------------------------------------------------------;
; doubles as the Exit command
chrview_Finish:
	; do screen ending
	rts					; chrview is called via jsr

;==============================================================================;
chrview_HandleInput:
	; handle joypad input
	rts

;==============================================================================;
chrView_InitDisplay:
	; --header--

	; line at $2020
	ldx #$20
	lda #$08
	stx PPU_ADDR
	stx PPU_ADDR
@line1Loop:
	sta PPU_DATA
	dex
	bne @line1Loop

	; str_chrview_HeaderText

	; line at $2060
	ldx #$20
	ldy #$60
	lda #$08
	stx PPU_ADDR
	sty PPU_ADDR
@line2Loop:
	sta PPU_DATA
	dex
	bne @line2Loop

	; top frames

	; main view (tiles begin at $20C2; frame begins at $20C1, ends at $20D2)

	; zoomed view (tiles begin at $20D4; frame begins at $20D3, ends at $20DC)

	; $21D3: bottom frame of zoomed area

	; "pen color" label ($2214)

	; numbers ($2255)

	; swatches ($2294)

	; bottom frame ($22C0)
	ldx #$22
	ldy #$C0
	lda #$08
	stx PPU_ADDR
	sty PPU_ADDR
	sta PPU_DATA
	ldx #$09
	stx PPU_DATA
	; 16 more of A
	; one more X
	; final 13 A

	; main menu

	; bottommost line at $2380
	ldx #$23
	lda #$80
	stx PPU_ADDR
	stx PPU_ADDR
@lineXLoop:
	sta PPU_DATA
	dex
	bne @lineXLoop

	rts

;==============================================================================;
chrview_ClearMenu:
	; add giant clear strings (30 bytes) to vram buffer

	rts

;==============================================================================;
chrview_DrawMainMenu:
	; add strings to vram buffer

	rts

;==============================================================================;
; chrview_ChangeTile
; Called upon changing the active tile to view/edit

chrview_ChangeTile:
	;

	rts

;==============================================================================;
; chrview_UpdateTileData
; Write back the changes to the tile

chrview_UpdateTileData:
	; save current tile state before changing

	; change tile data

	rts

;==============================================================================;
; Main Menu Commands
;==============================================================================;
; Colors
;==============================================================================;
; CHRBANK
;==============================================================================;
; SWAPCOL
;==============================================================================;
; HFlip
;==============================================================================;
; VFlip
;==============================================================================;
; Clear
; Clears the tile data

;==============================================================================;
; Cut
; Like Copy, but Clears the tile.

;==============================================================================;
; Copy
; Puts the currently selected tile data onto the clipboard.

;==============================================================================;
; Paste
; Pastes data from the clipboard into the currently selected tile.

;==============================================================================;
; chrview_Undo
; Undoes the last action (by writing the previous tile's data)

chrview_Undo:
	rts

;==============================================================================;
; Option

;==============================================================================;
