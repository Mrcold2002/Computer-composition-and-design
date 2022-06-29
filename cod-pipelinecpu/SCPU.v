`include "PC.v"
`include "InsMEM.v"
`include "reg32.v"
`include "Bubble.v"
`include "Extend.v"
`include "ControlUnit.v"
`include "ControlReg.v"
`include "AddressReg.v"
`include "reg7.v"
`include "reg3.v"
`include "reg5.v"
`include "define.v"
`include "Debug.v"
`include "Transmit.v"
`include "ALU.v"
`include "MEMreg.v"
`include "DataMEM.v"
`include "WBreg.v"
`include "RegisterFile.v"
`include "Mwktr.v"
module SCPU(
        input clk,
        input reset,
        input MIO_ready,
        input [31:0] inst_in,
        input [31:0] Datain,//从存储器拿出要写入寄存器的数据
		output mem_w,
		output [31:0]PC_out,
		output[31:0]Addr_out,
		output[31:0]Data_out, //存入存储器的数据
		output CPU_MIO,
		input INT,
		output [3:0] wea
    );
        wire [31:0] curPC; //当前PC值
        wire [4:0] rs1;//rs1的地址
        wire [31:0] ReadData1;//rs1内读入数据
        wire [4:0] rs2;//rs2的地址
        wire [31:0] ReadData2;//rs2内读入数据
        wire [31:0] AluOut;//Alu计算结果
        wire [31:0] DB;//DB总线

        wire [6:0] opcode;//操作码
        wire [4:0] rd;//目的寄存器地址
    wire [31:0] imm;//可能包含立即数的字段
    wire [31:0] extend;    //立即数扩展后结果
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] DataOut,DataOut_1;   //存储器读出数据
    wire [1:0] cmp;      //比较器输出结果

    //控制信号
    wire PCSrc;//PC值更新来源
    wire [2:0] AluOp;//Alu进行操作
    wire AluSrc1;//控制alu的第一个操作数的来源
    wire AluSrc2;//控制alu的第二个操作数的来源
    wire RegWr;//寄存器写信号
    wire [1:0] RegDst;//目的寄存器存储数据来源
    wire [2:0] ExtSel;//立即数扩展方法
    wire Sign;//立即数 有无符号扩展
    wire [1:0] Digit;//判断位数
    wire DataWr;//存储器写信号
    wire immres;//目的寄存器数据是否来自ext，特指lui指令
    wire PCdelay;//是否将PC推迟变动
//////流水线寄存器
    wire [31:0] curPC_1;
    wire Mwk_1,Mwk_0;
    
    wire [31:0] RD1, RD2, extend_2, ReadData1_2, ReadData2_2, curPC_2;
    wire [2:0] AluOp_2, ExtSel_2, funct3_2;
    wire  Mwk_2,AluSrc1_2,AluSrc2_2,Sign_2,DataWr_2,immres_2; 
    wire [1:0] RegDst_2, Digit_2;
    wire [4:0] rs1_2, rs2_2, rd_2;
    wire [6:0] opcode_2;

    wire [31:0] AluOut_3, extend_3, ReadData2_3, curPC_3;
    wire Mwk_3, DataWr_3, immres_3, RegWr_3,Sign_3; 
    wire [1:0] RegDst_3, Digit_3, cmp_3;
    wire [4:0] rs1_3, rs2_3, rd_3;

    
    wire [31:0] AluOut_4, extend_4, curPC_4;
    wire Mwk_4, immres_4, RegWr_4; 
    wire [1:0] RegDst_4, Digit_4, cmp_4;
    wire [4:0] rs1_4, rs2_4, rd_4;
    wire clear;
    wire One = 1; 
    
