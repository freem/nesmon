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
; Keyboard Access Pseudo Code (from nocash everynes)
;
;	[4016h]=05h:WAIT(16clks)                   ;reset (force row 0)
;	FOR i=0 TO 8                               ;loop 9 rows
;		[4016h]=04h:WAIT(56clks)                 ;request LSB of NEXT row
;		Row[i]=(([4017h] SHR 1) AND 0Fh)         ;read LSB
;		[4016h]=06h:WAIT(56clks)                 ;request MSB of SAME row
;		Row[i]=(([4017h] SHL 3) AND F0h)+Row[i]  ;read MSB
;	NEXT                                       ;loop next

;==============================================================================;
KBSignature_HVC007:
	.db "KB_HVC007"
	.db $00 ; driver version number

;==============================================================================;
; Keyboard Driver Jump Table
kbDriver_HVC007:
	.dw $0000

;==============================================================================;
