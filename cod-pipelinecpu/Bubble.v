`include "define.v"
//位于ID译码阶段的上升沿阶段
//当上一条指令是load时并出现 read after writing
//将本条PC指令送回PC模块使PC延时
//并将工作使能信号Mwktmp置为0，使得该指令对后续失效
module Bubble(
        input clk,  //时钟脉冲
        input [6:0] preop,
        input [6:0] curop,
        input [4:0] prerd,
        input [4:0] rs1,
        input [4:0] rs2,
        input [31:0] PC, 
        output reg PCdelay,
        output  reg Mwk,
        input Mwkin
    );
    reg Mwktmp;
    initial begin
        //非阻塞赋值并行完成
        PCdelay<=0;
        Mwktmp<=1;
    end
  always @* begin
    Mwk<=Mwktmp;
  end
    //检测上一条指令为load
    always @* begin
       // $display("Bubble中 PC:%h rs1:%h rs2:%h rd:%h",PC,rs1,rs2,prerd);
        if(Mwkin==0) begin
            PCdelay<=0;
            Mwktmp<=0;
        end else
        if(preop==`opcode_load) begin//当上一条指令是load时
            if(curop != `opcode_load & curop != `opcode_I)begin
                if (rs1==prerd|rs2==prerd) begin
                //当操作寄存器1为load指令的目的寄存器时
                //此时PC延迟变换，相当于空过一个周期         
                    PCdelay<=1;    
                    Mwktmp<=0;
                end else begin
                    PCdelay<=0;
                    Mwktmp<=1;
                end
            end else begin
                if (rs1==prerd) begin
                //当操作寄存器1为load指令的目的寄存器时
                //此时PC延迟变换，相当于空过一个周期         
                    PCdelay<=1;    
                    Mwktmp<=0;
                end else begin
                    PCdelay<=0;
                    Mwktmp<=1;
                end
            end
            
        end else begin//无事发生
            PCdelay<=0;
            Mwktmp<=1;
        end  
  //      $display("Bubble中 PC:%h Mwktmp:%h clear:%h",PC,Mwktmp,clear);
    end
endmodule