module RAM(
        input clka,
        input [3:0] wea,
        input [31:0]addra,
        input [31:0]dina,
        input [31:0] PC,
        output reg [31:0] douta
    );

    reg [7:0] ram [1023:0];     // 存储器
    always@(negedge clka)
    begin
        if(addra[31]==0) douta<={ram[addra+3],ram[addra+2],ram[addra+1],ram[addra]};
        else douta<=32'b0;
      //  $display("clk:%h PC:%h addra:%h douta:%h",
       //    clka,PC,addra,{ram[addra+3],ram[addra+2],ram[addra+1],ram[addra]});
    end

    //上升沿把数据写入MEM
    always@(posedge clka)
    begin   
    //    $display("PC:%h wea:%h",PC,wea);
        if(wea!=4'b0) //写使能为1时写入数据
        begin
            if(addra[31]==0) begin
                case(wea)
                    4'b1111:begin
                        {ram[addra],ram[addra+1],ram[addra+2],ram[addra+3]}
                        <={dina[7:0],dina[15:8],dina[23:16],dina[31:24]};
                        $display("1111: dmem[0x%8X] = 0x%h,",addra ,
                         {dina[31:24],dina[23:16],dina[15:8],dina[7:0]});
                    end
                    4'b0011:begin
                        {ram[addra],ram[addra+1]}<={dina[7:0],dina[15:8]};
                    //     $display("0011:%h dmem[0x%8X] = 0x%8X,", addra ,
                    //     {ram[addra+3],ram[addra+2],dina[15:8],dina[7:0]});
                    end
                    4'b0001:begin
                        {ram[addra]}<={dina[7:0]}; 
                    //    $display("0001:%h dmem[0x%8X] = 0x%8X,",addra ,
                    //     {ram[addra+3],ram[addra+2],ram[addra+1],dina[7:0]});           
                    end
                endcase
            end
            else ram[addra]<=32'b0;
        end
    end
endmodule
