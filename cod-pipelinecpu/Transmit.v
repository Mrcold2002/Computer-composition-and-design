//转发模块
//在EXE阶段的上升沿开始工作
`include "define.v"
module Transmit(
        input clk,  //时钟脉冲
        input [4:0] rs1,
        input [4:0] rs2,
        input [31:0] ReadData1,
        input [31:0] ReadData2,
        input preMwk, //pre
        input preRegWr,
        input [1:0] preRegDst,
        input [4:0] prerd,
        input [1:0] precmp,
        input [31:0] preAluOut,
        input ppreMwk,//ppre
        input ppreRegWr,
        input [1:0] ppreRegDst,
        input [4:0] pprerd,
        input [1:0] pprecmp,
        input [31:0] ppreAluOut,
        input [31:0] ppreDataOut,
        input [31:0] PC,

        output reg [31:0] RD1,
        output reg [31:0] RD2
    );
    initial begin
        RD1 <= 0;
        RD2 <= 0;
    end
    //处理rs1的冒险
    always @(posedge clk) begin
        RD1=ReadData1;
        if(ppreMwk) begin//当上上一条指令正常运作时
            if(pprerd==rs1)begin//当上上一条指令的目的寄存器位rs1时
                if(ppreRegWr) begin//当上上一条指令进行了寄存器写操作时
                    case (ppreRegDst)
                        `RegDst_FromALU:RD1=ppreAluOut;
                        `RegDst_FromMEM:RD1=ppreDataOut;
                        `RegDst_FromPC :RD1=ReadData1;
                        `RegDst_FromCMP:RD1={31'b0,pprecmp};
                    endcase
            //        $display("PC:%h 发生前前递RD1:%h ppreMwk:%h",PC,RD1,ppreMwk);
                end
            end 
        end
      //  $display("RD1:%h",RD1);
        if(preMwk) begin//当上上一条指令正常运作时
            if(prerd==rs1)begin//当上上一条指令的目的寄存器位rs1时
                if(preRegWr) begin//当上上一条指令进行了寄存器写操作时
                    case (preRegDst)
                        `RegDst_FromALU:RD1=preAluOut;
                        `RegDst_FromPC :RD1=ReadData1;
                        `RegDst_FromCMP:RD1={31'b0,precmp};
                    endcase
     //              $display("PC:%h 发生前递RD1:%h preMwk:%h",PC,RD1,preMwk);
                end
            end  
        end
        RD2=ReadData2;
        if(ppreMwk) begin//当上上一条指令正常运作时
            if(pprerd==rs2)begin//当上上一条指令的目的寄存器位rs1时
                if(ppreRegWr) begin//当上上一条指令进行了寄存器写操作时
                    case (ppreRegDst)
                        `RegDst_FromALU:RD2=ppreAluOut;
                        `RegDst_FromMEM:RD2=ppreDataOut;
                        `RegDst_FromPC :RD2=ReadData2;
                        `RegDst_FromCMP:RD2={31'b0,pprecmp};
                    endcase
        //            $display("PC:%h 发生前前递RD2:%h ppreMwk:%h",PC,RD2,ppreMwk);
                end
            end 
        end
        if(preMwk) begin//当上上一条指令正常运作时
            if(prerd==rs2)begin//当上上一条指令的目的寄存器位rs2时
                if(preRegWr) begin//当上上一条指令进行了寄存器写操作时
                    case (preRegDst)
                        `RegDst_FromALU:RD2=preAluOut;
                        `RegDst_FromPC :RD2=ReadData2;
                        `RegDst_FromCMP:RD2={31'b0,precmp};
                    endcase
         //           $display("PC:%h 发生前递RD2:%h preMwk:%h",PC,RD2,preMwk);
                end
            end  
        end
      //  $display("RD2:%h",RD2);
    end
endmodule