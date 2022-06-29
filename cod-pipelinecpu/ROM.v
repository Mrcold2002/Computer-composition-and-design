module ROM (
        input [9:0] a,      //PC值
        output reg [31:0] spo  //读取得到32位指令
    );
    reg [31:0] rom[1023:0];
    //下降沿取指令
    always@*begin
        //取指令
        spo = rom[a];
       // $display("spo:%h",spo);
    end
endmodule 