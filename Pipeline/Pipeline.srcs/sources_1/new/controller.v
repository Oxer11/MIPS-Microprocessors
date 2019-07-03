`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/11 09:12:08
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Controller(op, funct, RegWrite, MemtoReg, MemWrite, ALUControl, ALUSrc, RegDst, Branch, Jump, BNE, BIT);
    input [5:0] op, funct;
    output RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst, Branch, Jump, BNE, BIT;
    output [3:0] ALUControl;
    wire [2:0] aluop;
    maindec md(op, RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst, Branch, Jump, aluop);
    aludec ad(funct, aluop, ALUControl);
    assign BNE = (op == 6'b000101);
    assign BIT = (op == 6'b001100) | (op == 6'b001101);
    //assign JR = (op == 6'b000000) & (funct == 6'b001000);
    //assign JAL = (op == 6'b000011);
endmodule

module maindec(op, RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst, Branch, Jump, aluop);
    input [5:0] op;
    output RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst, Branch, Jump;
    output [2:0] aluop;
    reg [9:0] controls;
    assign {RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemtoReg, Jump, aluop} = controls;
    always @(*)
      case (op)
        6'b000000: controls <= 10'b1100000010; // RTYPE
        6'b001000: controls <= 10'b1010000000; // ADDI
        6'b001100: controls <= 10'b1010000011; // ANDI
        6'b001101: controls <= 10'b1010000100; // ORI
        6'b001010: controls <= 10'b1010000101; // SLTI
        6'b101011: controls <= 10'b0010100000; // SW
        6'b100011: controls <= 10'b1010010000; // LW
        6'b000010: controls <= 10'b0000001000; // J
        6'b000100: controls <= 10'b0001000001; // BEQ
        6'b000101: controls <= 10'b0000000001; // BNE
        //6'b000011: controls <= 12'b10000001xxx0; // JAL
        default: controls <= 10'bxxxxxxxxxx; // illegal op
      endcase
endmodule

module aludec(funct, aluop, alucontrol);
    input [5:0] funct;
    input [2:0] aluop;
    output reg [3:0] alucontrol;
    always @(*)
        case (aluop)
            3'b000: alucontrol <= 4'b0010; // add
            3'b001: alucontrol <= 4'b0110; // sub
            3'b011: alucontrol <= 4'b0000; // and
            3'b100: alucontrol <= 4'b0001; // or
            3'b101: alucontrol <= 4'b0111; // slt
            default: case(funct)
                6'b100000: alucontrol <= 4'b0010; // add
                6'b100010: alucontrol <= 4'b0110; // sub
                6'b100100: alucontrol <= 4'b0000; // and
                6'b100101: alucontrol <= 4'b0001; // or
                6'b101010: alucontrol <= 4'b0111; // slt
                6'b000000: alucontrol <= 4'b0011; // sll
                6'b000010: alucontrol <= 4'b1000; // srl
                6'b000011: alucontrol <= 4'b1001; // sra
                default: alucontrol <= 4'bxxxx; // ???
              endcase
        endcase
endmodule
