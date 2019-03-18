`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 19:46:36
// Design Name: 
// Module Name: alu
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

module ALU(ALUControl, A, B, ALUResult, zero);
    input [2:0] ALUControl;
    input [31:0] A, B;
    output reg [31:0] ALUResult;
    output zero;
    always @(*)
      case (ALUControl)
        0: ALUResult <= A & B;
        1: ALUResult <= A | B;
        2: ALUResult <= A + B;
        4: ALUResult <= A & ~B;
        5: ALUResult <= A | ~B;
        6: ALUResult <= A - B;
        7: ALUResult <= (A < B) ? 1 : 0;
        default: ALUResult <= 0; 
      endcase
    assign zero = (ALUResult == 0); 
endmodule
