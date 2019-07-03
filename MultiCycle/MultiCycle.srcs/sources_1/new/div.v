`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/22 16:21:24
// Design Name: 
// Module Name: mul
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

module adder(sel, a, b, c, carry);
    input sel;
    input [3:0] a, b;
    output [3:0] c;
    output carry;
    assign {carry, c} = (sel == 0) ? (a + b) : (a - b);
endmodule

module div(clk, shift, wen, sel, A, B, C, sign);
    input clk, shift, wen, sel;
    input [7:0] A;
    input [3:0] B;
    output [3:0] C;
    output sign;
    reg [3:0] HI, LO;
    wire [3:0] result;
    adder add(sel, HI, B, result, sign);
    always @(posedge clk)
      if (wen) {HI, LO} <= A;
      else if (shift) {HI, LO} <= {carry, result, LO[3:1]};
      else {HI, LO} <= {HI, LO}; 
    assign C = HI;
endmodule
