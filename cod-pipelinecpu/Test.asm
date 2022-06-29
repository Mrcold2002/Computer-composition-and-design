# Test File for 8 Instruction, include:
# ADD/SUB/OR/AND/LW/SW/ORI/BEQ
################################################################
### Make sure following Settings :
# Settings -> Memory Configuration -> Compact, Data at address 0

.text

// 1. add/sub/add/or/xor  // R型  //ojbk

	addi x1,x0,15	//x1=15= f
	addi x2,x1,13	//x2=28=1c
	add x3,x2,x1 	//x3=43=2b
	sub x4,x3,x2 	//x4=43-28=15=f
	and x5,x4,x3 	//x5=15&43=11=b
	or x6,x5,x4  	//x6=11|15=15=f
	xor x31,x6,x2	//x31=15^28=13
    0x00F00093	
    0x00D08113		
    0x001101B3		
    0x40218233		
    0x003272B3		
    0x0042E333	
    0x00234FB3

// 2. ori/xori/addi/  //ojbk

	addi x1,x0,1023		//x1 = 3fff = 1023
	ori x2,x1,1024		//x2 = 7fff = 2047
	andi x3,x2,511		//x3 = 1fff = 511
	xori x4,x3,444		//x4 = 0043 = 67
    0x3FF00093
    0x4000E113
    0x1FF17193
    0x1BC1C213

// 3. lw,sw //S型  //ojbk

	addi x1,x0,1023 //x1=1023=0x3ff
	sw x1,0(x0) //dmem[0] = 1023=0x000003ff
	addi x2,x1,511
	sw x2,4(x0)//dmem[4]=1023+511=0x5fe
	lw x3,0(x0)//x3=0x3ff
	lw x4,4(x0)//x4=0x5fe
    0x3FF00093
    0x00102023
    0x1FF08113
    0x00202223
    0x00002183
    0x00402203

// 4.beq   //SB型指令
	ori x29, x0, 12//x29 = 12
	ori x8, x0, 0x123 // x8 = 0x123
	ori x9, x0, 0x456 // x9 = 0x456
	add x7, x8, x9//x7 = 0x579
	sub x6, x7, x9 //x6 = 0x123
    or  x10, x8, x9 // x10 = 0x123 | 0x456 = 0x577
    and x11, x9, x10// 0x11 = 0x456 & 0x577 = 0x 456
	sw x8, 0(x0) // dem[0] = 0x123
	sw x9, 4(x0)//dem[4]=0x456
	sw x7, 4(x29)//dem[16] = 0x579
	lw x5, 0(x0)//x5 = dem[0] = 0x123
	beq x8, x5, _lb2 // x8==x5? 相等，跳到 _lb2   //2c
	_lb1:lw x9, 4(x29)	//x9 = dem[16]=0x579		 //30
	_lb2:lw x5, 4(x0) // x5 = dem[4] = 0x456 		 //34
	beq x9, x5, _lb1 // x5==x9? 相等，跳到_lb1    //38
	0x00C06E93
0x12306413
0x45606493
0x009403B3
0x40938333
0x00946533
0x00A4F5B3
0x00802023
0x00902223
0x007EA223
0x00002283
0x00540463
0x004EA483
0x00402283
0xFE548CE3


// 5. jal,jalr  //SB型特殊指令	//ojbk
	addi x1,x0,15	//x1=15= f 0
	addi x2,x1,13	//x2=28=1c 4
	jal x1,4//x1=c 8
	add x3,x2,x1 	//x3=40=0x28 c
	sub x4,x3,x2 	//x4=40-28=12=c 10
	and x5,x4,x3 	//x5=12&40=8 14
	addi x5,x0,8 //18
	jalr x1,x5,0//1c
	or x6,x5,x4  	//x6=11|15=15=f
	xor x31,x6,x2	//x31=15^28=13
	sub x4,x3,x2 	//x4=43-28=15=f
	0x00F00093
	0x00D08113
	0x004000EF
	0x001101B3
	0x40218233
	0x003272B3
	0x00800293
	0x000280E7
	0x0042E333
	0x00234FB3
	0x40218233

// 6.sll,srl,sra R型 //ojbk
	addi x1,x0,2//x1=2
	addi x2,x1,1//x2=3
	sll x3,x2,x1//x3=3<<2 = 12=0xc
	xori x4,x3,456//x4 = 0x1c4
	addi x5,x4,-687 //x5 = -235 = -0xeb = 0xffffff15
	srl x6,x5,x1//x6=(x5>>2)（逻辑右移） = 0x3fffffc5 
	sra x7,x5,x1//x7=ffffffc5
    0x00200093
    0x00108113
    0x001111B3
    0x1C81C213
    0xD5120293
    0x0012D333
    0x4012D3B3

