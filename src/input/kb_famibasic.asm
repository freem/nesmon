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
	.dw kbHVC007_Reset		; Reset
	.dw kbHVC007_GetKeys	; GetKeys
	.dw kbHVC007_KeyDown	; KeyDown
	.dw kbHVC007_KeyUp		; KeyUp

;==============================================================================;
; kbHVC007_Reset
; Resets the keyboard to the first row.

kbHVC007_Reset:
	lda #%00000101
	sta JOYSTICK1
	rts

;==============================================================================;
; kbHVC007_GetKeys
; Reads input from the keyboard and stores it in hardkbKeyStatus.

kbHVC007_GetKeys:
	; prepare keyboard
	lda #%00000101
	sta JOYSTICK1

	; wait 16 cycles
	ldy #3					; 2 cycles, 2 bytes
@waitLoop:
	dey						; 2 cycles, 1 byte
	bne @waitLoop			; 2+1 cycles, 2 bytes

	; prepare loop counter
	ldx #0
@doRow:
	; keyboard read (column 0)
	lda #%00000100
	sta JOYSTICK1

	; wait 56 cycles
	jsr kbHVC007_ReadWait

	; get column 0 data from JOYSTICK2
	lda JOYSTICK2
	lsr
	and #$0F
	sta hardkbKeyStatus,x

	; keyboard read (column 1)
	lda #%00000110
	sta JOYSTICK1

	; wait 56 cycles
	jsr kbHVC007_ReadWait

	; get column 1 data from JOYSTICK2
	lda JOYSTICK2
	asl
	asl
	asl
	and #$F0
	ora hardkbKeyStatus,x
	eor #$FF				; flip bits so that 1=down,0=up
	sta hardkbKeyStatus,x

	; check if we're done
	inx
	cpx #9
	bne @doRow

	rts

;------------------------------------------------------------------------------;
; kbHVC007_ReadWait
; Routine used to burn 58 cycles while waiting for reading keys.

; nocash docs say the wait is only 56 cycles

kbHVC007_ReadWait:
	; 6 cycles from the jsr
	ldy #8				; 2
@burnClock:
	dey					; 2*8
	bne @burnClock		; (3*8) + 2
	; todo: test if this nop is needed on hardware
	;nop					; 2
	rts					; 6

;==============================================================================;
; kbHVC007_KeyDown
; Checks if a specific key is down (pressed).

; (Params)
; ?

kbHVC007_KeyDown:
	
	rts

;==============================================================================;
; kbHVC007_KeyUp
; Checks if a specific key is up (released).

; (Params)
; ?

kbHVC007_KeyUp:
	
	rts
