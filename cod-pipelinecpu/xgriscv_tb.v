//=====================================================================
//
// Designer   : Yili Gong
//
// Description:
// As part of the project of Computer Organization Experiments, Wuhan University
// In spring 2021
// testbench for simulation
//
// ====================================================================
`include "Top.v"

module xgriscv_tb();
    
   reg   clk, rstn;
    
   // instantiation of xgriscv 
   Top top(
      .RSTN(rstn),.clk_100mhz(clk)
   );

   integer counter = 0;
   
   initial begin
      $readmemh("riscv32_sim1.dat", top.U2.rom);
   //   $readmemh("data.dat", top.U3.ram);
      $dumpfile("wave.vcd");
      $dumpvars;
      clk = 1;
      rstn = 1;
      #5 ;
      rstn = 0;
   end
   always begin
      #(50) clk = ~clk;

      if (clk == 1'b1) 
      begin
         counter = counter + 1;
         // comment these four lines for online judge
         //$display("clock: %d", counter);
         //$display("pc:\t\t%h", xgriscvp.pcF);
         //$display("instr:\t%h", xgriscvp.instr);
         //$display("pcw:\t\t%h", pcW);
         if ( counter>40) // set to the address of the last instruction
          begin
            //$display("pcW:\t\t%h", pcW);
            //$finish;
            $stop;
          end
      end
      
   end //end always
   
endmodule
