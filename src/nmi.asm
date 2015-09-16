;==============================================================================;
; nesmon/src/irq.asm
; NMI code
;==============================================================================;
NMI:
	; save regs
	pha
	txa
	pha
	tya
	pha

	; do the sprite transfer as soon as possible (PAL consoles need it)
	

	; check what mode we are in (user vs. monitor)
	lda inMonitor
	beq @userMode

	; monitor mode NMI
	jmp NMI_end

@userMode:
	; user mode NMI

NMI_end:
	; restore regs
	pla
	tay
	pla
	tax
	pla
	rti