;==============================================================================;
; nesmon/src/config.inc
; nesmon Configuration file
;==============================================================================;
; Feel free to edit this file; that's what it's here for.

.ignorenl

; +-----------------------------+
; | Default Color Configuration |
; +-----------------------------+

; color schemes (BG,Text,softkey cursor)
; default:            $0F,$30,$22 (black BG, white text, purple softkey cursor)
; inverted:           $30,$0F,$12 (white BG, black text, darker purple softkey cursor)
; c64 style:          $12,$32,$02 or $02,$22,$32
; light green/black:  $0F,$3A,$2A
; amber monitor:      $07,$27,$37 (or $07,$27,$17 if you have the eyesight)
; ocean:              $0C,$21,$3C
; cotton candy:       $02,$35,$25
; gameboy classic:    $39,$09,$19 or $39,$19,$09

; DEFAULT_COLOR_BG (default: $0F)
; Default background color.
DEFAULT_COLOR_BG = $0F

; DEFAULT_COLOR_TEXT (default: $30)
; Default text color.
DEFAULT_COLOR_TEXT = $30

; DEFAULT_COLOR_SOFTKEY_CURSOR (default: $22)
; Default cursor color for the software keyboard.
DEFAULT_COLOR_SOFTKEY_CURSOR = $22

.endinl

