`timescale 1ns / 1ps


//Engineer: Jaganndha Varma Mandhapati
//Project Name: Digital alarm clock using Nexys 4 Artix 7 FPGA board.



module alarm(clk,rst,set,alahr,alamin,H,M,S,ring);
input set,clk,rst;
input [4:0]alahr;
input [5:0]alamin;
output reg [2:0]ring=3'b000;
output[4:0]H;
output [5:0]M;
output [5:0]S;
Clock Q1(clk,rst,H,M,S);
always@(posedge clk)
begin
if(alahr==H && alamin==M && set==1'b1)
ring=3'b111;
else if(set==1'b0)
ring=3'b000;
else
ring=ring;
end
endmodule


module Clock(clk,rst,H,M,S);
input clk,rst;
output [5:0]M;
output [5:0]S;
output [4:0]H;
reg [4:0]H;
reg [5:0]M;
reg [5:0]S;
wire clkout;
clockdivider C1234(clk,clkout);
always@(posedge clkout or posedge rst)
begin
if(rst==1'b1)
begin
S=6'b000000;
M=6'b000000;
H=5'b00000;
end
else if(clkout==1'b1)begin
S=S+1'b1;
if(S==6'b111100)begin
M=M+1'b1;
S=6'b000000;
if(M==6'b111100)begin
H=H+1'b1;
M=6'b000000;
if(H==5'b11000)begin
H=5'b00000;
end
end
end
end
end
endmodule


module SevenSeg(clk,data,an,seg);
input clk;
input [63:0]data;
output reg[7:0]an,seg;
reg[19:0]counter=0;

always@(posedge clk)
counter=counter+1;

always@(counter)
begin
case(counter[19:17])
3'b000:begin
seg=data[7:0];
an=8'b11111110;
end
3'b001:begin
seg=data[15:8];
an=8'b11111101;
end
3'b010:begin
seg=data[23:16];
an=8'b11111011;
end
3'b011:begin
seg=data[31:24];
an=8'b11110111;
end
3'b100:begin
seg=data[39:32];
an=8'b11101111;
end
3'b101:begin
seg=data[47:40];
an=8'b11011111;
end
3'b110:begin
seg=data[55:48];
an=8'b10111111;
end
3'b111:begin
seg=data[63:56];
an=8'b01111111;
end
endcase
end
endmodule


module sevenseginterface(clk,alahr,alamin,rst,set,seg,an,ring);
input clk,rst,set;
input [5:0]alamin;
input [4:0]alahr;
output [7:0]seg,an;
output [2:0]ring;
wire [4:0]H;
wire [5:0]M,S;
reg [63:0]data;
wire [7:0]A[9:0];
reg [7:0]P,Q,R,L;
assign A[0]=8'hC0;
assign A[1]=8'hF9;
assign A[2]=8'hA4;
assign A[3]=8'hB0;
assign A[4]=8'h99;
assign A[5]=8'h92;
assign A[6]=8'h82;
assign A[7]=8'hF8;
assign A[8]=8'h80;
assign A[9]=8'h90;
alarm ala(clk,rst,set,alahr,alamin,H,M,S,ring);
always@(*)
begin
P={3'b000,H};
Q={2'b00,M};
R={3'b000,alahr};
L={2'b00,alamin};
data={A[P/10],A[P%10],A[Q/10],A[Q%10],A[R/10],A[R%10],A[L/10],A[L%10]};
end
SevenSeg s123(clk,data,an,seg);
endmodule


module clockdivider(clk,clkout);
input clk;
output reg clkout;
integer counter;
initial
begin
clkout=0;
counter=0;
end
always@(posedge clk)
begin
if(counter>=50000000-1)
begin
clkout=~clkout;
counter=0;
end
else
counter=counter+1;
end
endmodule


module topmodule(seg,an,sw,clk,led);
input [12:0]sw;
input clk;
output [7:0]seg,an;
output [2:0]led;
sevenseginterface i1234(clk,sw[12:8],sw[7:2],sw[0],sw[1],seg,an,led);
endmodule

