;==============================================================================;
; nesmon/src/irq.asm
; IRQ/BRK handler (pretty important in a monitor program)
;==============================================================================;
IRQ:
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

	; FME-7 needs to acknowledge IRQ
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
	jmp IRQ_end

@doMonitor:
	; check if monitor program has been invoked
	lda inMonitor
	bne @monitorLoaded

	; load monitor
	lda #1
	sta inMonitor

	; show registers

	; cool beans, go to the monitor when we're done here
	;#<editor_Init
	;#>editor_Init

@monitorLoaded:
	; BRK/IRQ when the monitor was already loaded...
	

IRQ_end:
	; restore and push status byte
	; restore and push return address lo byte
	; restore and push return address hi byte

	; restore A,X,Y
	lda int_regA
	ldx int_regX
	ldy int_regY
	rti
