
//operator code 
`define OP_COP1 6'b010001
`define OP_COP1X 6'b010011
`define OP_SWC1 6'b111001
`define OP_LDC1 6'b110101
`define OP_SDC1 6'b111101
`define OP_LWC1 6'b110001

`define OP_R 6'b000000
`define OP_ORI 6'b001101
`define OP_ANDI 6'b001100
`define OP_XORI 6'b001110
`define OP_LUI 6'b001111
`define OP_SLTI 6'b001010
`define OP_SLTIU 6'b001011
`define OP_ADDI 6'b001000
`define OP_ADDIU 6'b001001

`define OP_J 6'b000010
`define OP_JAL 6'b000011
`define OP_BEQ 6'b000100
`define OP_BGTZ 6'b000111
`define OP_BLEZ 6'b000110
`define OP_BNE 6'b000101
`define OP_REGIMM 6'b000001

`define  OP_SPEC 6'b010000

`define  OP_LB 6'b100000 
`define  OP_LBU 6'b100100 
`define  OP_LH 6'b100001 
`define  OP_LHU 6'b100101
`define  OP_LW 6'b100011 
`define  OP_SB 6'b101000 
`define  OP_SH 6'b101001 
`define  OP_SW 6'b101011 
`define  OP_LL 6'b110000
`define  OP_SWL 6'b101010 
`define  OP_SWR 6'b101110
`define  OP_SC 6'b111000 
`define  OP_LWL 6'b100010 
`define  OP_LWR 6'b100110 

`define OP_BLTZ 5'b00000
`define OP_BLTZAL 5'b10000
`define OP_BGEZ 5'b00001
`define OP_BGEZAL 5'b10001

//func
`define FUNC_SLL 6'b000000
`define FUNC_SLLV 6'b000100
`define FUNC_SRL 6'b000010
`define FUNC_SRLV 6'b000110
`define FUNC_SRA 6'b000011
`define FUNC_SRAV 6'b000111

`define  FUNC_BRK 6'b001101
`define  FUNC_SYSC 6'b001100

`define  FUNC_MULT 6'b011000 
`define  FUNC_MULTU 6'b011001 
`define  FUNC_DIV 6'b011010 
`define  FUNC_DIVU 6'b011011 

`define FUNC_ADD 6'b100000
`define FUNC_ADDU 6'b100001
`define FUNC_SUB 6'b100010
`define FUNC_SUBU 6'b100011
`define FUNC_AND 6'b100100
`define FUNC_OR 6'b100101
`define FUNC_XOR 6'b100110
`define FUNC_NOR 6'b100111
`define FUNC_SLT 6'b101010
`define FUNC_SLTU 6'b101011


`define FUNC_JR 6'b001000
`define FUNC_JALR 6'b001001

`define FUNC_MOVN 6'b001011
`define FUNC_MOVZ 6'b001010
`define FUNC_MFHI 6'b010000
`define FUNC_MFLO 6'b010010
`define FUNC_MTHI 6'b010001
`define FUNC_MTLO 6'b010011

`define FUNC_MADD 6'b000000
`define FUNC_MADDU 6'b000001
`define FUNC_MSUB 6'b000100
`define FUNC_MSUBU 6'b000101
`define FUNC_MUL 6'b000010

`define FUNC_CLZ 6'b100000
`define FUNC_CLO 6'b100001
`define OP_SPEC2 6'b011100 

`define FUNC_MOVCI 6'b000001
//opcode
//arithmetic,000
`define OPC_ADD 8'b000_00001
`define OPC_SUB 8'b000_00010
`define OPC_ADDI 8'b000_00011
`define OPC_ADDIU 8'b000_00100
`define OPC_ADDU 8'b000_00101
`define OPC_SUBU 8'b000_00110
`define OPC_SLT 8'b000_00111
`define OPC_SLTI 8'b000_01000
`define OPC_SLTU 8'b000_01001
`define OPC_SLTIU 8'b000_01010

