.ifndef MICROASM_OPCODES
	.error "nesmon Micro 6502 Assembler requires src/opcodes.inc"
.endif

;==============================================================================;
; nesmon/src/modules/microasm.asm
; nesmon Micro 6502 Assembler
;==============================================================================;
; The nesmon Micro 6502 Assembler is a primitive single-line 6502 assembler.
; It only supports the official/documented opcodes (for now).
;==============================================================================;
; Routine naming: micasm_*
;==============================================================================;
; Addressing Modes:
; Implicit         | IMP  |(e.g. rts)
; Accumulator      | A    |(e.g. asl a)
; Immediate        | IMM  |(e.g. lda #0)
; Zero Page        | ZP   |(e.g. lda $00)
; Zero Page,X      | ZPX  |(e.g. lda $00,x)
; Zero Page,Y      | ZPY  |(e.g. lda $00,y)
; Relative         | REL  |(e.g. bmi $F8)
; Absolute         | ABS  |(e.g. jmp $6000)
; Absolute,X       | ABSX |(e.g. lda $8192,X)
; Absolute,Y       | ABSY |(e.g. lda $8192,Y)
; (Indirect)       | IND  |(e.g. jmp ($0620))
; (Indirect,X)     | INDX |(e.g. lda ($00,x))
; (Indirect),Y     | INDY |(e.g. lda ($00),y)
;==============================================================================;
; Routines:
; * micasm_ParseLine
; * micasm_Assemble
;==============================================================================;
