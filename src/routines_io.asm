;==============================================================================;
; nesmon/src/routines_io.asm
; NES hardware I/O routines (Joypads, etc?)
;==============================================================================;
.ignorenl
	REPEAT_DELAY = 15 ; (60/4)
	REPEAT_SPEED = 3
.endinl
;==============================================================================;
; io_ReadJoy
; Performs a normal read of the two regular joypads. (not DMC fortified)
; (Does not get microphone data on original Famicom)

io_ReadJoy:
	; strobe the joypad
	ldx #1
	stx JOYSTICK1
	dex
	stx JOYSTICK1

	; read 8 buttons
	ldx #8
@readLoop:
	lda JOYSTICK1
	and #3					; mask for normal input and Famicom expansion
	cmp #1					; combine via carry
	rol tmp00

	; do the same for P2
	lda JOYSTICK2
	and #3					; %00000011
	cmp #1					; carry flag is set if A is >= to 1 (normal or FC expansion joypad input)
	rol tmp01

	dex
	bne @readLoop
	rts

;==============================================================================;
; io_ReadJoySafe
; Performs a safe read of the two regular joypads. (DMC fortified)
; (Uses io_ReadJoy; caveats apply)

io_ReadJoySafe:
	lda pad1State
	sta tmp04
	lda pad2State
	sta tmp05

	jsr io_ReadJoy
	lda tmp00
	sta tmp02
	lda tmp01
	sta tmp03
	jsr io_ReadJoy

	ldx #1
@fixKeys:
	lda tmp00,x
	cmp tmp02,x
	bne @keepLastPress
	sta pad1State,x

@keepLastPress
	lda tmp04,x
	eor #$FF
	and pad1State,x
	sta pad1Trigger,x
	dex
	bpl @fixKeys

	rts

;==============================================================================;
; io_JoyRepeat
; Handles joypad repeating
; (is this ever used???)

io_JoyRepeat:
	lda pad1State,x
	beq @end
	lda pad1Trigger,x
	beq @noRestart
	sta pad1Repeat,x
	lda #REPEAT_DELAY
	sta pad1Timer,x
	bne @end

@noRestart:
	dec pad1Timer,x
	bne @end
	sta pad1Timer,x
	lda pad1Repeat,x
	and pad1State,x
	ora pad1Trigger,x
	sta pad1Trigger,x

@end:
	rts
