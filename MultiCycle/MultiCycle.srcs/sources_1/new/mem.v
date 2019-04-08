`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/07 23:27:50
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


module Mem(clk, Reset, wen, addr, wdata, rdata);
    input clk, Reset, wen;
    input [7:0] addr;
    input [31:0] wdata;
    output [31:0] rdata;
    reg [7:0] j;
    reg [7:0] RAM[255:0];
    //RAM´Ó0~99´æinstr£¬100~255´ædata
    initial
    begin
{RAM[3], RAM[2], RAM[1], RAM[0]} <= 32'h2010000c;
    {RAM[7], RAM[6], RAM[5], RAM[4]} <= 32'h3212fff8;
    {RAM[11], RAM[10], RAM[9], RAM[8]} <= 32'h3633000a;
    {RAM[15], RAM[14], RAM[13], RAM[12]} <= 32'h2a540005;
    {RAM[19], RAM[18], RAM[17], RAM[16]} <= 32'h00000000;
    {RAM[23], RAM[22], RAM[21], RAM[20]} <= 32'h02114020;
    {RAM[27], RAM[26], RAM[25], RAM[24]} <= 32'h02534022;
    {RAM[31], RAM[30], RAM[29], RAM[28]} <= 32'h02714024;
    {RAM[35], RAM[34], RAM[33], RAM[32]} <= 32'h02324025;
    {RAM[39], RAM[38], RAM[37], RAM[36]} <= 32'h0212402a;
    {RAM[43], RAM[42], RAM[41], RAM[40]} <= 32'hac100064;
    {RAM[47], RAM[46], RAM[45], RAM[44]} <= 32'h8c080064;

        for (j = 100; j < 128; j = j + 1) 
            RAM[j] <= 0;
    end
    always @(posedge clk)
      if (Reset)
      begin
        for (j = 100; j < 128; j = j + 1) 
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
    always @(posedge clk)
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
