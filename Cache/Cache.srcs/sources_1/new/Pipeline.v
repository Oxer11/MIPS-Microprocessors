`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/11 08:40:43
// Design Name: 
// Module Name: Pipeline
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
         q <= q + 1;
    assign clk190=q[16];//0.005s
    assign clk48=q[22];//0.02s
    assign clk1_4hz=q[26];//0.33s      
endmodule

module Pipeline(CLK100MHZ, Reset, sel, stop, addr, SW, DIGIT);
    input CLK100MHZ, Reset, sel, stop;
    input [4:0] addr;
    output [7:0] SW;
    output [6:0] DIGIT;
    
    wire ForwardaD, ForwardbD;
    wire [1:0] ForwardaE, ForwardbE;
    wire stallF, EqualD;
    wire [4:0] RsD, RtD, RdD, RsE, RtE, RdE;
    wire [4:0] shamtD, shamtE;
    wire [4:0] WriteRegE, WriteRegM, WriteRegW;
    wire flushD, flushE, zero, stallE, stallM, stallW;
    wire [31:0] PCnextFD, PCplus4F, PCBranchD, PCF;
    wire [31:0] SignImmD, SignImmE, SignImmshD;
    wire [31:0] SrcaD, Srca2D, SrcaE, Srca2E; 
    wire [31:0] SrcbD, Srcb2D, SrcbE, Srcb2E, Srcb3E;
    wire [31:0] InstrF, PCplus4D, InstrD;
    wire [31:0] ALUOutE, ALUOutM, ALUOutW;
    wire [31:0] WriteDataM, ReadDataM, ReadDataW, ResultW;
    
    wire clk, clk0, clk1, clk2, clk3;
    clkdiv CLK(CLK100MHZ, clk2, clk1, clk0);
    MUX2 #(1) selclk3(sel, clk0, clk1, clk3);
    //MUX2 #(1) selclk(stop, clk3, 0, clk);
    assign clk = CLK100MHZ;
    wire [15:0] display;
    wire [31:0] display_data;
    Display digit(clk2, {PCF[7:0], display_data[15:0], display[7:0]}, SW, DIGIT);
    
    wire RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, BranchD, JumpD, PCSrcD, BNED, BITD, LWD;
    wire RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, LWE;
    wire RegWriteM, MemtoRegM, MemWriteM, LWM;
    wire RegWriteW, MemtoRegW;
    wire DATA_COMPLETE;
    wire [3:0] ALUControlD, ALUControlE;
    Controller controller(InstrD[31:26], InstrD[5:0], RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, BranchD, JumpD, BNED, BITD, LWD);
    assign PCSrcD = (BranchD & EqualD) | (BNED & ~EqualD);
    flopr #(10) regE(clk, Reset, ~stallE, ~stallE & flushE, 
                {RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, LWD}, 
                {RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE, LWE});
    flopr #(4) regM(clk, Reset, ~stallM, 0,
                {RegWriteE, MemtoRegE, MemWriteE, LWE},
                {RegWriteM, MemtoRegM, MemWriteM, LWM});
    flopr #(2) regW(clk, Reset, ~stallW, 0,
                {RegWriteM, MemtoRegM},
                {RegWriteW, MemtoRegW});
    
    //Fetch
    MUX4 #(32) pc({JumpD, PCSrcD}, PCplus4F, PCBranchD, {PCplus4D[31:28], InstrD[25:0], 2'b00}, 0, PCnextFD);
    flopr #(32) pcreg(clk, Reset, ~stallF, 0, PCnextFD, PCF);
    Imem imem(PCF[7:0], InstrF);
    adder pcadd1(PCF, 4, PCplus4F);
    
    flopr #(32) r1D(clk, Reset, ~stallD, 0, PCplus4F, PCplus4D);
    flopr #(32) r2D(clk, Reset, ~stallD, ~stallD & flushD, InstrF, InstrD);
    
    //Decode
    assign RsD = InstrD[25:21];
    assign RtD = InstrD[20:16];
    assign RdD = InstrD[15:11];
    assign shamtD = InstrD[10:6];
    RegFile rf(clk, Reset, RsD, RtD, WriteRegW, ResultW, RegWriteW, SrcaD, SrcbD, addr, display);  
    SignExtend se(InstrD[15:0], SignImmD, BITD);
    SL2 sl(SignImmD, SignImmshD);
    adder pcadd2(PCplus4D, SignImmshD, PCBranchD);    
    MUX2 #(32) forwardadmux(ForwardaD, SrcaD, ALUOutM, Srca2D);
    MUX2 #(32) forwardbdmux(ForwardbD, SrcbD, ALUOutM, Srcb2D); 
    eqcmp comp(Srca2D, Srcb2D, EqualD);
    assign flushD = PCSrcD | JumpD;
    
    flopr #(32) r1E(clk, Reset, ~stallE, ~stallE & flushE, SrcaD, SrcaE);
    flopr #(32) r2E(clk, Reset, ~stallE, ~stallE & flushE, SrcbD, SrcbE);
    flopr #(32) r3E(clk, Reset, ~stallE, ~stallE & flushE, SignImmD, SignImmE);
    flopr #(5) r4E(clk, Reset, ~stallE, ~stallE & flushE, RsD, RsE);
    flopr #(5) r5E(clk, Reset, ~stallE, ~stallE & flushE, RtD, RtE);
    flopr #(5) r6E(clk, Reset, ~stallE, ~stallE & flushE, RdD, RdE);
    flopr #(5) r7E(clk, Reset, ~stallE, ~stallE & flushE, shamtD, shamtE);
    
    //Execute
    MUX4 #(32) forwardaemux(ForwardaE, SrcaE, ResultW, ALUOutM, 0, Srca2E);
    MUX4 #(32) forwardbemux(ForwardbE, SrcbE, ResultW, ALUOutM, 0, Srcb2E);
    MUX2 #(32) srcbmux(ALUSrcE, Srcb2E, SignImmE, Srcb3E);
    ALU alu(ALUControlE, Srca2E, Srcb3E, shamtE, ALUOutE, zero);
    MUX2 #(5) wrmux(RegDstE, RtE, RdE, WriteRegE);
    
    flopr #(32) r1M(clk, Reset, ~stallM, 0, Srcb2E, WriteDataM);
    flopr #(32) r2M(clk, Reset, ~stallM, 0, ALUOutE, ALUOutM);
    flopr #(5) r3M(clk, Reset, ~stallM, 0, WriteRegE, WriteRegM);
    
    //Memory
    cache #(128, 4, 4) dmem(clk, Reset, ALUOutM[8:0], MemWriteM, LWM, WriteDataM, DATA_COMPLETE, ReadDataM, display_data);
    
    flopr #(32) r1W(clk, Reset, ~stallW, 0, ReadDataM, ReadDataW);
    flopr #(32) r2W(clk, Reset, ~stallW, 0, ALUOutM, ALUOutW);
    flopr #(5) r3W(clk, Reset, ~stallW, 0, WriteRegM, WriteRegW);
    
    //Writeback
    MUX2 #(32) resmux(MemtoRegW, ALUOutW, ReadDataW, ResultW);
    
    //Hazard
    hazard h(RsD, RtD, RsE, RtE, WriteRegE, WriteRegM, WriteRegW, 
                RegWriteE, RegWriteM, RegWriteW,
                MemtoRegE, MemtoRegM, BranchD, BNED, DATA_COMPLETE,
                ForwardaD, ForwardbD, ForwardaE, ForwardbE,
                stallF, stallD, flushE, stallE, stallM, stallW);
endmodule