// 7.slli,srli,srai I型  //ojbk
	
	addi x1,x0,7//x1=7
	slli x2,x1,5//x2=7*32=14*16=0xe0
	addi x3,x2,-1023//x3=-799=-0x31f=0xfffffce1
	srli x4,x3,6//x4=0x03fffff3
	srai x5,x3,8//x5=0xfffffffc
	0x00700093
	0x00509113
	0xC0110193
	0x0061D213
	0x4081D293

// 8.slt,sltu rd =(rs1<rs2)? 1:0 R型指令 ojbk
//	 slti,sltiu rd = (rs1<imm)? 1:0 I型指令 

	ori x1,x0,54//x1=54=0x36
	ori x2,x0,-5//x2=-5=0xfffffffb
	slt x3,x1,x2//x3 =(signed) (x1<x2) = 0 
	slt x4,x2,x1//x4 = (x2<x1) =1
	sltu x5,x1,x2//x5=(unsigned) (x1<x2) = 1
	sltu x6,x2,x1//x6=~x5=0

	slti x7,x1,1023// x7 =(signed) (x1<1023) = 1
	slti x8,x1,53// x8 = ~x7 = 0
	sltiu x9,x1,89// x9 = (unsigned)(x1<89)=1
	sltiu x10,x1,-4//x10 = (unsigned)(x1<-4)=1 
	sltiu x11,x2,8//x11 = (unsigned) (-5<8) = 0
	sltiu x12,x2,-10//x12 = (unsigned) (-5<-10) = 0
	sltiu x13,x2,-5// 0 两个相等的情况
	slti x14,x2,-5// 0
	sltiu x15,x1,54
	slti x16,x1,54
	slt x17,x1,x1
	slt x18,x2,x2
	sltu x19,x1,x1
	sltu x20,x2,x2
	0x03606093
	0xFFB06113
	0x0020A1B3
	0x00112233
	0x0020B2B3
	0x00113333
	0x3FF0A393
	0x0350A413
	0x0590B493
	0xFFC0B513
	0x00813593
	0xFF613613
	0xFFB13693
	0xFFB12713
	0x0360B793
	0x0360A813
	0x0010A8B3
	0x00212933
	0x0010B9B3
	0x00213A33
	0xFFE00113
	0XFFF13093

// 9.lui,auipc U型指令   ///ojbk
	lui x1,0x12345//x1=0x12345000
	addi x2,x1,0x678//x2=0x12345678
	auipc x3,0x55678//x3=55678008
    0x123450B7
    0x67808113
    0x55678197

// 10. lb,lh,lbu,lhu,sb,sh I型和S型 //ojbk
	lui x1,0xfffff //x1=0xfffff000
	addi x2,x1,0x33f//x2=fffff33f
	sw x2,37(x0)//dmem[0x29]=fffff33f
	lb x3,37(x0)//x3=0x0000003f
	lh x4,37(x0)//x4=0xffff f33f
	lbu x5,37(x0)//x5=0x000003f
	lhu x6,37(x0)//x6=0x0000f33f
	sb x2,41(x0)
	sh x2,45(x0)
	0xFFFFF0B7
	0x33F08113
	0x022022A3
	0x02500183
	0x02501203
	0x02504283
	0x02505303
	0x022004A3
	0x022016A3

// 11. bne\blt\bge\bltu\bgeu 
/*
	addi x1,x0,4
	addi x2,x0,6
	bne x1,x2,8
	addi x1,x1,1
	blt x1,x2,-4
	bge x1,x2,8
	addi x1,x1,1
	bltu x1,x2,8
	addi,x1,x1,1
	addi x1,x1,-456
	bltu x2,x1,8
	addi x1,x1,456
	addi x1,x1,1
	bgeu x1,x2,8
	0x00400093
	0x00600113
	0x00209463
	0x00108093
	0xFE20CEE3
	0x0020D463
	0x00108093
	0x0020E463
	0x00108093
	0xE3808093
	0x00116463
	0x1C808093
	0x00108093
	0x0020F463
*/
	addi x1,x0,-4
	addi x3,x0,5
	bltu x1,x3,8
	addi x2,x0,4
	addi x2,x0,8
	# Never return


// load 冒险
	addi x1,x0,0x4
	sw x1,0(x0),
	lw x2,0(x0),
	add x2,x2,x2
	add x2,x2,x2
	add x2,x2,x2
	0x00400093
	0x00102023
	0x00002103
	0x00210133
	0x00210133
	0x00210133
//jal 
	addi x2,x0,4
	jal x1,

