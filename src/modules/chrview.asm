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
.ignorenl
	CHRVIEW_CURSORPOS = moduleRAM		; (1 byte)
	CHRVIEW_TILEBUF_EDIT = moduleRAM+$10	; (16 bytes)
	CHRVIEW_TILEBUF_UNDO = moduleRAM+$20	; (16 bytes)
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
	; variable initialization
	lda #0
	sta CHRVIEW_CURSORPOS

	; you need to turn off de light

	; clear nametables
	

	; set up screen display
	jsr chrView_InitDisplay

	; clear module ram
	jsr nesmon_ClearModuleRAM

	; ok turn it back on again

;------------------------------------------------------------------------------;
chrview_MainLoop:
	; --before vblank--

	; --vblank--
	jsr ppu_WaitVBlank

	; --after vblank--
	jsr chrview_Input

	jmp chrview_MainLoop

;==============================================================================;
chrview_Input:
	;

	rts

;==============================================================================;
chrView_InitDisplay:
	; --header--
	; line at $2020
	; str_chrview_HeaderText
	; line at $2060

	; main view

	; zoomed view

	; "pixel color" area

	; main menu

	rts

;==============================================================================;
chrview_ClearMenu:
	rts

;==============================================================================;
chrview_DrawMainMenu:
	rts

;==============================================================================;
; chrview_ChangeTile
; Called upon changing the active tile to view/edit

chrview_ChangeTile:
	rts

;==============================================================================;
; chrview_UpdateTileData
; Write back the changes to the tile

chrview_UpdateTileData:
	; save current tile state before changing

	; change tile data

	rts

;==============================================================================;
; chrview_Undo
; Undoes the last action (by writing the previous tile's data)

chrview_Undo:
	rts
