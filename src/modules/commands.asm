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

;==============================================================================;
; cmdHandler_Parse
; Main parsing routine

cmdHandler_Parse:
	; search for command at beginning of curLineBuf

	rts
;==============================================================================;

