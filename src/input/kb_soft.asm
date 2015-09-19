;==============================================================================;
; nesmon/src/input/kb_soft.asm
; Software Keyboard (Joypad)
;==============================================================================;
; In the worst case (and most common) scenario, there is no keyboard connected
; to the console at all. This can be for various reasons, none of which are
; important. When no keyboard is available, the joypad must be used.

; Enter the software keyboard. Unlike the hardware keyboards, the software
; keyboard uses an on-screen display for input.

; (Unshifted Layout)
; 1 2 3 4 5 6 7 8 9 0 - = BKSP
;  Q W E R T Y U I O P [ ] \
;   A S D F G H J K L ; ' ENTR
; FN Z X C V B N M , . / SHIFT
; ESC  CTRL  SPACE  ALT  CLOSE

; (Shifted Layout)
; ! @ # $ % ^ & * ( ) _ + BKSP
;  Q W E R T Y U I O P [ ] \
;   A S D F G H J K L : " ENTR
; FN Z X C V B N M < > ? SHIFT
; ESC  CTRL  SPACE  ALT  CLOSE

; The viewable space with the keyboard open is 30x16 tiles
; (30x15 if you want padding from the keyboard's top separator)

; As this keyboard is supported by default, there is no need for a jump table.
;==============================================================================;
; Routine naming: softkb_*
;==============================================================================;
KBSignature_Soft:
	.db "KB_SOFTKB"
	.db $00 ; driver version number

;==============================================================================;
softkb_Show:
	; run after holding A+B for 3 seconds, or when no hardware keyboard found
	rts
;==============================================================================;
softkb_Hide:
	; typically run on selecting "Close" (or by typing on hardware keyboard?)
	rts
;==============================================================================;
softkb_Move:
	; softkey cursor movement
	rts
;==============================================================================;
softkb_Keypress:
	; find out what key was pressed
	rts
