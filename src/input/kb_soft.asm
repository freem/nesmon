;==============================================================================;
; nesmon/src/input/kb_soft.asm
; Software Keyboard (Joypad)
;==============================================================================;
; In the worst case (and most common) scenario, there is no keyboard connected
; to the console at all. This can be for various reasons, none of which are
; important. When no keyboard is available, the joypads must be used.

; Enter the software keyboard. Unlike the hardware keyboards, the software
; keyboard uses an on-screen display for input.

; (Unshifted Layout)
; 1 2 3 4 5 6 7 8 9 0 - = BSPC
;  Q W E R T Y U I O P [ ] \
;   A S D F G H J K L ; ' ENTR
; FN Z X C V B N M , . / SHIFT
; ESC  CTRL  SPACE  ALT  CLOSE

; (Shifted Layout)
; ! @ # $ % ^ & * ( ) _ + BSPC
;  Q W E R T Y U I O P [ ] \
;   A S D F G H J K L : " ENTR
; FN Z X C V B N M < > ? SHIFT
; ESC  CTRL  SPACE  ALT  CLOSE

;==============================================================================;
; Routine naming: softkb_*
;==============================================================================;
KBSignature_Soft:	.db "JOYKB"
;==============================================================================;
