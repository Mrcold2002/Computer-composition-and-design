module PC (
        input clk,               //时钟
        input reset,             //是否重置地址。1-初始化PC，否则接受新地址
        input PCSrc,             //数据选择器输入
        input [31:0] AluOut,  //ALU计算结果
        input PCdelay,
        input [31:0] prePC,
        output reg[31:0] curPC,  //当前指令的地址   
        output reg[31:0] PC_out_ 
    );
    initial begin
        curPC <= -4; //初始值为-4
    end
    reg [31:0] tmp;

    always @*  begin
        curPC <= tmp;
        PC_out_<=tmp;
    end
    //检测时钟上升沿计算新指令地址 
    always@(posedge clk)
    begin
        if (reset | PCdelay) begin
            if (reset) tmp = 0;
            else tmp = prePC;
        end
        else begin
            case(PCSrc)   //仿真时
                1'b0:   tmp = curPC + 4;
                1'b1:   tmp = AluOut;
            endcase
        end
       // $display("NPC:%h PCdelay:%h",tmp,PCdelay);
    end
    
endmodule //PC