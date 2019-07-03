`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/11 08:45:31
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


module ALU(ALUControl, A, B, shamt, ALUResult, zero);
    input [3:0] ALUControl;
    input [31:0] A, B;
    input [4:0] shamt;
    output reg [31:0] ALUResult;
    output zero;
    always @(*)
      case (ALUControl)
        0: ALUResult <= A & B;
        1: ALUResult <= A | B;
        2: ALUResult <= A + B;
        3: ALUResult <= B << shamt;
        4: ALUResult <= A & ~B;
        5: ALUResult <= A | ~B;
        6: ALUResult <= A - B;
        7: ALUResult <= (A < B) ? 1 : 0;
        8: ALUResult <= B >> shamt; 
        9: ALUResult <= B >>> shamt;
        default: ALUResult <= 0; 
      endcase
    assign zero = (ALUResult == 0); 
endmodule

