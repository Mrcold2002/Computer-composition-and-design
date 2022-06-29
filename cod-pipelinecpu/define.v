//操作码宏定义
//opcode
`define opcode_load 7'b0000011
`define opcode_I    7'b0010011
`define opcode_R    7'b0110011
`define opcode_S    7'b0100011
`define opcode_B    7'b1100011
`define opcode_lui  7'b0110111
`define opcode_auipc 7'b0010111
`define opcode_jal   7'b1101111
`define opcode_jalr  7'b1100111 

//立即数扩展
`define ext_I_1 3'b000//普通I型指令
`define ext_I_2 3'b001//slli,srli,srai特殊I指令
`define ext_S   3'b010
`define ext_B  3'b011
`define ext_U   3'b100
`define ext_J   3'b101
// 寄存器写入来源
`define RegDst_FromALU 2'b00
`define RegDst_FromMEM 2'b01
`define RegDst_FromPC  2'b10 
`define RegDst_FromCMP 2'b11 
//ALU操作
`define Alu_add 3'b000
`define Alu_sub 3'b001
`define Alu_xor 3'b010
`define Alu_or  3'b011
`define Alu_and 3'b100
`define Alu_sll 3'b101
`define Alu_srl 3'b110
`define Alu_sra 3'b111 
//操作位数
`define word      2'b00
`define half_word 2'b01
`define byte      2'b10
