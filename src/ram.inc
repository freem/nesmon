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

	; I really hope I don't need any more zero page variables for nesmon, but
	; if I do, they'll start from $10.
.ende

;==============================================================================;
; $0100/Stack

;==============================================================================;
; $0200
OAM_BUF = $0200 ; unless otherwise specified...

;==============================================================================;
; $0300-$06FF are free to modify; that gives you 1K (1024 bytes).

;==============================================================================;
; $0700
; This page is reserved for nesmon.

.enum $0700
	; [nesmon system vars]
	cartPRGRAM          .dsb 1		; cart PRG RAM status
	activeKBType        .dsb 1		; current keyboard type (0=software, 1=hardware)

	; [editor related]
	; -- editor display logic --
	editLineNum         .dsb 1		; current input line number
	editScrollY         .dsb 1		; current Y scroll
	editScrollNT        .dsb 1		; current nametable scroll (0=$2000,1=$2400,2=$2800,3=$2C00)
	; -- visual cursor --
	edcurDispX          .dsb 1		; cursor X pos
	edcurDispY          .dsb 1		; cursor Y pos
	edcurBlink          .dsb 1		; is cursor blinking
	; -- current input line --
	edcursorX           .dsb 1		; current X pos within current line
	curLineEnd          .dsb 1		; input line end
	curNumChars         .dsb 1		; current number of characters in buffer
	curLineBuf          .dsb 30		; current input line text buffer

	; [software keyboard]
	softkbPos           .dsw 1		; nametable position for software keyboard
	softkbX             .dsb 1		; current software keyboard cursor X pos
	softkbY             .dsb 1		; current software keyboard cursor Y pos

	; [nesmon vram buffer]
	; 64 bytes?
	; The worst case (vram addr,length=1,tile) for all entries = 16 tiles
	; The best case (vram addr,length=61,data) = 61 tiles
.ende
