`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/11 08:41:15
// Design Name: 
// Module Name: mem
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

module Imem(a, instr);
    input [7:0] a;
    output [31:0] instr;  
    reg [7:0] RAM[255:0]; 
    initial
    begin
{RAM[3], RAM[2], RAM[1], RAM[0]} <= 32'h20100001;
    {RAM[7], RAM[6], RAM[5], RAM[4]} <= 32'h20110000;
    {RAM[11], RAM[10], RAM[9], RAM[8]} <= 32'h20080080;
    {RAM[15], RAM[14], RAM[13], RAM[12]} <= 32'h11100003;
    {RAM[19], RAM[18], RAM[17], RAM[16]} <= 32'h02108020;
    {RAM[23], RAM[22], RAM[21], RAM[20]} <= 32'h22310001;
    {RAM[27], RAM[26], RAM[25], RAM[24]} <= 32'h08000003;

    end
    assign instr = {RAM[a+3], RAM[a+2], RAM[a+1], RAM[a]};
endmodule

module Dmem(clk, reset, addr, wen, wdata, rdata);
    input clk, wen, reset;
    input [7:0] addr;
    input [31:0] wdata;
    output [31:0] rdata;
    reg [7:0] j;
    reg [7:0] RAM[255:0];
    initial
    begin
        for (j = 0; j < 32; j = j + 1) 
            RAM[j] <= 0;
    end
    always @(posedge clk)
      if (reset)
      begin
        for (j = 0; j < 32; j = j + 1) 
            RAM[j] <= 0;
      end
      else if (wen) {RAM[addr+3], RAM[addr+2], RAM[addr+1], RAM[addr]} <= wdata;
      else {RAM[addr+3], RAM[addr+2], RAM[addr+1], RAM[addr]} <= {RAM[addr+3], RAM[addr+2], RAM[addr+1], RAM[addr]};
    assign rdata = {RAM[addr+3], RAM[addr+2], RAM[addr+1], RAM[addr]};
endmodule

module RegFile(clk, reset, addr1, addr2, addr3, wdata, wen, rdata1, rdata2, disaddr, dis);
    input [4:0] addr1, addr2, addr3, disaddr;
    input [31:0] wdata;
    input clk, wen, reset;
    output [31:0] rdata1, rdata2;
    output [15:0] dis;
    reg [31:0] rf[31:0];  
    reg [6:0] j;
    initial
    begin
        for (j = 0; j < 32; j = j + 1) 
            rf[j] <= 0;
    end
    always @(negedge clk)
      if (reset)
      begin
        for (j = 0; j < 32; j = j + 1) 
            rf[j] <= 0;
      end
      else if (wen) rf[addr3] <= wdata;
      else rf[addr3] <= rf[addr3];
    assign rdata1 = (addr1 != 0) ? rf[addr1] : 0;
    assign rdata2 = (addr2 != 0) ? rf[addr2] : 0;
    assign dis = (disaddr != 0) ? rf[disaddr] : 0;
endmodule

