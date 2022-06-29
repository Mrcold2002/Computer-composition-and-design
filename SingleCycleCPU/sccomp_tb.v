`include "sccomp.v"
// testbench for simulation
module sccomp_tb();
    
   reg  clk, rstn;
   reg  [4:0] reg_sel;
   wire [31:0] reg_data;
    
// instantiation of sccomp    
   sccomp U_SCCOMP(
      .clk(clk), .rstn(rstn), .reg_sel(reg_sel), .reg_data(reg_data) 
   );

  	integer foutput;
  	integer counter = 0;
   
   initial begin
      $readmemh( "Test_8_Instr.dat" , U_SCCOMP.U_IM.ROM); // load instructions into instruction memory
      $monitor("PC = 0x%8X, instr = 0x%8X", U_SCCOMP.PC, U_SCCOMP.instr); // used for debug
      foutput = $fopen("results.txt");
      $dumpfile("wave.vcd");
      $dumpvars;
      clk = 1;
      rstn = 1;
      #5 ;
      rstn = 0;
      #20 ;
      rstn = 1;
      #1000 ;
      reg_sel = 7;
   end
    integer i;
    always begin
    #(50) clk = ~clk;
    if (clk == 1'b1) begin
      if ((counter == 500) || (U_SCCOMP.instr=== 32'hxxxxxxxx)) begin
        $fclose(foutput);
        $stop;
      end
      else begin
       // if (U_SCCOMP.PC == 32'h00000fff) begin
          $fdisplay(foutput, "周期数                                :%h",counter);
          counter = counter + 1;
          $fdisplay(foutput, "pc:\t %h", U_SCCOMP.PC);
          $fdisplay(foutput, "instr:\t\t %h", U_SCCOMP.instr);
          /*$fdisplay(foutput, "rf00-03:\t %h %h %h %h", 0, U_SCCOMP.U_SCPU.U_RF.rf[1], U_SCCOMP.U_SCPU.U_RF.rf[2], U_SCCOMP.U_SCPU.U_RF.rf[3]);
          $fdisplay(foutput, "rf04-07:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[4], U_SCCOMP.U_SCPU.U_RF.rf[5], U_SCCOMP.U_SCPU.U_RF.rf[6], U_SCCOMP.U_SCPU.U_RF.rf[7]);
          $fdisplay(foutput, "rf08-11:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[8], U_SCCOMP.U_SCPU.U_RF.rf[9], U_SCCOMP.U_SCPU.U_RF.rf[10], U_SCCOMP.U_SCPU.U_RF.rf[11]);
          $fdisplay(foutput, "rf12-15:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[12], U_SCCOMP.U_SCPU.U_RF.rf[13], U_SCCOMP.U_SCPU.U_RF.rf[14], U_SCCOMP.U_SCPU.U_RF.rf[15]);
          $fdisplay(foutput, "rf16-19:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[16], U_SCCOMP.U_SCPU.U_RF.rf[17], U_SCCOMP.U_SCPU.U_RF.rf[18], U_SCCOMP.U_SCPU.U_RF.rf[19]);
          $fdisplay(foutput, "rf20-23:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[20], U_SCCOMP.U_SCPU.U_RF.rf[21], U_SCCOMP.U_SCPU.U_RF.rf[22], U_SCCOMP.U_SCPU.U_RF.rf[23]);
          $fdisplay(foutput, "rf24-27:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[24], U_SCCOMP.U_SCPU.U_RF.rf[25], U_SCCOMP.U_SCPU.U_RF.rf[26], U_SCCOMP.U_SCPU.U_RF.rf[27]);
          $fdisplay(foutput, "rf28-31:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[28], U_SCCOMP.U_SCPU.U_RF.rf[29], U_SCCOMP.U_SCPU.U_RF.rf[30], U_SCCOMP.U_SCPU.U_RF.rf[31]);
          */
          for(i=0;i<32;i=i+1)
            $fdisplay(foutput,"r%02d: %h",i,U_SCCOMP.U_SCPU.U_RF.rf[i]);
          $fdisplay(foutput, "Memory:\t" );
          for (i=0;i<128;i=i+4)
            $fdisplay(foutput, "dm%02d:\t %h %h %h %h", i, 
            U_SCCOMP.U_DM.dmem[i],U_SCCOMP.U_DM.dmem[i+1], 
            U_SCCOMP.U_DM.dmem[i+2], U_SCCOMP.U_DM.dmem[i+3]);
          
          //$fdisplay(foutput, "hi lo:\t %h %h", U_SCCOMP.U_SCPU.U_RF.rf.hi, U_SCCOMP.U_SCPU.U_RF.rf.lo);
        //  $fclose(foutput);
        //  $stop;
       // end
       /* else begin
          counter = counter + 1;
        //  $display("pc: %h", U_SCCOMP.U_SCPU.PC);
       *  $display("instr: %h", U_SCCOMP.U_SCPU.instr);
        end*/
      end
    end
  end //end always
   
endmodule
