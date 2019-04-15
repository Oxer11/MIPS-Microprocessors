`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/08 14:42:08
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


module Controller(clk, Reset, op, funct, Zero, IorD, MemWrite, IRWrite, RegDst, MemtoReg, PCSrc, ALUControl, ALUSrcB, ALUSrcA, RegWrite, BIT, PCEn);
    input clk, Reset, Zero;
    input [5:0] op, funct;
    output IorD, MemWrite, ALUSrcA, IRWrite, RegWrite, PCEn, BIT;
    output [1:0] ALUSrcB, PCSrc, RegDst, MemtoReg;
    output [3:0] ALUControl;
    wire [2:0] aluop;
    wire PCWrite, Branch, BranchBNE, isJR;
    maindec md(clk, Reset, op, isJR, IorD, MemWrite, IRWrite, RegDst, MemtoReg, PCWrite, Branch, BranchBNE, PCSrc, aluop, ALUSrcB, ALUSrcA, RegWrite, BIT);
    aludec ad(funct, aluop, ALUControl);
    assign isJR = (op == 6'b000000) & (funct == 6'b001000);
    assign PCEn = (Branch & Zero) | (BranchBNE & ~Zero)| PCWrite;
endmodule

module maindec(clk, Reset, op, isJR, IorD, memwrite, IRWrite, RegDst, MemtoReg, PCWrite, branch, branchBNE, PCSrc, aluop, ALUSrcB, ALUSrcA, RegWrite, BIT);
    input clk, Reset, isJR;
    input [5:0] op;
    output IorD, memwrite, IRWrite, ALUSrcA, PCWrite, branch, branchBNE, RegWrite, BIT;
    output [1:0] ALUSrcB, PCSrc, RegDst, MemtoReg;
    output [2:0] aluop;
    
    parameter Fetch = 0;
    parameter Decode = 1;
    parameter MemAdr = 2;
    parameter MemRead = 3;
    parameter MemWriteback = 4;
    parameter MemWrite = 5;
    parameter Execute = 6;
    parameter ALUWriteback = 7;
    parameter Branch = 8;
    parameter ADDIExecute = 9;
    parameter ADDIWriteback = 10;
    parameter Jump = 11;
    parameter BranchBNE = 12;
    parameter ANDIExecute = 13;
    parameter ORIExecute = 14;
    parameter SLTIExecute = 15;
    parameter JRExecute = 16;
    parameter JALExecute = 17;
    
    parameter LW = 6'b100011;
    parameter SW = 6'b101011;
    parameter RTYPE = 6'b000000;
    parameter BEQ = 6'b000100;
    parameter BNE = 6'b000101;
    parameter ADDI = 6'b001000;
    parameter ANDI = 6'b001100;
    parameter ORI = 6'b001101;
    parameter SLTI = 6'b001010;
    parameter J = 6'b000010;
    parameter JAL = 6'b000011;
    
    reg [4:0] state, nextstate;
    always @(posedge clk or posedge Reset)
        if (Reset) state <= 0;
        else state <= nextstate;
    always @(*)
      case (state)
        Fetch: nextstate = Decode;
        Decode: case (op)
                  LW: nextstate = MemAdr;
                  SW: nextstate = MemAdr;
                  RTYPE: 
                    if (isJR) nextstate = JRExecute;
                    else nextstate = Execute;
                  BEQ: nextstate = Branch;
                  ADDI: nextstate = ADDIExecute;
                  ANDI: nextstate = ANDIExecute;
                  ORI: nextstate = ORIExecute;
                  SLTI: nextstate = SLTIExecute;
                  J: nextstate = Jump;
                  BNE: nextstate = BranchBNE;
                  JAL: nextstate = JALExecute;
                  default: nextstate = 5'bx;
                endcase
        MemAdr: case (op)
                  LW: nextstate = MemRead;
                  SW: nextstate = MemWrite;
                  default: nextstate = 5'bx;
                endcase
        MemRead: nextstate = MemWriteback;
        MemWriteback: nextstate = Fetch;
        MemWrite: nextstate = Fetch;
        Execute: nextstate = ALUWriteback;
        ALUWriteback: nextstate = Fetch;
        Branch: nextstate = Fetch;
        ADDIExecute: nextstate = ADDIWriteback;
        ADDIWriteback: nextstate = Fetch;
        Jump: nextstate = Fetch;
        BranchBNE: nextstate = Fetch;
        ANDIExecute: nextstate = ADDIWriteback;
        ORIExecute: nextstate = ADDIWriteback;
        SLTIExecute: nextstate = ADDIWriteback;
        JRExecute: nextstate = Fetch;
        JALExecute: nextstate = Jump;
        default: nextstate = 5'bx;
      endcase
      
    reg [19:0] controls;
    assign {IorD, memwrite, IRWrite, RegDst, MemtoReg, PCWrite, branch, branchBNE, ALUSrcA, RegWrite, BIT, ALUSrcB, PCSrc, aluop} = controls;   
    always @(*)
      case (state)
        Fetch        : controls <= 20'b00100001000000100000;
        Decode       : controls <= 20'b00000000000001100000;
        MemAdr       : controls <= 20'b00000000001001000000;
        MemRead      : controls <= 20'b10000000000000000000;
        MemWriteback : controls <= 20'b00000010000100000000;
        MemWrite     : controls <= 20'b11000000000000000000;
        Execute      : controls <= 20'b00000000001000000010;
        ALUWriteback : controls <= 20'b00001000000100000000;
        Branch       : controls <= 20'b00000000101000001001;
        ADDIExecute  : controls <= 20'b00000000001001000000;
        ADDIWriteback: controls <= 20'b00000000000100000000;
        Jump         : controls <= 20'b00000001000000010000;
        BranchBNE    : controls <= 20'b00000000011000001001;
        ANDIExecute  : controls <= 20'b00000000001001000011;
        ORIExecute   : controls <= 20'b00000000001001000100;
        SLTIExecute  : controls <= 20'b00000000001001000101;
        JRExecute    : controls <= 20'b00000001000000011000;
        JALExecute   : controls <= 20'b00010100000100000000;
        default: controls <= 20'bx;
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
