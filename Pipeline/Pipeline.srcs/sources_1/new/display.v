`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/11 08:44:02
// Design Name: 
// Module Name: display
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


module Display(clk, D, SW, DIGIT);
    input clk;
    input [31:0] D;
    output reg [7:0] SW;
    output reg [6:0] DIGIT;
    reg [3:0] now;
    reg [2:0] cur;
    always @ (posedge clk)
    begin
        case (cur)
            3'b000: begin SW = 8'b11111110; now = D[3:0]; end
            3'b001: begin SW = 8'b11111101; now = D[7:4]; end
            3'b010: begin SW = 8'b11111011; now = D[11:8]; end
            3'b011: begin SW = 8'b11110111; now = D[15:12]; end
            3'b100: begin SW = 8'b11101111; now = D[19:16]; end
            3'b101: begin SW = 8'b11011111; now = D[23:20]; end
            3'b110: begin SW = 8'b10111111; now = D[27:24]; end
            3'b111: begin SW = 8'b01111111; now = D[31:28]; end
            default: begin SW = 8'bxxxxxxxx; now = 4'bxxxx; end
        endcase
        case (now)
            4'b0000: DIGIT = 7'b1000000;
            4'b0001: DIGIT = 7'b1111001;
            4'b0010: DIGIT = 7'b0100100;
            4'b0011: DIGIT = 7'b0110000;
            4'b0100: DIGIT = 7'b0011001;
            4'b0101: DIGIT = 7'b0010010;
            4'b0110: DIGIT = 7'b0000010;
            4'b0111: DIGIT = 7'b1111000;
            4'b1000: DIGIT = 7'b0000000;
            4'b1001: DIGIT = 7'b0011000;
            4'b1010: DIGIT = 7'b0001000;
            4'b1011: DIGIT = 7'b0000011;
            4'b1100: DIGIT = 7'b1000110;
            4'b1101: DIGIT = 7'b0100001;
            4'b1110: DIGIT = 7'b0000110;
            4'b1111: DIGIT = 7'b0001110;
            default: DIGIT = 7'bxxxxxxx;
        endcase
        if (cur != 3'b111) cur = cur + 1;
        else cur = 0;
    end
endmodule
