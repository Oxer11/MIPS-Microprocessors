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

module adder(en, a, b, c, carry);
    input en;
    input [3:0] a, b;
    output [3:0] c;
    output carry;
    assign {carry, c} = a + ((en == 1) ? b : 0);
endmodule

module mul(clk, shift, wen, A, B, C);
    input clk, shift, wen;
    input [3:0] A, B;
    output [7:0] C;
    reg [3:0] HI, LO;
    wire [3:0] result;
    wire carry;
    adder add(LO[0], HI, A, result, carry);
    always @(posedge clk)
      if (wen) {HI, LO} <= {4'b0000, B};
      else if (shift) {HI, LO} <= {carry, result, LO[3:1]};
      else {HI, LO} <= {HI, LO}; 
    assign C = {HI, LO};
endmodule
