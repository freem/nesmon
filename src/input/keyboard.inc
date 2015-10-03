;==============================================================================;
; nesmon/src/input/keyboard.inc
; Global Keyboard driver includes
;==============================================================================;
.ignorenl
	; Jump Table indices
	KBROUTINE_RESET = 0
	KBROUTINE_GETKEYS = 2
	KBROUTINE_KEYDOWN = 4
	KBROUTINE_KEYUP = 6
.endinl

;==============================================================================;
; kb_CallRoutine (macro)
; Calls the specified hardware keyboard routine.

; (Params)
; num              Routine number to call (see above defines)

; Note: This routine uses a jmp, so be wary.

.macro kb_CallRoutine num
	; get current hardware keyboard jumptable
	lda hardkbJumpTable
	sta tmp00
	iny
	lda hardkbJumpTable+1
	sta tmp01
	; set up routine
	ldy #num
	lda (tmp00),y
	sta tmp02
	iny
	lda (tmp00),y
	sta tmp03
	; call routine
	jmp (tmp02)
.endm