//初始化一些东西
//IF取指令阶段
//上升沿更新PC，下降沿取指令
//IF段可以正常运行////////////////////
    //首先更新PC值
    
    //读取指令成功
    PC pc1(
        .clk(clk),       //时钟
        .reset(reset),   //是否重置地址
        .PCSrc(PCSrc),   //数据选择器输入，0为+4，1为来自ALU
        .AluOut(AluOut_3), //ALU计算结果
        .PCdelay(PCdelay),
        .prePC(curPC_1),
        .curPC(curPC),    //当前指令的地址
        .PC_out_(PC_out)
    );
    
    //在下降沿取出指令
    InsMEM U_imem(
        .clk(clk),
        .curPC(curPC),   //PC值
        .opcode(opcode),         //操作码位段
        .funct3(funct3), //3位功能码位段
        .funct7(funct7), //7位功能码位段
        .rs1(rs1),       //rs2地址位段
        .rs2(rs2),       //rs2地址位段
        .rd(rd),         //rd地址位段
        .imm(imm),       //立即数位段传给extend模块拼接扩展
        .instr(inst_in)    //读取得到32位指令
    );
    //将当前PC值用  IF/ID流水线寄存器记录
    reg32 r32_0(
        .clk(clk),
        .datain(curPC),
        .dataout(curPC_1)
    );
    Mwktr tr0(
        .clk(clk),
        .PC(curPC),
        .clear(clear),
        .mwkin(One),
        .mwkout(Mwk_0)
    );
//
//ID阶段，译码并取得控制信号
//上升沿检测 load指令等数据冒险
    //下降沿将  read1，read2，rd，extend等控制信号转入流水线寄存器
    Bubble bb(
        //打泡模块，当load指令出现Read After Write
        //即读的还没有写时进入该模块
        .clk(clk),
        .preop(opcode_2),
        .curop(opcode),
        .prerd(rd_2),
        .Mwk(Mwk_1),
        .rs1(rs1),
        .rs2(rs2),
        .PCdelay(PCdelay),
        .PC(curPC_1),
        .Mwkin(Mwk_0)
    );
    //立即数扩展模块,扩展成功
    Extend ext(
        .imm(imm),        //立即数字段
        .Sign(Sign),      //扩展符号
        .ExtSel(ExtSel),  //扩展方式
        .extend(extend)   //扩展后立即数
    );
    //生成控制信号的模块
    ControlUnit control(
        .opcode(opcode),          //操作码
        .f3(funct3),  //3位功能码
        .f7(funct7),  //7位功能码
        .AluOp(AluOp),    //ALU操作
        .Alu1Src(AluSrc1),   //ALU1口
        .Alu2Src(AluSrc2),   //ALU2口
        .RegDst(RegDst),  //Rd位选
        .ExtSel(ExtSel),  //立即数扩展式
        .Sign(Sign),      //立即数符号扩展
        .Digit(Digit),    //读写位数
        .DataWr(DataWr),  //存储器写使能
        .immres(immres),   //rd是否选择imm直接作为数据
        .PC(curPC_1)
    );
    //将生成的信号存入 ID/EX 流水线寄存器
    wire [3:0] wea_1;
    ControlReg cr_1(
        .clk(clk),
        .AluOpIn(AluOp),
        .Alu1SrcIn(AluSrc1),
        .Alu2SrcIn(AluSrc2),
        .RegDstIn(RegDst),
        .ExtSelIn(ExtSel),
        .SignIn(Sign),
        .DigitIn(Digit),
        .DataWrIn(DataWr),
        
        .immresIn(immres),

        .AluOpOut(AluOp_2),
        .Alu1SrcOut(AluSrc1_2),
        .Alu2SrcOut(AluSrc2_2),
        .RegDstOut(RegDst_2),
        .ExtSelOut(ExtSel_2),
        .SignOut(Sign_2),
        .DigitOut(Digit_2),
        .DataWrOut(DataWr_2),
        .immresOut(immres_2),

        .MwkIn(Mwk_0&Mwk_1),
        .wea(wea_1),
        .PC(curPC_1)
    );
    //生成操作寄存器的位置 并计入流水线寄存器
    AddressReg ar_1(//判断下一步是否执行
        .clk(clk),
        .rs1In(rs1),
        .rs2In(rs2),
        .rdIn(rd),
        .rs1Out(rs1_2),
        .rs2Out(rs2_2),
        .rdOut(rd_2)//ID-EXE间工作信号
    );
    Mwktr tr1(
        .clk(clk),
        .PC(curPC_1),
        .clear(clear),
        .mwkin(Mwk_0&Mwk_1),
        .mwkout(Mwk_2)
    );
    //接下来是计入流水线寄存器，并保留一些需要保留的值
    reg32 r32_1(
        .clk(clk),
        .datain(extend),
        .dataout(extend_2)
    );
    reg32 r32_2(
        .clk(clk),
        .datain(ReadData1),
        .dataout(ReadData1_2)
    );
    reg32 r32_3(
        .clk(clk),
        .datain(ReadData2),
        .dataout(ReadData2_2)
    );
    reg32 r32_4(
        .clk(clk),
        .datain(curPC_1),
        .dataout(curPC_2)
    );
    reg7 r7_1(
        .clk(clk),
        .datain(opcode),
        .dataout(opcode_2) //保留前一条指令的op码用于load-use阻塞和执行阶段确定RegWr
    );
    reg3 r3_1(
        .clk(clk),
        .datain(funct3),
        .dataout(funct3_2) //保留前一条指令funct3码用于执行阶段确定RegWr
    );
