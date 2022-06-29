module AddressReg(
        input clk,  //时钟脉冲
        input [4:0] rs1In,
        input [4:0] rs2In,
        input [4:0] rdIn,
        input MwkIn,
        output reg [4:0] rs1Out,
        output reg [4:0] rs2Out,
        output reg [4:0] rdOut,
        output reg MwkOut
    );
    initial begin
        rs1Out <= 0;
        rs2Out <= 0;
        rdOut <= 0;
    end
    always @(negedge clk) begin
        rs1Out <= rs1In;
        rs2Out <= rs2In;
        rdOut <= rdIn;
        MwkOut <= MwkIn;
    end
endmodule