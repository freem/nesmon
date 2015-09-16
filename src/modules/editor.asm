;==============================================================================;
; nesmon/src/modules/editor.asm
; Editor routines
;==============================================================================;
; The nesmon editor is a simple line editor. This design tries to avoid storing
; a complete buffer of the visible text, as that eats up RAM.
;==============================================================================;
; editor_ColdBoot
; Display on booting from power off
;==============================================================================;
; editor_WarmBoot
; Display on resetting console
;==============================================================================;