`timescale 1ns / 1ps
module Processor(Enable ,PC_N, Clock , Out );
input Enable ;
input Clock ;
input [7:0] PC_N;
output reg [15:0]Out ;
reg [7:0]Instruction ;
reg [7:0]Accumulator ;
reg [7:0]InstructionMemory[19:0] ;
reg [7:0]PC ;
reg Carry_Borrow ;
reg [7:0]Extended ;
reg [7:0]R[15:0] ;
reg [3:0]Operation ;
reg [3:0]Address ;
reg [7:0] Dividend , Divisor ;
reg [15:0] Concatenation ;
integer k;
initial
begin
//PC = PC_N;
PC = 8'b00000000;
Extended = 8'b00000000;
Accumulator = 8'b01000100 ;
Out = {8'b00000000 , Accumulator} ;
Carry_Borrow = 0 ;
R[0] = 8'b11110000; 
R[1] = 8'b11001100; 
R[2] = 8'b10101010; 
R[3] = 8'b10010101; 
R[4] = 8'b01111000; 
R[5] = 8'b01010101; 
R[6] = 8'b00110011; 
R[7] = 8'b00001111; 
R[8] = 8'b11111111; 
R[9] = 8'b00000000; 
R[10] = 8'b10101010; 
R[11] = 8'b01010101; 
R[12] = 8'b11001100; 
R[13] = 8'b00110011; 
R[14] = 8'b11110000; 
R[15] = 8'b00001111; 

InstructionMemory[0] = 8'b00000001; //shift
InstructionMemory[1] = 8'b00000010; //shift
InstructionMemory[2] = 8'b00000011; //shift
InstructionMemory[3] = 8'b00000100; //shift
InstructionMemory[4] = 8'b00000101; //shift
InstructionMemory[5] = 8'b00000110; //increment
InstructionMemory[6] = 8'b00000111; //decriment
InstructionMemory[7] = 8'b00010000; //ADD
InstructionMemory[8] = 8'b00101000;  //SUB
InstructionMemory[9] = 8'b00110100; // MULT
InstructionMemory[10] = 8'b01000000; //DIV
InstructionMemory[11] = 8'b01010110; //AND
InstructionMemory[12] = 8'b01100111; //clear
InstructionMemory[13] = 8'b01110011; //compare
InstructionMemory[14] = 8'b10000100; //branch
InstructionMemory[15] = 8'b10010100; //Ri to ACC
InstructionMemory[16] = 8'b10100001; //ACC to Ri
InstructionMemory[17] = 8'b10110001; //Ret
InstructionMemory[18] = 8'b11111111;
InstructionMemory[19] = 8'b00000000;
end
always@(posedge Clock)
begin
Instruction= InstructionMemory[PC] ;
Operation =Instruction[7:4] ;
Address =Instruction[3:0] ;
case(Operation)
4'b1111 : $stop() ; // HALT
4'b0000 :
case(Address)
4'b0001 : begin Accumulator <= Accumulator << 1 ; Out <= Accumulator ; end // Left Shift Left Logical
4'b0010 : begin Accumulator <= Accumulator >> 1 ; Out <= Accumulator ; end // Left Shift Right Logical
4'b0011 : begin Accumulator <= {Accumulator[0] , Accumulator[7:1]} ; Out <= Accumulator ; end // Circular Right Shift
4'b0100 : begin Accumulator <= {Accumulator[6:0] , Accumulator[7]} ; Out <= Accumulator ; end // Circular Left Shift
4'b0101 : begin Accumulator <= {Accumulator[7] , Accumulator[7:1]} ; Out <= Accumulator ; end // Arithematic Right shift
4'b0110 : begin {Carry_Borrow , Accumulator} <= Accumulator + 1 ; Out <= {Carry_Borrow ,Accumulator} ; end // Increments Accumulator ;
4'b0111 : begin {Carry_Borrow , Accumulator} <= Accumulator - 1 ; Out <= {Carry_Borrow , Accumulator} ; end // Decrements Accumulator ;
endcase
4'b0001 : begin {Carry_Borrow , Accumulator} <= Accumulator + R[Address] ;  Out <= {Carry_Borrow , Accumulator}  ; end // Add

4'b0010 : begin {Carry_Borrow , Accumulator} <= Accumulator - R[Address] ;  Out <= {Carry_Borrow , Accumulator}  ; end // Subtract

4'b0011 : begin {Extended , Accumulator} <= Accumulator * R[Address]; Out <= {Extended , Accumulator} ; end // Multiply

4'b0100 : begin // Divide R[Address] 
Dividend = Accumulator;
Divisor = R[Address];
Accumulator = 8'h00;
Extended = 8'h00;
for (k = 0; k<8; k=k+1)
begin
Accumulator = Accumulator << 1;
Concatenation = {Extended, Dividend};
Concatenation = Concatenation << 1;
Extended = Concatenation[15:8];
Divisor = Concatenation[7:0];
if (Extended >= Divisor)
begin
Extended = Extended - Divisor;
Accumulator[0] = 1;
end
end
Out <= {Extended , Accumulator} ;
end
4'b0101 : begin Accumulator <= (Accumulator & R[Address]); Out <= Accumulator ; end // AND
4'b0110 : begin Accumulator <= (Accumulator ^ R[Address]); Out <= Accumulator ; end // XRA
4'b0111 : if (Accumulator < R[Address]) // CMP
begin
Carry_Borrow <= 1;
Out <= {Carry_Borrow , Accumulator} ;
end
else
begin
Carry_Borrow <= 0;
Out <= {Carry_Borrow , Accumulator} ;
end
4'b1000 : if (Carry_Borrow == 1) // Branch
begin
PC <= Address - 1;
Out <= PC ;
end
4'b1001 : begin Accumulator <= R[Address] ; Out <= Accumulator ; end // MOV ACC , Ri
4'b1010 : begin R[Address] <= Accumulator ; Out <= R[Address] ; end // MOV Ri , ACC
4'b1011 : begin PC <= Address - 1; Out <= PC ; end // Return
default : begin Accumulator <= Accumulator; Out <= Accumulator ; end
endcase
//PC = PC_N ;
PC = PC + 1;
end
endmodule
