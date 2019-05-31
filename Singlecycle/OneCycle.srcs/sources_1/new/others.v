`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 19:47:17
// Design Name: 
// Module Name: others
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

module flopr(clk, reset, newPC, PC);
    input clk, reset;
    input [31:0] newPC;
    output reg [31:0] PC;
    always @(posedge clk, posedge reset)
        if (reset) PC <= 0;
        else PC <= newPC;
endmodule

module SignExtend(datain, dataout, sel);
    input [15:0] datain;
    output [31:0] dataout;
    input sel;
    assign dataout = (sel == 0) ? {{16{datain[15]}}, datain} : {16'h0000, datain};
endmodule

module Adder(a, b, c);
    input [31:0] a, b;
    output [31:0] c;
    assign c = a + b;
endmodule

module SL2(a, b);
    input [31:0] a;
    output [31:0] b;
    assign b = {a[29:0],2'b00};
endmodule

module MUX2 #(parameter WIDTH=8)(sel, a, b, c);
    input sel;
    input [WIDTH-1:0] a, b;
    output [WIDTH-1:0] c;
    assign c = (sel == 0) ? a : b; 
endmodule

