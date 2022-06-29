module reg7(
        input clk,  //时钟脉冲
        input [6:0] datain,
        output reg[6:0] dataout
    );
    initial begin
        dataout = 0;
    end
    always @(negedge clk) begin
        dataout <= datain;
    end
endmodule