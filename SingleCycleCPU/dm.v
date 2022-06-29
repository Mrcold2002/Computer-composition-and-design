//数据存储器
// data memory
module dm(clk, DMWr, addr, din, Digit, dout);
   input          clk;//时钟信号
   input          DMWr;//数据写信号
   input  [8:0]   addr;
   input  [31:0]  din;
   input  [2:0]   Digit;
   output [31:0]  dout;
     
   //reg [31:0] dmem[127:0];
   reg [7:0] dmem[511:0];
   //现在需要大端法变小端法
   always @(posedge clk)
      if (DMWr) begin
         case (Digit)
            3'b000:  {dmem[addr[8:0]],dmem[addr[8:0]+1],dmem[addr[8:0]+2],dmem[addr[8:0]+3]}
                     <={din[7:0],din[15:8],din[23:16],din[31:24]};
            3'b001:  {dmem[addr[8:0]],dmem[addr[8:0]+1]}<={din[7:0],din[15:8]};
            3'b010:  dmem[addr[8:0]] <=din[7:0];
            default  dmem[addr[8:0]] <= 32'b0;
         endcase
        // dmem[addr[8:0]] <= din;
         case (Digit)
            3'b000:  $display("dmem[0x%8X] = 0x%8X,", addr , {din[31:24],din[23:16],din[15:8],din[7:0]});
            3'b001:  $display("dmem[0x%8X] = 0x%8X,", addr, {dmem[addr[8:0]+3],dmem[addr[8:0]+2],din[15:8],din[7:0]});
            3'b010:  $display("dmem[0x%8X] = 0x%8X,", addr, {dmem[addr[8:0]+3],dmem[addr[8:0]+2],dmem[addr[8:0]+1],din[7:0]});
         endcase
       //   $display("dmem[0x%8X] = 0x%8X,", addr << 2, din); 
      //   $display("Digit=%8X", Digit);
      end

   reg dout;
   always @( * ) begin
      case ( Digit )
         3'b000: dout <= {dmem[addr[8:0]+3],dmem[addr[8:0]+2],dmem[addr[8:0]+1],dmem[addr[8:0]]};
         3'b001: dout <= {{16{dmem[addr[8:0]+1][7]}},dmem[addr[8:0]+1],dmem[addr[8:0]]};
         3'b010: dout <= {{24{dmem[addr[8:0]][7]}},dmem[addr[8:0]]};
         3'b101: dout <= {16'b0,dmem[addr[8:0]+1],dmem[addr[8:0]]};
         3'b110: dout <= {24'b0,dmem[addr[8:0]]};
         default dout <= 32'b0;     
      endcase
   end // end always 

endmodule    