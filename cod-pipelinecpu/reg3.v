module reg3(
        input clk,  //时钟脉冲
        input [2:0] datain,
        output reg[2:0] dataout
    );
    initial begin
        dataout = 0;
    end
    always @(negedge clk) begin
        dataout <= datain;
    end
endmodule