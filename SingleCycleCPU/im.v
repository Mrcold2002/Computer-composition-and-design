//指令储存器
// instruction memory
module im(input  [11:2]  addr,
            output [31:0] dout );

  reg  [31:0] ROM[127:0];


  assign dout = ROM[addr]; // word aligned
endmodule  
//用rom