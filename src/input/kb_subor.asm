.ifndef KB_SUBOR
	.error "Subor keyboard support requires KB_SUBOR to be defined"
.endif

.ifdef KB_FAMIBASIC
	.error "Can't currently build with both Family BASIC and Subor keyboards"
.endif

;==============================================================================;
; nesmon/src/input/kb_subor.asm
; Subor Keyboard
;==============================================================================;
KeyboardDriverSignature:	.db "SUBOR"
;==============================================================================;
