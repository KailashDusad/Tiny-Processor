`timescale 1ns / 1ps
module Processor_tb();
reg Clk;
reg En;
reg [7:0] PC_N;
wire [15:0] Out ;
Processor uut (.Enable(En) ,.PC_N(PC_N), .Clock(Clk), .Out(Out) );
initial
begin
Clk = 0;
forever #5 Clk = ~Clk;
end
initial
begin
En = 1;
#200
//PC_N = 8'b00000000;
//#10
//PC_N = 8'b00000001;
//#10
//PC_N = 8'b00000010;
//#10
//PC_N = 8'b00000011;
//#10
//PC_N = 8'b00000100;
//#10
//PC_N = 8'b00000101;
//#10
//PC_N = 6;
//#10
//PC_N = 7;
//#10
//PC_N = 8;
//#10
//PC_N = 9;
//#10
//PC_N = 10;
//#10
//PC_N = 11;
//#10
//#10PC_N = 12;
//#10
//PC_N = 13;
//#10
//PC_N = 14;
//#10
//PC_N = 15;
//#10
//PC_N = 16;
//#10
//PC_N = 17;
//#10
//PC_N = 18;
//#10
//PC_N = 19;
//#10

$finish() ;
end
endmodule
