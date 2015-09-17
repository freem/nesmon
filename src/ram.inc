;==============================================================================;
; nesmon/src/ram.inc
; RAM defines
;==============================================================================;
; Unlike most freemco programs, the goal of nesmon's RAM usage is to use as
; little space as possible.

; todo: account for keyboard input, etc.
;==============================================================================;
; Zero Page
.enum $0000
	; $00-$07: temporary variables
	tmp00               .dsb 1
	tmp01               .dsb 1
	tmp02               .dsb 1
	tmp03               .dsb 1
	tmp04               .dsb 1
	tmp05               .dsb 1
	tmp06               .dsb 1
	tmp07               .dsb 1

	; $08-$0F: nesmon system-specific (highest priority)
	inMonitor           .dsb 1		; ($08) is the monitor active?
	int_PC              .dsw 1		; ($09,$0A) internal copy of program counter
	int_regA            .dsb 1		; ($0B) internal copy of A
	int_regX            .dsb 1		; ($0C) internal copy of X
	int_regY            .dsb 1		; ($0D) internal copy of Y
	int_regStatus       .dsb 1		; ($0E) internal copy of status
	int_regSP           .dsb 1		; ($0F) internal copy of stack pointer location

	; $10-$??: nesmon system-specific (high priority)
	vblanked            .dsb 1		; ($10) vblank flag
	runNormalVBuf       .dsb 1		; ($11) Run a VRAM Buffer update
	vramBufWritePos     .dsb 1		; ($12) Current write position in VRAM Buffer
	userNMILoc          .dsw 1		; ($13,$14) pointer to user NMI code
	;userIRQLoc          .dsw 1		; ($15,$16) pointer to user IRQ code??
	; I would like to stop this at $1F (at most), but preferably before.

.ende

;==============================================================================;
; $0100/Stack

;==============================================================================;
; $0200
OAM_BUF = $0200 ; unless otherwise specified...

;==============================================================================;
; $0300-$06FF are free to modify; that gives you 1K (1024 bytes).

;==============================================================================;
; $0700/nesmon
; This page is reserved for nesmon.

.enum $0700
	;--------------------------------------------------------------------------;
	; [nesmon system vars] { 7 bytes }
	int_ppuCtrl         .dsb 1		; internal copy of PPU_CTRL
	int_ppuMask         .dsb 1		; internal copy of PPU_MASK
	int_scrollX         .dsb 1		; internal copy of PPU_SCROLL write 1
	int_scrollY         .dsb 1		; internal copy of PPU_SCROLL write 2
	cartPRGRAM          .dsb 1		; cart PRG RAM status
	activeKBType        .dsb 1		; current keyboard type (0=software, 1=hardware)
	hardKBType          .dsb 1		; (future) variable for hardware keyboard type (0=HVC-007; 1=Subor)

	;--------------------------------------------------------------------------;
	; [editor related]
	; -- editor display logic -- { 3 bytes }
	editLineNum         .dsb 1		; current input line number
	editScrollY         .dsb 1		; current Y scroll
	editScrollNT        .dsb 1		; current nametable scroll (0=$2000,1=$2400,2=$2800,3=$2C00)
	; -- visual cursor -- { 3 bytes }
	edcurDispX          .dsb 1		; cursor X pos
	edcurDispY          .dsb 1		; cursor Y pos
	edcurBlink          .dsb 1		; cursor blinking (0=no/visible,1=invisible)
	charUnderCursor     .dsb 1		; character under cursor
	; -- current input line -- { 33 bytes }
	edcursorX           .dsb 1		; current X pos within current line
	curLineEnd          .dsb 1		; input line end
	curNumChars         .dsb 1		; current number of characters in buffer
	curLineBuf          .dsb 30		; current input line text buffer

	;--------------------------------------------------------------------------;
	; [software keyboard] { 8 bytes }
	softkbPos           .dsw 1		; nametable position for software keyboard display (starting pos $2242)
	softkbX             .dsb 1		; software keyboard cursor X pos (0-12)
	softkbY             .dsb 1		; software keyboard cursor Y pos (0-4)
	softkbShift         .dsb 1		; is the software keyboard shifted?
	softkbCtrl          .dsb 1		; software keyboard ctrl key status
	softkbAlt           .dsb 1		; software keyboard alt key status
	softkbFunc          .dsb 1		; software keyboard FN key status

	;--------------------------------------------------------------------------;
	; [hardware keyboard] { 5 bytes }
	hardkbJumpTable     .dsw 1		; pointer to current hardware keyboard jump table
	hardkbShift         .dsb 1		; hardware keyboard shift key status
	hardkbCtrl          .dsb 1		; hardware keyboard ctrl key status
	hardkbAltGr         .dsb 1		; hardware keyboard alt/graphics key status
.ende

.enum $0780
	;--------------------------------------------------------------------------;
	; [nesmon module RAM] {64 bytes}
	; Each module is going to need its own RAM space.
	moduleRAM           .dsb 64

	;--------------------------------------------------------------------------;
	; [nesmon vram buffer] {64 bytes}
	vramBufData         .dsb 64
	; calculations with 64 byte vram buffer:
	; The worst case (vram addr,length=1,tile) for all entries = 16 tiles
	; best case single (vram addr,length=61,data) = 61 tiles
	; best case rle (vram addr,length=127+,data) = 2032 tiles (16 unique)

.ende
