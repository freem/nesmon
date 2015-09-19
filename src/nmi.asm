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

	; todo: check inputs for Start+Select (hold), Select (hold)

@afterInputCheck:
	; check what mode we are in (user vs. monitor)
	lda inMonitor
	beq @userMode

	; do monitor mode NMI
	jmp MonitorNMI

@userMode:
	; user mode NMI
	jsr (userNMILoc)

NMI_end:
	; set scroll
	ldx int_scrollX
	ldy int_scrollY
	stx PPU_SCROLL
	sty PPU_SCROLL

	; set mask
	lda int_ppuMask
	sta PPU_MASK

	; done with the vblank
	lda #0
	sta vblanked

	; restore regs
	pla
	tay
	pla
	tax
	pla
	rti

;==============================================================================;
; MonitorNMI
; NMI routines to be run in monitor mode.

MonitorNMI:
	; transfer vram buffer
	jsr vramBuf_Transfer

	; reset vram buffer write pos
	lda #0
	sta vramBufWritePos

	; reset ppu addresses
	ldx #$3F
	stx PPU_ADDR
	sta PPU_ADDR
	sta PPU_ADDR
	sta PPU_ADDR

	jmp NMI_end

;==============================================================================;
; DummyUserNMI
; Dummy user NMI routine, set by default on boot.

DummyUserNMI:
	rts
