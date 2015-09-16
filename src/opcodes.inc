;==============================================================================;
; nesmon/src/opcodes.inc
; 6502 opcodes
;==============================================================================;
; These are used for the single line assembler.
; Only official/documented instructions are currently supported.

; DEFINES ONLY, NO TABLES
;==============================================================================;
.ignorenl

.ifndef MICROASM_OPCODES
MICROASM_OPCODES = 1
.endif

; IMM  == immediate
; IMP  == implied
; REL  == relative
; ZP   == zero page
; ZPX  == zero page,x
; ABS  == absolute
; ABSX == absolute,x
; ABSY == absolute,y
; INDX == (indirect,x)
; INDY == (indirect),y

;==============================================================================;
; [ADC]
OP_ADC_IMM  = $69
OP_ADC_ZP   = $65
OP_ADC_ZPX  = $75
OP_ADC_ABS  = $6D
OP_ADC_ABSX = $7D
OP_ADC_ABSY = $79
OP_ADC_INDX = $61
OP_ADC_INDY = $71

;==============================================================================;
; [AND]
OP_AND_IMM  = $29	; imm
OP_AND_ZP   = $25	; zp
OP_AND_ZPX  = $35	; zp,x
OP_AND_ABS  = $2D	; abs
OP_AND_ABSX = $3D	; abs,x
OP_AND_ABSY = $39	; abs,y
OP_AND_INDX = $21	; (ind,x)
OP_AND_INDY = $31	; (ind),y

;==============================================================================;
; [ASL]
OP_ASL_A    = $0A	; accu
OP_ASL_ZP   = $06	; zp
OP_ASL_ZPX  = $16	; zp,x
OP_ASL_ABS  = $0E	; abs
OP_ASL_ABSX = $1E	; abs,x

;==============================================================================;
; [BCC, BCS, BEQ]
OP_BCC_REL  = $90	; rel
OP_BCS_REL  = $B0	; rel
OP_BEQ_REL  = $F0	; rel

;==============================================================================;
; [BIT]
OP_BIT_ZP   = $24	; zp
OP_BIT_ABS  = $2C	; abs

;==============================================================================;
; [BMI, BNE, BPL]
OP_BMI_REL  = $30	; rel
OP_BNE_REL  = $D0	; rel
OP_BPL_REL  = $10	; rel

;==============================================================================;
; [BRK]
OP_BRK_IMP  = $00	; imp

;==============================================================================;
; [BVC, BVS]
OP_BVC_REL  = $50	; rel
OP_BVS_REL  = $70	; rel

;==============================================================================;
; [CLC, CLD, CLI, CLV]
OP_CLC_IMP  = $18	; implied
OP_CLD_IMP  = $D8	; implied
OP_CLI_IMP  = $58	; implied
OP_CLV_IMP  = $B8	; implied

;==============================================================================;
; [CMP]
;OP_CMP_IMM
;OP_CMP_ZP
;OP_CMP_ZPX
;OP_CMP_ABS
;OP_CMP_ABSX
;OP_CMP_ABSY
;OP_CMP_INDX
;OP_CMP_INDY

;==============================================================================;
; [CPX]
;OP_CPX_IMM
;OP_CPX_ZP
;OP_CPX_ABS

;==============================================================================;
; [CPY]
;OP_CPY_IMM
;OP_CPY_ZP
;OP_CPY_ABS

;==============================================================================;
; [DEC]
;OP_DEC_
;OP_DEC_
;OP_DEC_
;OP_DEC_

;==============================================================================;
; [DEX, DEY]
OP_DEX_IMP  = $CA	; implied
OP_DEY_IMP  = $88	; implied

;==============================================================================;
; [EOR]
;OP_EOR_
;OP_EOR_
;OP_EOR_
;OP_EOR_
;OP_EOR_
;OP_EOR_
;OP_EOR_
;OP_EOR_

;==============================================================================;
; [INC]
;OP_INC_
;OP_INC_
;OP_INC_
;OP_INC_

;==============================================================================;
; [INX, INY]
OP_INX_IMP  = $E8	; implied
OP_INY_IMP  = $C8	; implied

;==============================================================================;
; [JMP]
OP_JMP_ABS  = $4C	; abs
OP_JMP_IND  = $6C	; (ind)

;==============================================================================;
; [JSR]
OP_JSR_ABS  = $20	; abs

;==============================================================================;
; [LDA]
OP_LDA_IMM  = $A9
OP_LDA_ZP   = $A5
OP_LDA_ZPX  = $B5
OP_LDA_ABS  = $AD
OP_LDA_ABSX = $BD
OP_LDA_ABSY = $B9
OP_LDA_INDX = $A1
OP_LDA_INDY = $B1

;==============================================================================;
; [LDX]
;OP_LDX_
;OP_LDX_
;OP_LDX_
;OP_LDX_
;OP_LDX_

;==============================================================================;
; [LDY]
;OP_LDY_
;OP_LDY_
;OP_LDY_
;OP_LDY_
;OP_LDY_

;==============================================================================;
; [LSR]
;OP_LSR_A
;OP_LSR_ZP
;OP_LSR_ZPX
;OP_LSR_ABS
;OP_LSR_ABSX

;==============================================================================;
; [NOP]
OP_NOP_IMP  = $EA	; implied

;==============================================================================;
; [ORA]
;OP_ORA_
;OP_ORA_
;OP_ORA_
;OP_ORA_
;OP_ORA_
;OP_ORA_
;OP_ORA_
;OP_ORA_

;==============================================================================;
; [PHA,PHP,PLA,PLP]
OP_PHA_IMP  = $48	; implied
OP_PHP_IMP  = $08	; implied
OP_PLA_IMP  = $68	; implied
OP_PLP_IMP  = $28	; implied

;==============================================================================;
; [ROL]
;OP_ROL_
;OP_ROL_
;OP_ROL_
;OP_ROL_
;OP_ROL_

;==============================================================================;
; [ROR]
;OP_ROR_
;OP_ROR_
;OP_ROR_
;OP_ROR_
;OP_ROR_

;==============================================================================;
; [RTI, RTS]
OP_RTI_IMP  = $40	; implied
OP_RTS_IMP  = $60	; implied

;==============================================================================;
; [SBC]
;OP_SBC_
;OP_SBC_
;OP_SBC_
;OP_SBC_
;OP_SBC_
;OP_SBC_
;OP_SBC_

;==============================================================================;
; [SEC, SED, SEI]
OP_SEC_IMP  = $38	; implied
OP_SED_IMP  = $F8	; implied
OP_SEI_IMP  = $78	; implied

;==============================================================================;
; [STA]
;OP_STA_
;OP_STA_
;OP_STA_
;OP_STA_
;OP_STA_
;OP_STA_
;OP_STA_

;==============================================================================;
; [STX]
;OP_STX_
;OP_STX_
;OP_STX_

;==============================================================================;
; [STY]
;OP_STY_
;OP_STY_
;OP_STY_

;==============================================================================;
; [TAX, TAY, TSX, TXA, TXS, TYA]
OP_TAX_IMP  = $AA	;implied
OP_TAY_IMP  = $A8	;implied
OP_TSX_IMP  = $BA	;implied
OP_TXA_IMP  = $8A	;implied
OP_TXS_IMP  = $9A	;implied
OP_TYA_IMP  = $98	;implied

.endinl
