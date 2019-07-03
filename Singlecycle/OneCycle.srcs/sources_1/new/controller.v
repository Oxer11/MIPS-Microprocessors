`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:35:52
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

module Controller(op, funct, MemtoReg, MemWrite, Branch0, Branch1, ALUControl, ALUSrcA, ALUSrcB, RegDst, RegWrite, JR, Jump, BIT, JAL);
    input [5:0] op, funct;
    output MemtoReg, MemWrite, Branch0, Branch1, ALUSrcA, ALUSrcB, RegDst, RegWrite, JR, Jump, BIT, JAL;
    output [3:0] ALUControl;
    wire [2:0] aluop;
    wire branch;
    maindec md(op, MemtoReg, MemWrite, Branch0, Branch1, ALUSrcB, RegDst, RegWrite, Jump, aluop, BIT);
    aludec ad(funct, aluop, ALUControl);
    assign ALUSrcA = (op == 6'b000000) & ((funct == 6'b000000) | (funct == 6'b000011) | (funct == 6'b000010));
    assign JR = (op == 6'b000000) & (funct == 6'b001000);
    assign JAL = (op == 6'b000011);
endmodule

module maindec(op, MemtoReg, MemWrite, Branch0, Branch1, ALUSrcB, RegDst, RegWrite, Jump, aluop, BIT);
    input [5:0] op;
    output MemtoReg, MemWrite, Branch0, Branch1, ALUSrcB, RegDst, RegWrite, Jump, BIT;
    output [2:0] aluop;
    reg [11:0] controls;
    assign {RegWrite, RegDst, ALUSrcB, Branch0, Branch1, MemWrite, MemtoReg, Jump, aluop, BIT} = controls;
    always @(*)
      case (op)
        6'b000000: controls <= 12'b110000000100; // RTYPE
        6'b001000: controls <= 12'b101000000000; // ADDI
        6'b001100: controls <= 12'b101000000111; // ANDI
        6'b001101: controls <= 12'b101000001001; // ORI
        6'b001010: controls <= 12'b101000001010; // SLTI
        6'b101011: controls <= 12'b001001000000; // SW
        6'b100011: controls <= 12'b101000100000; // LW
        6'b000010: controls <= 12'b00000001xxx0; // J
        6'b000100: controls <= 12'b000100000010; // BEQ
        6'b000101: controls <= 12'b000010000010; // BNE
        6'b000011: controls <= 12'b10000001xxx0; // JAL
        default: controls <= 12'bxxxxxxxxxxxx; // illegal op
      endcase
endmodule

module aludec(funct, aluop, alucontrol);
    input [5:0] funct;
    input [2:0] aluop;
    output reg [3:0] alucontrol;
    always @(*)
        case (aluop)
            3'b000: alucontrol <= 3'b010; // add
            3'b001: alucontrol <= 3'b110; // sub
            3'b011: alucontrol <= 3'b000; // and
            3'b100: alucontrol <= 3'b001; // or
            3'b101: alucontrol <= 3'b111; // slt
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
