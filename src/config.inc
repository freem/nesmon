;==============================================================================;
; nesmon/src/config.inc
; nesmon Configuration file
;==============================================================================;
; Feel free to edit this file; that's what it's here for.

.ignorenl

; +-----------------------------+
; | Default Color Configuration |
; +-----------------------------+

; color schemes (first number is for BG, second is for Text)
; default:            $0F,$30 (black BG, white text)
; inverted:           $30,$0F (white BG, black text)
; c64 style:          $12,$32 or $02,$22
; light green/black:  $0F,$3A
; amber monitor:      $07,$27
; ocean:              $0C,$21
; cotton candy:       $02,$35 (subdued bg)
; gameboy classic:    $39,$19

; DEFAULT_COLOR_BG (default: $0F)
; Default background color.
DEFAULT_COLOR_BG = $0F

; DEFAULT_COLOR_TEXT (default: $30)
; Default text color.
DEFAULT_COLOR_TEXT = $30

.endinl

