`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/07 23:00:28
// Design Name: 
// Module Name: MultiCycle
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
    assign clk48=q[22];//0.02s
    assign clk1_4hz=q[24];//0.33s      
endmodule

module MultiCycle(CLK100MHZ, Reset, sel, stop, addr, SW, DIGIT);
    input CLK100MHZ, Reset, sel, stop;
    input [4:0] addr;
    output [7:0] SW;
    output [6:0] DIGIT;
    
    wire clk, clk0, clk1, clk2, clk3;
    clkdiv CLK(CLK100MHZ, clk2, clk1, clk0);
    //MUX2 #(1) selclk3(sel, clk0, clk1, clk3);
    //MUX2 #(1) selclk(stop, clk3, 0, clk);
    assign clk = CLK100MHZ;
    wire [15:0] display;
    Display digit(clk2, {PC[15:0], display}, SW, DIGIT);
    
    wire IorD, MemWrite, ALUSrcA, IRWrite, RegWrite, PCEn, BIT, zero, SHIFT, MULen;
    wire [1:0] ALUSrcB, PCSrc, RegDst, MemtoReg;
    wire [3:0] ALUControl;
    Controller controller(clk, Reset, Instr[31:26], Instr[5:0], zero, IorD, MemWrite, IRWrite, RegDst, MemtoReg, PCSrc, ALUControl, ALUSrcB, ALUSrcA, RegWrite, BIT, PCEn, SHIFT, MULen);
    
    wire [31:0] Adr, PC, newPC, ALUOut, RD, A, B, RD1, RD2, WD3, ImmExt, ImmExtSL2, ALUResult, PCJump, Instr, Data, SrcA, SrcB;
    wire [4:0] A3;
    wire [7:0] MULResult;
    
    flopr pc(clk, Reset, PCEn, newPC, PC);
    MUX2 #(32) ADDR(IorD, PC, ALUOut, Adr);
    Mem mem(clk, Reset, MemWrite, Adr[7:0], B, RD);
    flopr instr(clk, Reset, IRWrite, RD, Instr);
    flopr data(clk, Reset, 1'b1, RD, Data);
    
    MUX4 #(5) a3(RegDst, Instr[20:16], Instr[15:11], 31, 0, A3);
    MUX4 #(32) wd3(MemtoReg, ALUOut, Data, PC, {0, MULResult}, WD3);
    RegFile rf(clk, Reset, Instr[25:21], Instr[20:16], A3, WD3, RegWrite, RD1, RD2, addr, display);
    flopr floprA(clk, Reset, 1'b1, RD1, A);
    flopr floprB(clk, Reset, 1'b1, RD2, B);
    SignExtend signextend(Instr[15:0], ImmExt, BIT);
    
    SL2 Immsl2(ImmExt, ImmExtSL2);
    MUX2 #(32) alusrcA(ALUSrcA, PC, A, SrcA);
    MUX4 #(32) aluscrB(ALUSrcB, B, 4, ImmExt, ImmExtSL2, SrcB);
    ALU alu(ALUControl, SrcA, SrcB, Instr[10:6], ALUResult, zero);
    
    mul mul_module(clk, SHIFT, MULen, A[3:0], B[3:0], MULResult);
    
    flopr floprALUResult(clk, Reset, 1'b1, ALUResult, ALUOut);
    SL2 Jumpsl2({PC[31:28], Instr[25:0]}, PCJump);
    MUX4 #(32) newpc(PCSrc, ALUResult, ALUOut, PCJump, A, newPC);
endmodule
