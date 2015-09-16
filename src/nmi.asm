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
	lda #0
	sta OAM_ADDR
	lda #>OAM_BUF
	sta OAM_DMA

	; check what mode we are in (user vs. monitor)
	lda inMonitor
	beq @userMode

	; do monitor mode NMI
	jmp MonitorNMI

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

;==============================================================================;
MonitorNMI:
	; todo: what to do here?

	jmp NMI_end
