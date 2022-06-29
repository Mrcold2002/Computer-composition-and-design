module InsMEM (
        input clk,
        input [31:0] curPC,      //PC值
        output reg[6:0] opcode,      //操作码位段
        output reg[2:0] funct3,  //3位功能码位段
        output reg[6:0] funct7,  //7位功能码位段
        output reg[4:0] rs1,     //rs1地址位段
        output reg[4:0] rs2,     //rs2地址位段
        output reg[4:0] rd,      //rd地址位段
        output reg[31:0] imm,    //立即数位段传给extend模块拼接扩展
        input   [31:0] instr  //读取得到32位指令
    );
    reg [31:0] RAM[1023:0];
    //切割指令
    always@(negedge clk)
    begin
        opcode <= instr[6:0];
        rs1 <= instr[19:15];
        rs2 <= instr[24:20];
        rd <= instr[11:7];
        funct3 <= instr[14:12];
        funct7 <= instr[31:26];
        imm <= instr;
       // $display("PC:%h rs1:%d rs2:%d rd:%h",curPC,rs1,rs2,rd);
    end
endmodule //InsMEM