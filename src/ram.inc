;==============================================================================;
; nesmon/src/ram.inc
; RAM defines
;==============================================================================;
; Unlike most freemco programs, the goal of nesmon's RAM usage is to use as
; little space as possible.

; todo: account for keyboard input, the input buffer, etc.
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
	; $08-$0F: nesmon system-specific
	inMonitor           .dsb 1		; ($08) is the monitor active?
	int_PC              .dsw 1		; ($09,$0A) internal copy of program counter
	int_regA            .dsb 1		; ($0B) internal copy of A
	int_regX            .dsb 1		; ($0C) internal copy of X
	int_regY            .dsb 1		; ($0D) internal copy of Y
	int_regStatus       .dsb 1		; ($0E) internal copy of status
	int_regSP           .dsb 1		; ($0F) internal copy of stack pointer location
.ende

;==============================================================================;
; $0100/Stack

;==============================================================================;
; $0200
OAM_BUF = $0200 ; unless otherwise specified...

;==============================================================================;
; $0300

;==============================================================================;
; $0400

;==============================================================================;
; $0500

;==============================================================================;
; $0600

;==============================================================================;
; $0700
