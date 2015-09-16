;==============================================================================;
; nesmon/src/modules/editor.asm
; Editor module
;==============================================================================;
; The nesmon editor is a simple line editor. This editor provides the core
; functionality of the nesmon toolset, as commands are entered here.

; With space at a premium, we try to avoid storing a complete buffer of the
; visible text.
;==============================================================================;
; Routine naming: editor_*
;==============================================================================;

;==============================================================================;
; editor_ColdBoot
; Display on booting from power off
;==============================================================================;
; editor_WarmBoot
; Display on resetting console
;==============================================================================;