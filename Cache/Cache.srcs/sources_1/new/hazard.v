`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/11 10:26:55
// Design Name: 
// Module Name: hazard
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


module hazard(RsD, RtD, RsE, RtE, WriteRegE, WriteRegM, WriteRegW, RegWriteE, RegWriteM, RegWriteW, MemtoRegE, MemtoRegM, BranchD, BNED, DATA_COMPLETE, ForwardaD, ForwardbD, ForwardaE, ForwardbE, stallF, stallD, flushE, stallE, stallM, stallW);
    input [4:0] RsD, RtD, RsE, RtE;
    input [4:0] WriteRegE, WriteRegM, WriteRegW;
    input RegWriteE, RegWriteM, RegWriteW;
    input MemtoRegE, MemtoRegM, BranchD, BNED, DATA_COMPLETE;
    output ForwardaD, ForwardbD;
    output reg [1:0] ForwardaE, ForwardbE;
    output stallF, stallD, flushE, stallE, stallM, stallW;
    
    wire lwstallD, branchstallD;
    
    assign ForwardaD = (RsD != 0 & RsD == WriteRegM & RegWriteM);
    assign ForwardbD = (RtD != 0 & RtD == WriteRegM & RegWriteM);
    
    always @(*)
      begin
        ForwardaE = 2'b00; ForwardbE = 2'b00;
        if (RsE != 0)
          if (RsE == WriteRegM & RegWriteM) ForwardaE = 2'b10;
          else if (RsE == WriteRegW & RegWriteW) ForwardaE = 2'b01;
        if (RtE != 0)
          if (RtE == WriteRegM & RegWriteM) ForwardbE = 2'b10;
          else if (RtE == WriteRegW & RegWriteW) ForwardbE = 2'b01;
      end
      
    assign lwstallD = MemtoRegE & (RtE == RsD | RtE == RtD);
    assign branchstallD = (BNED | BranchD) & 
                    (RegWriteE & (WriteRegE == RsD | WriteRegE == RtD) |
                     MemtoRegM & (WriteRegM == RsD | WriteRegM == RtD));
    assign stallD = lwstallD | branchstallD | (~DATA_COMPLETE);
    assign stallF = stallD;
    assign flushE = stallD;
    assign stallE = ~DATA_COMPLETE;
    assign stallM = ~DATA_COMPLETE;
    assign stallW = ~DATA_COMPLETE;
endmodule
