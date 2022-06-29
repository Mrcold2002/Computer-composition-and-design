`include "SCPU.v"
`include "ROM.v"
`include "RAM.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:32:58 06/21/2022 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Top(
input			RSTN,
//input [3:0]	BTN_y,
//input [15:0] SW,
input			clk_100mhz
/*output CR,
output seg_clk,
output seg_sout,
output SEG_PEN,
output seg_clrn,
output led_clk,
output led_sout,
output LED_PEN,
output led_clrn,
output RDY,
output readn,
output [4:0]	BTN_x*/
    );

	wire rst;
	wire [4:0] Key_out;
	wire [3:0] BTN_OK, pulse_out;
	wire [15:0] SW_OK, LED_out;
	wire [31:0] inst;
	wire mem_w, CPU_MIO, data_ram_we, MIO_Ready;
	wire counter0_out, counter1_out, counter2_out, counter_we;
	wire [3:0] WEA;
	wire [31:0] Addr_out, Data_in, Data_out, PC, spo;
    wire [31:0]	douta, counter_out, ram_data_in, CPU2IO;
	SCPU				U1(.clk(clk_100mhz),
							.reset(RSTN),
							.MIO_ready(MIO_ready),
							.inst_in(inst),
							.Datain(douta),
							.mem_w(mem_w),
							.PC_out(PC),
							.Addr_out(Addr_out),
							.Data_out(Data_out), 
							.CPU_MIO(CPU_MIO),
							.wea(WEA),
							.INT(counter0_out)
				);
	
	
	//wire [15:0]	led_out;
	wire [9:0]	ram_addr;
	
	wire GPIOf0000000_we, GPIOe0000000_we;
	
	ROM	U2(.a(PC[11:2]),
							.spo(inst));
	RAM	U3(.clka(~clk_100mhz),
							.wea(WEA),
							.addra(Addr_out),
							.dina(Data_out),
							.douta(douta),
							.PC(PC)
						);
	
endmodule
