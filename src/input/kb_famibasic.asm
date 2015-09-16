.ifndef KB_FAMIBASIC
	.error "Family BASIC keyboard support requires KB_FAMIBASIC to be defined"
.endif

.ifdef KB_SUBOR
	.error "Can't currently build with both Subor and Family BASIC keyboards"
.endif

;==============================================================================;
; nesmon/src/input/kb_famibasic.asm
; Family BASIC Keyboard
;==============================================================================;
KeyboardDriverSignature:	.db "HVCKB"
;==============================================================================;
