;==============================================================================;
; nesmon/src/modules/commands.asm
; Command handler
;==============================================================================;
; This is the file that processes the commands you type in.
; Some commands are handled in their own files (e.g. assembly and disassembly).

; The command handler is separate from the editor source for maintainability.
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

; single character routines
tbl_cmdHandler_Simple: .db "ACDFGHJMRTX>;"

; multiple character routines, split by first character


; master routine table
tbl_cmdHandler_Routines:
	.dw $0000

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
; CLS
cmdHandler_Cls:
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
	rts

;==============================================================================;
; RESET
cmdHandler_Reset:
	jmp ($fffc)

;==============================================================================;
; CLRAM
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
; X
cmdHandler_X:
	; exit monitor
	lda #0
	sta inMonitor
	; hm.
	rts

;==============================================================================;
; R
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
; CHRVIEW
cmdHandler_CHRVIEW:
; if not enabled
.ifdef WITHOUT_CHRVIEW
	; str_cmdHandler_InvModule
	rts
.else
	; run CHRVIEW
	jsr chrview_Init	; has to provide rts
.endif
