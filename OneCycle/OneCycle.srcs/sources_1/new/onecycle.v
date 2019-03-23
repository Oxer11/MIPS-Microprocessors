`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 15:38:08
// Design Name: 
// Module Name: onecycle
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

module clkdiv(
    input mclk,
   // input clr,
    output clk190,
    output clk48,
    output clk1_4hz
    );
    reg [27:0]q;
    initial
        q <= 0;
    always@(posedge mclk)
         q<=q+1;
    assign clk190=q[16];//0.005s
    assign clk48=q[24];//0.02s
    assign clk1_4hz=q[26];//0.33s      
endmodule

module MIPS(CLK100MHZ, Reset, sel, addr, SW, DIGIT);
    input CLK100MHZ, Reset, sel;
    input [4:0] addr;
    output [7:0] SW;
    output [6:0] DIGIT;
    wire [4:0] addr3, newaddr3;
    wire [31:0] instr, WD3, newWD3, RD1, RD2, srcA, srcB, ALUResult, ReadData, SignImm, PC, PCJump, NewPC1, NewPC2, NewPC3, PCPlus4, SignImm_sl2, PCBranch;
    wire zero, PCSrc;
    wire clk2, clk1, clk0, clk;
    clkdiv U0(CLK100MHZ, clk2, clk1, clk0);
    assign clk = (sel == 1 ? clk1: clk0);
    //Display
    wire [15:0] display;
    Display digit(clk2, {PC[15:0], display}, SW, DIGIT);
    
    //Control Unit
    wire [3:0] ALUControl;
    wire MemtoReg, MemWrite, Branch0, Branch1, ALUSrcA, ALUSrcB, RegDst, RegWrite, Jump, BIT, JR, JAL; 
    Controller controller(instr[31:26], instr[5:0], MemtoReg, MemWrite, Branch0, Branch1, ALUControl, ALUSrcA, ALUSrcB, RegDst, RegWrite, JR, Jump, BIT, JAL);
    
    //left
    MUX2 #(32) newpc1(PCSrc, PCPlus4, PCBranch, NewPC1);
    MUX2 #(32) newpc2(Jump, NewPC1, PCJump, NewPC2);
    MUX2 #(32) newpc3(JR, NewPC2, RD1, NewPC3);
    flopr pc(clk1, Reset, NewPC3, PC);
    Adder adder(PC, 4, PCPlus4);
    Imem imem(PC[7:0], instr);
    
    //middle
    MUX2 #(5) newAddr3(JAL, addr3, 5'b11111, newaddr3);
    MUX2 #(32) newwd3(JAL, WD3, PCPlus4, newWD3);
    RegFile rf(clk1, Reset, instr[25:21], instr[20:16], newaddr3, newWD3, RegWrite, RD1, RD2, addr, display);
    SignExtend signextend(instr[15:0], SignImm, BIT);
    SL2 pcjump({PCPlus4[31:28], instr[25:0]}, PCJump);
    MUX2 #(5) regdst(RegDst, instr[20:16], instr[15:11], addr3);
    
    //right
    MUX2 #(32) srca(ALUSrcA, RD1, {0, instr[10:6]}, srcA);
    MUX2 #(32) srcb(ALUSrcB, RD2, SignImm, srcB);
    ALU alu(ALUControl, srcA, srcB, ALUResult, zero);
    SL2 sl2(SignImm, SignImm_sl2);
    Adder pcbranch(SignImm_sl2, PCPlus4, PCBranch);
    assign PCSrc = (Branch0 & zero) | (Branch1 & ~zero);
    Dmem dmem(clk1, Reset, ALUResult[7:0], MemWrite, RD2, ReadData);
    MUX2 #(32) wd3(MemtoReg, ALUResult, ReadData, WD3);
endmodule