//
//EXE阶段
//下降沿把alu结果写入寄存器，把PCSrc送回PC模块
    //转发技术模块,用来处理数据冒险
    Transmit fw(  
        //即将ALU输入寄存器时，将其值优先取出来
        .clk(clk),
        .rs1(rs1_2),//两个源寄存器地址
        .rs2(rs2_2),
        .ReadData1(ReadData1_2),//在ALU中获得
        .ReadData2(ReadData2_2),//在ALU中获得
        //判断上一条指令有无数据冒险
        .preMwk(Mwk_3),
        .preRegWr(RegWr_3),
        .preRegDst(RegDst_3),
        .prerd(rd_3),
        .precmp(cmp_3),
        .preAluOut(AluOut_3),
        //判断上上一条指令有无数据冒险
        .ppreMwk(Mwk_4),
        .ppreRegWr(RegWr_4),
        .ppreRegDst(RegDst_4),
        .pprerd(rd_4),
        .pprecmp(cmp_4),
        .ppreAluOut(AluOut_4),

        .ppreDataOut(DataOut),
        .RD1(RD1),
        .RD2(RD2),
        .PC(curPC_2)   
    );

    ALU alu1(
        .clk(clk),
        .Mwk(Mwk_2),
        .opcode(opcode_2),
        .f3(funct3_2),
        .ALUSrc1(AluSrc1_2),     //输入端1位选
        .ALUSrc2(AluSrc2_2),     //输入端2位选
        .ReadData1(RD1), //rs1寄存器读取数据
        .ReadData2(RD2), //rs2寄存器读取数据
        .extend(extend_2),       //扩展后立即数
        .PC(curPC_2),            //当前地址用于计算跳转地址
        .AluOp(AluOp_2),         //ALU功能码
        .cmp(cmp),             //比较器输出结果
        .AluOut(AluOut),  //ALU计算结果
        .PCSrc(PCSrc),
        .RegWr(RegWr),
        .clear(clear),
        .Sign(Sign_2)
    );
    reg32 r32_5(
        .clk(clk),
        .datain(AluOut),
        .dataout(AluOut_3)
    );
    
    reg32 r32_6(
        .clk(clk),
        .datain(curPC_2),
        .dataout(curPC_3)
    );
    reg32 r32_7(
        .clk(clk),
        .datain(RD2),
        .dataout(ReadData2_3)
    );
    reg32 r32_8(
        .clk(clk),
        .datain(extend_2),
        .dataout(extend_3)
    );
    AddressReg ar_2(
        .clk(clk),
        .rs1In(rs1_2),
        .rs2In(rs2_2),
        .rdIn(rd_2),
        .MwkIn(Mwk_2),
        .rs1Out(rs1_3),
        .rs2Out(rs2_3),
        .rdOut(rd_3),
        .MwkOut(Mwk_3) //EXE-MEM间工作信号
    );
    MEMreg mr_1(
        .clk(clk),
        .RegDstIn(RegDst_2),
        .RegWrIn(RegWr),
        .DigitIn(Digit_2),
        .DataWrIn(DataWr_2),
        .immresIn(immres_2),
        .cmpIn(cmp),
        .SignIn(Sign_2),

        .weain(wea_1),
        .mem_w(mem_w),
        .weaout(wea),
        .PC(curPC_2),

        .RegDstOut(RegDst_3),
        .RegWrOut(RegWr_3),
        .DigitOut(Digit_3),
        .DataWrOut(DataWr_3),
        .immresOut(immres_3),
        .cmpOut(cmp_3),
        .SignOut(Sign_3)
    );
    
    
