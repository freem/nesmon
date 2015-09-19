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

;==============================================================================;
; [Command Tables]

;==============================================================================;
; cmdHandler_Parse
; Main parsing routine

cmdHandler_Parse:
	; search for command at beginning of curLineBuf

	rts
;==============================================================================;

