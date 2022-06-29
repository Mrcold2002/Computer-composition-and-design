`include "define.v"
`timescale 1ns / 1ps
module Extend(
        input [31:0] imm,    //立即数位段
        input Sign,          //扩展符号控制信号
        input [2:0] ExtSel,  //立即数拼接方式
        output reg [31:0] extend //扩展完成立即数
    );
    
    always @(imm or ExtSel or Sign) begin
        case (ExtSel)
            `ext_I_1:begin//普通的I型指令，即31-20为12位立即数
                extend[11:0] <= imm[31:20];
                extend[31:12]<= {20{imm[31]}};
            end
            `ext_I_2:begin//slli,srli,srai，以24-20为5位立即数
                extend[4:0]  <= imm[24:20];
                extend[31:5] <= 27'b0;
            end     
            `ext_S:begin
                extend[4:0]  <= imm[11:7];
                extend[11:5] <= imm[31:25];
                extend[31:12]<= {20{imm[31]}};
            end
            `ext_B:begin
                extend[0]    <= 0;
                extend[4:1]  <= imm[11:8];
                extend[10:5] <= imm[30:25];
                extend[11]   <= imm[7];
                extend[12]   <= imm[31];
                extend[31:13]<= {19{imm[31]}};
            end
            `ext_U:begin
                extend[11:0] <= 12'b0;
                extend[31:12]<= imm[31:12];
            end
            `ext_J:begin
                extend[0] = 0;
                extend[10:1] = imm[30:21];
                extend[11] = imm[20];
                extend[19:12] = imm[19:12];
                extend[20] = imm[31];
                extend[31:21] = {11{imm[31]}};
            end
        endcase
    end
endmodule