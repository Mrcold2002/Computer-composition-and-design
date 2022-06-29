module Debug(
    input clk,
    input Mwk,
    input [31:0]PC
    );
    always @(negedge clk)begin
        $display("Debug PC:%h Mwk:%h",PC,Mwk);
    end
endmodule