`include "define.v"
module DataMEM(
        input [1:0] Digit,   //读写位数，00为8位，01为16位，10为32位
        input clk,           //时钟信号，下降沿写入数据
        input  Sign, 
        input [31:0] PC,
        output reg[31:0] DataOut, //输出数据
        input [31:0]Datain
    );
 //   assign Data_out=DataIn;
    //下降沿读出数据写入寄存器  
      /*   //操作位数
`define word      2'b00
`define half_word 2'b01
`define byte      2'b10*/
    always @*
    begin
    //    $display("PC:%h Datain:%h Digit:%h Sign:%h Addr:%h",PC,Datain,Digit,Sign,DAddr);
	    case(Digit)
	    	`word:begin
                DataOut <= Datain;
            end 
	    	`half_word: begin
                if(Sign) begin
                    DataOut <= {{16{Datain[15]}}, Datain[15:0]};
               //     $display("DataOut:%h",{{16{Datain[15]}}, Datain[15:0]});
                end
                else begin
                    DataOut <= {16'b0, Datain[15:0]};
            //        $display("DataOut:%h",{16'b0, Datain[15:0]});
                end
            end
	    	`byte:begin
                if(Sign) begin
                    DataOut <= {{24{Datain[7]}}, Datain[7:0]};
              //      $display("DataOut:%h",{{24{Datain[7]}}, Datain[7:0]});
                end 
                else begin
                    DataOut <= {24'b0, Datain[7:0]};
           //         $display("DataOut:%h",{24'b0, Datain[7:0]});
                end 
            end 
            default DataOut<=32'b0;
	    endcase
    end
    //上升沿把数据写入MEM
endmodule