//2 conditions last
`define OPC_CLZ 8'b000_01111
`define OPC_CLO 8'b000_10000
`define OPC_ORI 8'b000_10001
`define OPC_ANDI 8'b000_10010
`define OPC_XORI 8'b000_10011
`define OPC_LUI 8'b000_10100
`define OPC_AND 8'b000_10101
`define OPC_OR 8'b000_10110
`define OPC_XOR 8'b000_10111
`define OPC_NOR 8'b000_11000
`define OPC_SLL 8'b000_11001
`define OPC_SLLV 8'b000_11010
`define OPC_SRL 8'b000_11011
`define OPC_SRLV 8'b000_11100
`define OPC_SRA 8'b000_11101
`define OPC_SRAV 8'b000_11110
`define  OPC_RESV 8'b000_11111
//mult/div,001
`define OPC_MUL 8'b001_00000
`define OPC_MADD 8'b001_00001
`define OPC_MADDU 8'b001_00010
`define OPC_MULT 8'b001_00011 
`define OPC_MULTU 8'b001_00100 
`define OPC_DIV 8'b001_00101 
`define OPC_DIVU 8'b001_00110 
`define OPC_MSUB 8'b001_00111
`define OPC_MSUBU 8'b001_01000
//branch,010
`define OPC_BLTZ 8'b010_00000
`define OPC_BGEZ 8'b010_00001
`define OPC_J 8'b010_00010
`define OPC_JAL 8'b010_00011
`define OPC_BEQ 8'b010_00100
`define OPC_BGTZ 8'b010_00111
`define OPC_BLEZ 8'b010_00110
`define OPC_BNE 8'b010_00101
`define OPC_JR 8'b010_01000
`define OPC_JALR 8'b010_01001
`define OPC_BLTZAL 8'b010_01010
`define OPC_BGEZAL 8'b010_01011
//hilo,100
`define OPC_MFHI 8'b100_10000
`define OPC_MFLO 8'b100_10010
`define OPC_MTHI 8'b100_10001
`define OPC_MTLO 8'b100_10011
//load/store,011
`define OPC_LB 8'b011_10000 
`define OPC_LBU 8'b011_10100 
`define OPC_LH 8'b011_10001 
`define OPC_LHU 8'b011_10101
`define OPC_LW 8'b011_10011 
`define OPC_LWL 8'b011_10010
`define OPC_LWR 8'b011_10110
`define OPC_LL 8'b011_10111
`define OPC_SB 8'b011_01000 
`define OPC_SH 8'b011_01001 
`define OPC_SW 8'b011_01011 
`define OPC_SWL 8'b011_01010
`define OPC_SWR 8'b011_01100
`define OPC_SC 8'b011_01110
`define OPC_MOVN 8'b011_10111
`define OPC_MOVZ 8'b011_11000

//CP0,101
`define OPC_BRK 8'b101_01101
`define  OPC_SYSC 8'b101_01100
`define  OPC_ERET 8'b101_01000
`define  OPC_MFC0 8'b101_00000
`define  OPC_MTC0 8'b101_10100//must issue as the second instr
`define  OPC_COP_U 8'b101_00001


`define FUNC_TLBP 6'b001000
`define FUNC_TLBR 6'b000001 
`define FUNC_TLBWI 6'b000010 
`define FUNC_TLBWR 6'b000110
`define OPC_TLBP 8'b110_00010
`define OPC_TLBR 8'b110_00011 
`define OPC_TLBWI 8'b110_00100 
`define OPC_TLBWR 8'b110_00110

`define OP_PREF 6'b110011 //as nop, ok
//`define OP_SSNOP //interpreted as sll
`define FUNC_SYNC 6'b001111 //a R_type instr, as nop, ok
`define FUNC_WAIT 6'b100000  //as nop, ok
`define OP_CACHE 6'b101111 
`define FUNC_I_IndexValid 5'b00000
`define FUNC_I_IndexStoreTag 5'b01000
`define FUNC_I_HitInvalid 5'b10000
`define FUNC_D_IndexWbInvalid 5'b00001 
`define FUNC_D_IndexStoreTag 5'b01001 
`define FUNC_D_IndexHitValid 5'b10001 
`define FUNC_D_HitWbInvalid 5'b10101

`define OPC_I_IndexValid 8'b110_00000
`define OPC_I_IndexStoreTag 8'b110_01000
`define OPC_I_HitInvalid 8'b110_10000
`define OPC_D_IndexWbInvalid 8'b110_00001 
`define OPC_D_IndexStoreTag 8'b110_01001 
`define OPC_D_IndexHitValid 8'b110_10001 
`define OPC_D_HitWbInvalid 8'b110_10101

