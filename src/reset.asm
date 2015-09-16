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

	; init RAM
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

	; hide sprites
	lda #$FF
@hideSpr:
	sta OAM_BUF,x
	inx
	bne @hideSpr

	; (todo: other non-PPU related setup)
	; todo part 2: mapper-specific setup code

; vblank wait 2
@waitVBL2:
	bit PPU_STATUS
	bpl @waitVBL2

	; do stuff that had to wait for the PPU to warm up

	; clear nametables
	ldx #$20
	jsr ppu_clearNT
	; the address of the second nametable to clear depends on the mirroring
.if HDR_MIRRORING == 0 ; horizontal mirroring/vertical scrolling
	ldx #$28
.else ;vertical mirroring/horizontal scrolling
	ldx #$24
.endif
	; not handled: 3 screen, 4 screen, mapper controlled mirroring.
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

	lda #$0F			; black
	ldx #$30			; white

	; I would rather keep Y as 0...
	; (POSSIBLE SPACE OPTIMIZATION POINT)
.rept 8
	sta PPU_DATA
	stx PPU_DATA
	stx PPU_DATA
	stx PPU_DATA
.endr

	; reset ppu addresses
	ldx #$3F
	stx PPU_ADDR
	sty PPU_ADDR
	sty PPU_ADDR
	sty PPU_ADDR

	; reset scroll
	sty PPU_SCROLL
	sty PPU_SCROLL

	; turn on NMI; sprites and BG are on $0000 by default
	lda #%10000000
	sta PPU_CTRL

	; don't enable sprites by default (yet); show every pixel
	lda #%00001110
	sta PPU_MASK

; xxx: temporary!!!
forever:
	jmp forever