`include "define.v"
module MEMreg(
        input clk,            //时钟脉冲
        input [1:0] RegDstIn, //Rd输入数据来源
        input  RegWrIn,       //Rd写使能信号
        input [1:0] DigitIn,  //读写位数
        input  DataWrIn,      //存储器写使能
        input  immresIn,      //rd是否选择imm直接作为数据
        input [1:0] cmpIn,
        input  SignIn, 
        output reg[1:0] RegDstOut, //Rd输入数据来源
        output reg RegWrOut,       //Rd写使能信号
        output reg[1:0] DigitOut,  //读写位数
        output reg DataWrOut,      //存储器写使能
        output reg immresOut,      //rd是否选择imm直接作为数据
        output reg [1:0] cmpOut,
        output reg SignOut,
        output reg mem_w,
        input [3:0] weain,
        output reg [3:0] weaout,
        input [31:0] PC
    );

    always @(negedge clk) begin
        RegDstOut <= RegDstIn;
        RegWrOut <= RegWrIn;
        DigitOut <= DigitIn;
        DataWrOut <= DataWrIn;
        immresOut <= immresIn;
        cmpOut <= cmpIn;
        SignOut<=SignIn;
        mem_w<=DataWrIn;
        weaout<=weain;
        $display("PC:%h wea:%h",PC,weain);
    end
endmodule