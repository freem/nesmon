;==============================================================================;
; nesmon/src/modules/commands.asm
; Command handler
;==============================================================================;
; This is the file that processes the commands you type in.
; Some commands are handled in their own files (e.g. assembly and disassembly).

; The command handler is separate from the editor source for maintainability.
; (Coupling alert: this file calls routines from editor.asm and elsewhere)
;==============================================================================;
; Routine naming: cmdHandler_*
;==============================================================================;
; [Strings]
str_cmdHandler_RegLbl:		.db " PC   A  X  Y SP SR"
str_cmdHandler_OK:			.db "OK"
str_cmdHandler_BadCmd:		.db "BAD COMMAND"
str_cmdHandler_NoTape:		.db "NO TAPE ROUTINES"
str_cmdHandler_InvModule:	.db "NO SUCH MODULE"

;==============================================================================;
; [Command Tables]
; this needs some proper thought.

; The master command table is in alphabetical order.
; The specifics after that are very hazy and require research.

;==============================================================================;
; cmdHandler_Parse
; Main parsing routine

cmdHandler_Parse:
	; search for command at beginning of curLineBuf

	rts
;==============================================================================;


;==============================================================================;
; The Commands
;==============================================================================;


;==============================================================================;
; A (usage: A addr opcode operands)
; Assemble
cmdHandler_A:
	rts

;==============================================================================;
; C (usage: C startaddr endaddr comparestartaddr)
; Compare
cmdHandler_C:
	rts

;==============================================================================;
; CLRAM (usage: CLRAM)
cmdHandler_ClRAM:
	; clear guaranteed locations first ($300-$6FF)
	lda #0
	tax
@clearSysRAM:
	sta $0300,x
	sta $0400,x
	sta $0500,x
	sta $0600,x
	inx
	bne @clearSysRAM

	; then check for extra locations (e.g. $6000, $8000, mapper-specific, &c.)

	; stop rendering

	; reset CHR data

	; resume rendering

	rts

;==============================================================================;
; CLS (usage: CLS)
cmdHandler_Cls:
	; turn off drawing

	; clear nametables

	; reset line and scroll
	lda #0
	sta editLineNum
	sta editScrollY
	sta editScrollNT

	; reset cursor position
	lda #1
	sta edcurDispX
	sta edcurDispY

	; reset softkbPos

	; if using the software keyboard, tell it to redraw
	lda activeKBType
	bne @end

	; redraw software keyboard

@end:
	; resume drawing
	rts

;==============================================================================;
; D (usage: D startaddr endaddr)
; Disassemble
cmdHandler_D:
	rts

;==============================================================================;
; F (usage: F startaddr endaddr byte)
; Fill Memory
cmdHandler_F:
	; fill memory from startaddr to endaddr with byte

	rts

;==============================================================================;
; G (usage: G addr)
; Go (jmp)
cmdHandler_G:
	rts

;==============================================================================;
; H (usage: H startaddr endaddr data)
; Hunt
cmdHandler_H:
	rts

;==============================================================================;
; J (usage: J addr)
; Jump (jsr)
cmdHandler_J:
	rts

;==============================================================================;
; M (usage: M startaddr endaddr)
; Memory Dump
cmdHandler_M:
	rts

;==============================================================================;
; R (usage: R)
; Show Registers
cmdHandler_R
	; figure out where register labels will go
	;vramBuf_NewEntry

	; print register labels
	;ldx #<str_cmdHandler_RegLbl
	;ldy #>str_cmdHandler_RegLbl
	;lda #19
	;jsr vramBuf_AddFromPtr

	; figure out where registers will go

	; print registers
	; (PC,A,X,Y,SP,SR)
	rts


;==============================================================================;
; RESET (usage: RESET)
cmdHandler_Reset:
	jmp ($fffc)

;==============================================================================;
; T (usage: T startaddr endaddr destaddr)
; Transfer Memory Block
cmdHandler_T:
	rts

;==============================================================================;
; X (usage: X)
cmdHandler_X:
	; exit monitor
	lda #0
	sta inMonitor
	; hm. is this the right thing to do?
	rts

;==============================================================================;
; > (usage: > addr values)
; a.k.a. POKE
cmdHandler_Poke:
	
	rts

;==============================================================================;
; ; (usage: ;)
; Show and Modify Registers

; The command is named REdit because naming a command ";" sucks.
cmdHandler_REdit:
	; print register labels

	; print registers on next used line

	; put registers into line buffer for editing
	rts

;==============================================================================;


;==============================================================================;
; Module Commands
;==============================================================================;
; CHRVIEW
cmdHandler_CHRVIEW:
; if not enabled
.ifdef WITHOUT_CHRVIEW
	; str_cmdHandler_InvModule
	rts
.else
	; run CHRVIEW
	jmp chrview_Init	; has to provide rts
.endif
