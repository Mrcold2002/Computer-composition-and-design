module WBreg(
        input clk,            //时钟脉冲
        input [1:0] RegDstIn, //Rd输入数据来源
        input  RegWrIn,       //Rd写使能信号
        input [1:0] DigitIn,  //读写位数
        input  immresIn,      //rd是否选择imm直接作为数据
        input [1:0] cmpIn,
        input [31:0] AluOutputIn,
        input [31:0] PCIn,
        input [31:0] extendIn,

        output reg[1:0] RegDstOut, //Rd输入数据来源
        output reg RegWrOut,       //Rd写使能信号
        output reg[1:0] DigitOut,  //读写位数
        output reg immresOut,      //rd是否选择imm直接作为数据
        output reg [1:0] cmpOut,
        output reg [31:0] AluOutputOut,
        output reg [31:0] PCOut,
        output reg [31:0] extendOut
    );

    always @(negedge clk) begin
        RegDstOut <= RegDstIn;
        RegWrOut <= RegWrIn;
        DigitOut <= DigitIn;
        immresOut <= immresIn;
        cmpOut <= cmpIn;
        AluOutputOut <= AluOutputIn;
        PCOut <= PCIn;
        extendOut <= extendIn;
    end
endmodule