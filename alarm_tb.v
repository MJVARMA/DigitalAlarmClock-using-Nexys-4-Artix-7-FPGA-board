module alarm_tb;
reg set,clk,rst;
reg [4:0]alahr;
reg [5:0]alamin;
wire [2:0]ring;
wire [4:0]H;
wire [5:0]M;
wire [5:0]S;
alarm alm(clk,rst,set,alahr,alamin,H,M,S,ring);
initial
clk=0;
always
#1 clk=~clk;
initial
begin
rst=1;
#4 rst=0;
alahr=5'b00000;
alamin=6'b000001;
set=1'b0;
#500 set=1'b1;
#500 $stop;
end
endmodule
