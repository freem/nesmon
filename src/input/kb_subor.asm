.ifndef KB_SUBOR
	.error "Subor keyboard support requires KB_SUBOR to be defined"
.endif

.ifdef KB_FAMIBASIC
	.error "Can't currently build with both Family BASIC and Subor keyboards"
.endif

;==============================================================================;
; nesmon/src/input/kb_subor.asm
; Subor Keyboard driver
;==============================================================================;
KBSignature_Subor:
	.db "KB_SUBOR"
	.db $00 ; subor keyboard variant
	.db $00 ; driver version number

;==============================================================================;
; Keyboard Driver Jump Table
kbDriver_Subor:
	.dw kbSubor_Reset		; Reset
	.dw kbSubor_GetKeys		; GetKeys

;==============================================================================;
kbSubor_Reset:
	rts
;==============================================================================;
kbSubor_GetKeys:
	rts
;==============================================================================;