//MEM阶段
    //上升沿把数据写入MEM，下降沿读出数据到寄存器
    assign Data_out=ReadData2_3;
    assign Addr_out=AluOut_3;
    DataMEM U_dmem(
        .Digit(Digit_3), //读写位数，00为8位，01为16位，10为32位
        .clk(clk),     //时钟下降沿写入数据
        .DataOut(DataOut), //输出数据
        .Sign(Sign_3),
        .PC(curPC_3),
        .Datain(Datain)//从存储器拿出要写入寄存器的数据
    );
    WBreg wr_1(
        .clk(clk),
        .RegDstIn(RegDst_3),
        .RegWrIn(RegWr_3),
        .DigitIn(Digit_3),
        .immresIn(immres_3),
        .cmpIn(cmp_3),
        .AluOutputIn(AluOut_3),
        .PCIn(curPC_3),
        .extendIn(extend_3),

        .RegDstOut(RegDst_4),
        .RegWrOut(RegWr_4),
        .DigitOut(Digit_4),
        .immresOut(immres_4),
        .cmpOut(cmp_4),
        .AluOutputOut(AluOut_4),
        .PCOut(curPC_4),
        .extendOut(extend_4)
    );
    AddressReg ar_3(
        .clk(clk),
        .rs1In(rs1_3),
        .rs2In(rs2_3),
        .rdIn(rd_3),
        .MwkIn(Mwk_3),
        .rs1Out(rs1_4),
        .rs2Out(rs2_4),
        .rdOut(rd_4),
        .MwkOut(Mwk_4) //MEM-WB间工作信号
    );
   reg32 r32_9(
        .clk(clk),
        .datain(DataOut),
        .dataout(DataOut_1)
    );
    //WB阶段
    RegisterFile regfile(
        .clk(clk),         //时钟
      //  .Mwk(Mwk_3),       //工作使能
        .immres(immres_4),   //立即数直接写入信号
        .rs1(rs1),         //rs1寄存器地址输入端口
        .rs2(rs2),         //rs2寄存器地址输入端口
        .WriteReg(rd_4),
        .rst(reset),
        .AluOut(AluOut_4), //ALU输出
        .extend(extend_4),       //imm扩展器输出
        .Datain(DataOut_1),      //存储器输出
        .PC(curPC_4),            //当前PC值
        .cmp(cmp_4),             //比较器输出
        .RegDst(RegDst_4),       //输入具体数据位选
        .RegWr(RegWr_4),         //写使能信号，为1时在时钟边沿触发写入
        .DB(DB),               //输入总线数据
        .ReadData1(ReadData1), //rs1寄存器数据输出端口
        .ReadData2(ReadData2)  //rs2寄存器数据输出端口
    );
endmodule