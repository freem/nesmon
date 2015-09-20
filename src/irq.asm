;==============================================================================;
; nesmon/src/irq.asm
; IRQ/BRK handler (pretty important in a monitor program)
;==============================================================================;
IRQ:
	rti

; hm.... this needs a lot of work.
.if 0
	; save a,x,y
	sta int_regA
	stx int_regX
	sty int_regY

	; PC and status are on stack at this point, save them too.
	pla
	sta int_PC+1		; high byte
	pla
	sta int_PC			; low byte
	pla
	sta int_regStatus	; processor status stack copy (includes "B flag")
	tsx
	stx int_regSP		; stack pointer location before the IRQ

; Mapper-specific IRQ code goes here until further notice
.ifdef FME7
	ldx #$0D
	lda #0
	stx $8000
	sta $A000
.endif

	; we need to see if we came here via BRK or not.
	lda int_regStatus
	and #%00010000
	bne @doMonitor

	; do user IRQ code
	jsr (userIRQLoc)

	; restore and push status, address lo, address hi bytes
	lda int_regStatus
	pha
	lda int_PC
	pha
	lda int_PC+1
	pha
	jmp IRQ_end

@doMonitor:
	; check if monitor program has been invoked
	lda inMonitor
	bne @monitorLoaded

	; load monitor
	lda #1
	sta inMonitor

	; show registers (run the register display command)

	; cool beans, go to the monitor code when we're done here
	lda int_regStatus
	pha
	lda #<editor_Init
	pha
	lda #>editor_Init
	pha
	jmp IRQ_end

@monitorLoaded:
	; BRK/IRQ when the monitor was already loaded...
	; what to do?

IRQ_end:
	; restore A,X,Y
	lda int_regA
	ldx int_regX
	ldy int_regY
	rti
.endif

;==============================================================================;
; DummyUserIRQ
; Dummy user IRQ routine, set by default on boot.

DummyUserIRQ:
	rts
