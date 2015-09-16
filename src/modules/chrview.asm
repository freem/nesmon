;==============================================================================;
; nesmon/src/modules/chrview.asm
; CHR Data Viewer/Editor
;==============================================================================;
; The CHR Data Viewer/Editor (also known as "chrview") allows you to view and
; edit the CHR data. Please note: editing will require CHR-RAM.
;==============================================================================;
; Routine naming: chrview_*
;==============================================================================;

;==============================================================================;
; [Strings]

; todo: nametable addresses are obviously wrong
vbstr_chrview_PixColor:
	.db $20,$00,6
	.db "PIXEL COLOR"

vbstr_chrview_Colors:
	.db $20,$00,6
	.db "COLORS"

vbstr_chrview_CHRBank:
	.db $20,$00,7
	.db "CHRBANK"

vbstr_chrview_Col1Row3:
	.db $20,$00,7
	.db "???????"

vbstr_chrview_HFlip:
	.db $20,$00,5
	.db "HFLIP"

vbstr_chrview_VFlip:
	.db $20,$00,5
	.db "VFLIP"

vbstr_chrview_Clear:
	.db $20,$00,5
	.db "CLEAR"

vbstr_chrview_Cut:
	.db $20,$00,3
	.db "CUT"

vbstr_chrview_Copy:
	.db $20,$00,4
	.db "COPY"

vbstr_chrview_Paste:
	.db $20,$00,5
	.db "PASTE"

vbstr_chrview_Col4Row1:
	.db $20,$00,7
	.db "???????"

vbstr_chrview_Option:
	.db $20,$00,6
	.db "OPTION"

vbstr_chrview_Exit:
	.db $20,$00,4
	.db "EXIT"
;==============================================================================;
chrview_Init:
	; blah

	; clear nametables
	

	; set up screen display
	; clear module ram

;------------------------------------------------------------------------------;
chrview_MainLoop:
	jmp chrview_MainLoop

;==============================================================================;
chrview_Input:
	rts
;==============================================================================;
chrview_ClearMenu:
	rts
;==============================================================================;
chrview_DrawMainMenu:
	rts
;==============================================================================;
