`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/07 23:32:47
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


module flopr(clk, reset, en, newPC, PC);
    input clk, reset, en;
    input [31:0] newPC;
    output reg [31:0] PC;
    always @(posedge clk, posedge reset)
        if (reset) PC <= 0;
        else if (en) PC <= newPC;
        else ;
endmodule

module SignExtend(datain, dataout, sel);
    input [15:0] datain;
    output [31:0] dataout;
    input sel;
    assign dataout = (sel == 0) ? {{16{datain[15]}}, datain} : {16'h0000, datain};
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

module MUX4 #(parameter WIDTH=8)(sel, a, b, c, d, out);
    input [1:0] sel;
    input [WIDTH-1:0] a, b, c, d;
    output reg [WIDTH-1:0] out;
    always @(*)
      case (sel)
        0: out <= a;
        1: out <= b;
        2: out <= c;
        3: out <= d;
        default out <= 31'bx;
      endcase
endmodule