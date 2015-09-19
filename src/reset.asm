;==============================================================================;
; nesmon/src/reset.asm
; Reset code
;==============================================================================;
Reset:
	sei
	cld

	; disable APU frame IRQ
	ldx #$40
	stx JOYSTICK2

	; set up stack
	ldx #$ff
	txs

	; initialize some things
	inx
	stx PPU_CTRL		; disable NMI
	stx PPU_MASK		; disable rendering
	stx APU_DMC_FREQ	; disable DMC IRQ

	bit PPU_STATUS
; vblank wait 1
@waitVBL1:
	bit PPU_STATUS
	bpl @waitVBL1

	; check reset detection string
	ldx #0
@checkResetString:
	lda resetStringBuf,x
	cmp resetString,x
	bne @stringNotFound
	inx
	cpx #6
	bne @checkResetString
	beq @afterClearRAM

@stringNotFound:
	; init all RAM
	lda #0
	txa
@clearRAM:
	sta $00,x
	sta $100,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	inx
	bne @clearRAM

	; write reset detection string
	ldx #0
@writeResetString
	lda resetString,x
	sta resetStringBuf,x
	inx
	cpx #6
	bne @writeResetString

@afterClearRAM:
	; hide sprites
	jsr ppu_HideSprites

	; set default user NMI
	ldx #<DummyUserNMI
	ldy #>DummyUserNMI
	stx userNMILoc
	sty userNMILoc+1
	; set default user IRQ
	ldx #<DummyUserIRQ
	ldy #>DummyUserIRQ
	stx userIRQLoc
	sty userIRQLoc+1

	; set hardware keyboard jump table addr
	; xxx: needs edits for when multi-keyboard support is added
	; (Family BASIC keyboard will be the default)
.ifdef KB_FAMIBASIC
	ldx #<kbDriver_HVC007
	ldy #>kbDriver_HVC007
.endif
.ifdef KB_SUBOR
	ldx #<kbDriver_Subor
	ldy #>kbDriver_Subor
.endif
	stx hardkbJumpTable
	sty hardkbJumpTable+1

	; check for WRAM at $6000-$7FFF
	; xxx: only checks $6000; MMC6's RAM starts at $7000
	lda $6000
	sta tmp00			; save original value
	lda #$AA
	sta $6000			; write new value
	lda $6000
	cmp tmp00			; compare
	beq @noWRAM6000

	; WRAM exists at $6000 (and hopefully up to $7FFF)
	lda cartPRGRAM
	ora #%00000001
	sta cartPRGRAM

	; clear things we've messed with
	lda #0
	sta $6000
	sta tmp00
	jmp @afterWRAM6000

@noWRAM6000:
	lda cartPRGRAM
	and #%11111110
	sta cartPRGRAM

@afterWRAM6000:
	; (todo: other non-PPU related setup)

	; Mapper-specific setup code
.ifdef FME7
	jsr fme7_Setup		; do FME-7 specific setup
.endif

; vblank wait 2
@waitVBL2:
	bit PPU_STATUS
	bpl @waitVBL2

	; do stuff that had to wait for the PPU to warm up

	; clear nametables
	ldx #$20
	jsr ppu_clearNT
	; the address of the second nametable to clear depends on the mirroring
	; not handled: 3 screen, 4 screen, mapper controlled mirroring.
	; You'll have to do that yourself, sorry.
.if HDR_MIRRORING == 0 ; horizontal mirroring/vertical scrolling
	ldx #$28
.else ;vertical mirroring/horizontal scrolling
	ldx #$24
.endif
	jsr ppu_clearNT

	; clear CHR-RAM
	ldx #$00
	jsr ppu_clearCHR
	ldx #$10
	jsr ppu_clearCHR

	; load our charset
	; --part 1: first 16 tiles at $0000--
	ldx #<chr_charset
	ldy #>chr_charset
	stx tmp00
	sty tmp01
	ldx #$00
	ldy #$00
	lda #16
	jsr ppu_load1BPPCHR_c0

	; --part 2: remaining tiles at $0200--
	ldx #<chr_charset
	ldy #>chr_charset
	stx tmp00
	sty tmp01
	; adjust pointer to load second set
	clc
	lda tmp00
	adc #$80
	sta tmp00
	lda tmp01
	adc #0
	sta tmp01
	; perform the load
	ldx #$02
	ldy #$00
	lda #64
	jsr ppu_load1BPPCHR_c0

	; set initial palette
	ldx #$3F
	ldy #$00
	stx PPU_ADDR
	sty PPU_ADDR

	; BG1
	lda #$0F			; black
	ldx #$30			; white
	sta PPU_DATA
	stx PPU_DATA
	stx PPU_DATA
	stx PPU_DATA

	; BG2
	ldx #$16
	sta PPU_DATA
	stx PPU_DATA
	stx PPU_DATA
	stx PPU_DATA

	; BG3
	sta PPU_DATA
	sty PPU_DATA
	sty PPU_DATA
	sty PPU_DATA

	; xxx: BG4 and sprite pals are temporary
	ldx #$30

	; I would rather keep Y as 0...
	; (POSSIBLE SPACE OPTIMIZATION POINT)
.rept 5
	sta PPU_DATA
	stx PPU_DATA
	stx PPU_DATA
	stx PPU_DATA
.endr

	; (the following parts assume Y is 0)

	; reset ppu addresses
	ldx #$3F
	stx PPU_ADDR
	sty PPU_ADDR
	sty PPU_ADDR
	sty PPU_ADDR

	; reset scroll
	sty PPU_SCROLL
	sty int_scrollX
	sty PPU_SCROLL
	sty int_scrollY

	; turn on NMI; sprites and BG are on $0000 by default
	lda #%10000000
	sta PPU_CTRL
	sta int_ppuCtrl

	; enable sprites and bg; show every pixel
	lda #%00011110
	sta PPU_MASK
	sta int_ppuMask

	; before jumping into the monitor, set the destination PC to forever
	; (used if someone runs the exit command right after the monitor opens)
	ldx #<forever
	ldy #>forever
	stx int_PC
	sty int_PC+1

	; jump into the monitor
	lda #1
	sta inMonitor
	jmp editor_Init

; if we got here, something is wrong. you need to reset or power cycle.
forever:
	jmp forever
