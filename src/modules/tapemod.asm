;==============================================================================;
; nesmon/src/modules/tape.asm
; Cassette tape routines
;==============================================================================;
; This is entirely optional, though recommended if you have no other way of
; getting data out of the NES/Famicom.

; (Family BASIC Keyboard)
; The tape recorder is connected to the Family BASIC Keyboard using two mono
; phone jack cables (1/8 inches, 3.5mm), one for saving data, and one for
; loading data.

; (Front-Loading NES)
; Though not officially supported, a tape recorder can be used with the
; following schematic: http://nesdev.com/tapedrv.PNG
; Top loaders lack the required expansion port, as far as I remember.

;==============================================================================;
; Routine naming: tape_*

; Required routines:
; * tape_Load
; * tape_Save
;==============================================================================;

;==============================================================================;
tape_Load:
	rts
;==============================================================================;
tape_Save:
	rts
