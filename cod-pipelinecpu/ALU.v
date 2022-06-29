`include "define.v"
module ALU(
        input clk,
        input Mwk,
        input [6:0] opcode,         //操作码
        input [2:0] f3,     //3位功能码
        input ALUSrc1,          //输入端1位选
        input ALUSrc2,          //输入端2位选
        input [31:0] ReadData1, //rs1寄存器读取数据
        input [31:0] ReadData2, //rs2寄存器读取数据
        input [31:0] extend,    //扩展后立即数
        input [31:0] PC,        //当前地址用于计算跳转地址
        input [2:0] AluOp,      //ALU功能码
        input Sign,
        output reg[1:0] cmp,    //比较器输出结果
        output reg[31:0] AluOut, //ALU计算结果
        output reg PCSrc,
        output reg RegWr,
        output reg clear
    );
    reg PCSrctmp;
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;

    initial begin
        RegWr = 1;
        PCSrctmp = 0;
        PCSrc = 0;
        clear = 0;
    end
    always @(negedge clk) begin
        if (Mwk) begin
            PCSrc = PCSrctmp;
        end
        else begin
            PCSrc = 0;
        end
    end
//ALU部分
    always@(*)
    begin
        A = (ALUSrc1 == 0) ? ReadData1 : PC;
        B = (ALUSrc2 == 0) ? ReadData2 : extend;
        C = (ALUSrc2 == 1) ? ReadData2 : extend;
        //cmp部分
    //    $display("ALU 中PC:%h A:%h,B:%h C:%h src1:%h src2:%h Mwk:%h",PC,A,B,C,ALUSrc1,ALUSrc2,Mwk);
       // $display("PC:%h Sign:%h",PC,Sign);
        if(Sign==1'b1)begin
            if($signed (ReadData1) == $signed (C) ) cmp=2'b00;
            else if($signed (ReadData1) > $signed (C)) cmp=2'b10;
            else cmp=2'b01;
        end else begin
            if ($unsigned (ReadData1) == $unsigned (C))cmp=2'b00;
            else if($unsigned (ReadData1) > $unsigned (C)) cmp=2'b10;
            else cmp=2'b01;
        end
        //alu部分
        /*
            `define Alu_add 3'b000
            `define Alu_sub 3'b001
            `define Alu_xor 3'b010
            `define Alu_or  3'b011
            `define Alu_and 3'b100
            `define Alu_sll 3'b101
            `define Alu_srl 3'b110
            `define Alu_sra 3'b111 
        */
        case(AluOp)
            `Alu_add:AluOut=A+B;
            `Alu_sub:AluOut=A-B;
            `Alu_xor:AluOut=A^B;
            `Alu_or :AluOut=A|B;
            `Alu_and:AluOut=A&B;
            `Alu_sll:AluOut=A<<B;
            `Alu_srl:AluOut=A>>B;
            `Alu_sra:AluOut=$signed(A)>>>B;
        endcase
        if(opcode==`opcode_lui) AluOut=extend;
    end
    always @(*) begin
     //   $display("ALU: PC:%h Mwk:%h",PC,Mwk);
        if(Mwk==0) begin
            //当后续不需再进行时
            clear=0;
            RegWr=0;
        end else begin
            //当操作码是B型指令时
            clear=0;
            if(opcode==`opcode_B) begin
         //       $display("ALU中B型指令 PC:%h cmp:%h",PC,cmp);
                RegWr=0;
                case(f3) 
                    3'b000:begin//beq
                        if(cmp==2'b00) begin
                            PCSrctmp=1;
                            clear=1;
                        end else PCSrctmp=0;
                    end
                    3'b001:begin//bne
                        if(cmp!=2'b00) begin
                            PCSrctmp=1;
                            clear=1;
                        end else PCSrctmp=0;
                    end
                    3'b100:begin//blt
                        if(cmp==2'b01) begin
                            PCSrctmp=1;
                            clear=1;
                        end else PCSrctmp=0;
                    end
                    3'b101:begin//bge
                        if(cmp[0]==0) begin
                            PCSrctmp=1;
                            clear=1;
                        end else PCSrctmp=0;
                    end
                    3'b110:begin//bltu
                        if(cmp==2'b01) begin
                            PCSrctmp=1;
                            clear=1;
                        end else PCSrctmp=0;
                    end
                    3'b111:begin//bgeu
                        if(cmp[0]==0) begin
                            PCSrctmp=1;
                            clear=1;
                        end else PCSrctmp=0;
                    end
                endcase
            //    $display("PC:%h clear",PC,clear);
            end 
            else if(opcode==`opcode_S)begin
                //S型指令不进行寄存器写使能,PC正常变化
                RegWr = 0;
                PCSrctmp = 0;
            end
            //当为jal和jalr使，PC来自ALU，
            //且PC发生巨变，对以前操作清空
            else if(opcode==`opcode_jal) begin
                PCSrctmp = 1;
                clear = 1;
                RegWr = 1;
           //     $display("ALU中: PC:%h AluOut:%h",PC,AluOut);
            end
            else if(opcode==`opcode_jalr) begin
                PCSrctmp = 1;
                clear = 1;
                RegWr = 1;
            end else begin
                PCSrctmp = 0;
                clear=0;
                RegWr = 1;
            end
        end
    end
endmodule
