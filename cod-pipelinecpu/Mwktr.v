module Mwktr(
        input clk,  //时钟脉冲
        input clear,
        input  mwkin,
        input [31:0] PC,
        input PCdelay,
        output reg mwkout
    );
    reg Mwktmp;
    always @(negedge clk) begin
        if(clear) Mwktmp<=0;
        else Mwktmp<=mwkin;
    //    if(clear) $display("PC:%h Mwk:0",PC);
     //   else $display("PC:%h Mwk:%h",PC,mwkin);
    end
    always @* begin
        mwkout<=Mwktmp;
    end
endmodule