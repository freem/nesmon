.ifndef KB_FAMIBASIC
	.error "Family BASIC keyboard support requires KB_FAMIBASIC to be defined"
.endif

.ifdef KB_SUBOR
	.error "Can't currently build with both Subor and Family BASIC keyboards"
.endif

;==============================================================================;
; nesmon/src/input/kb_famibasic.asm
; Family BASIC Keyboard (HVC-007) keyboard driver
;==============================================================================;
KBSignature_FamiBasic:	.db "HVC007",$00

; Keyboard Driver Jump Table
;==============================================================================;
