`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/03 16:12:57
// Design Name: 
// Module Name: cache
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

//function called clogb2 that returns an integer which has the
//value of the ceiling of the log base 2.
/*
function integer clogb2 (input integer bit_depth);
begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
    bit_depth = bit_depth>>1;
end
endfunction
*/

module cache #(parameter BLOCK_SIZE=64, SET_CNT=2, LINE_CNT=2) (clk, reset, addr, wen, LW, wdata, DATA_COMPLETE, rdata, display_data);
    input clk, reset, wen, LW;
    input [8:0] addr;
    input [31:0] wdata;
    output reg DATA_COMPLETE;
    output reg [31:0] rdata;
    output [31:0] display_data;
    reg [BLOCK_SIZE-1:0] data[SET_CNT-1:0][LINE_CNT-1:0];
    reg [LINE_CNT-1:0] valid[SET_CNT-1:0];
    reg dirty[SET_CNT-1:0][LINE_CNT-1:0];
    parameter OFFSET = $clog2(BLOCK_SIZE/8);
    parameter SET_LEN = $clog2(SET_CNT);
    reg [8 - SET_LEN - OFFSET:0] tag[SET_CNT-1:0][LINE_CNT-1:0];
    reg [7:0] hit_cnt, miss_cnt;
    assign display_Data = {16'b0, hit_cnt, miss_cnt};
    
    wire SET_ID = addr[OFFSET + SET_LEN - 1 : OFFSET];
    
    parameter HIT_PENALTY = 2;
    parameter MISS_PENALTY = 4;
    
    reg WEN;
    reg [BLOCK_SIZE-1:0] WDATA;
    wire [BLOCK_SIZE-1:0] RDATA;
    reg [8:0] ADDR;    
    Dmem #(BLOCK_SIZE) dmem(clk, reset, ADDR, WEN, WDATA, RDATA);
    
    reg [LINE_CNT-1:0] hiti;
    integer i, j;
    always @(*)
        for (i = 0; i < LINE_CNT; i = i + 1)
            hiti[i] = valid[SET_ID][i] & (tag[SET_ID][i] == addr[8:OFFSET + SET_LEN]);
    wire hit, full;
    assign hit = | hiti;
    assign full = & valid[SET_ID];
    
    integer ran;
    
    reg [3:0] state;
    reg [5:0] cnt;
    parameter start = 0;
    parameter cacheAccess = 1;
    parameter memWrite = 2;
    parameter memRead = 3; 
    assign display_data = {15'b0, hit_cnt, miss_cnt};
    initial
    begin
        state <= start;
        hit_cnt <= 0;
        miss_cnt <= 0;
    end
    always @(negedge clk or posedge LW)
      if (!LW) begin DATA_COMPLETE <= 1; state <= start; cnt <= 0; end
      else
        case (state)
          start: begin DATA_COMPLETE <= 0; state <= cacheAccess; cnt <= 0; end
          cacheAccess: if (cnt != HIT_PENALTY) cnt <= cnt + 1;
                        else
                        begin
                            if (hit) begin DATA_COMPLETE <= 1; state <= start; hit_cnt <= hit_cnt + 1; end
                            else if (full)
                                    begin
                                        miss_cnt <= miss_cnt + 1;
                                        ran = {$random} % LINE_CNT;
                                        if (dirty[SET_ID][ran]) state <= memWrite;
                                        else state <= memRead;
                                    end 
                             else 
                                begin 
                                    miss_cnt <= miss_cnt + 1;
                                    for (i = 0; i < LINE_CNT; i = i + 1)
                                      if (!valid[SET_ID][i]) ran = i;
                                    state <= memRead;
                                end
                             cnt <= 0;
                         end
          memWrite: if (cnt == 0)
                        begin
                            ADDR[8:OFFSET] = {tag[SET_ID][ran], SET_ID};
                            ADDR[OFFSET-1:0] = 0;
                            WEN = 1;
                            WDATA = data[SET_ID][ran];
                            cnt <= cnt + 1;
                        end
                    else if (cnt != MISS_PENALTY) cnt <= cnt + 1;
                    else begin state <= memRead; cnt <= 0; end
          memRead: if (cnt == 0)
                        begin
                            ADDR[8:OFFSET] = addr[8:OFFSET];
                            ADDR[OFFSET-1:0] = 0;
                            WEN = 0;
                            WDATA = 0;
                            cnt <= cnt + 1;
                        end
                   else if (cnt != MISS_PENALTY) cnt <= cnt + 1;
                   else
                     begin
                        DATA_COMPLETE <= 1;
                        state <= start;
                        cnt <= 0;
                     end
        endcase
    always @(*)
        if (reset)
           begin
             for (i = 0; i < SET_CNT; i = i + 1)
               for (j = 0; j < LINE_CNT; j = j + 1) 
               begin
                 data[i][j] = 0;
                 valid[i][j] = 0;
                 tag[i][j] = 0;
                 dirty[i][j] = 0;
                end
             rdata <= 0;
           end
        else
        begin
        /*
        for (i = 0; i < SET_CNT; i = i + 1)
          for (j = 0; j < LINE_CNT; j = j + 1) 
          begin
            data[i][j] = data[i][j];
            valid[i][j] = valid[i][j];
            tag[i][j] = tag[i][j];
            dirty[i][j] = dirty[i][j];
          end
        rdata = rdata;
        */
        case (state)
        cacheAccess: if (cnt == HIT_PENALTY && hit)
                        begin
                            if (wen)
                              for (i = 0; i < LINE_CNT; i = i + 1)
                              begin
                                if (hiti[i])
                                begin
                                  dirty[SET_ID][i] = 1;
                                  data[SET_ID][i][addr[OFFSET-1]*32 +: 32] = wdata;
                                end
                              end
                            else
                              for (i = 0; i < LINE_CNT; i = i + 1)
                                if (hiti[i]) rdata = data[SET_ID][i][addr[OFFSET-1]*32 +: 32];
                        end
        memRead: if (cnt == MISS_PENALTY) 
                 begin
                   data[SET_ID][ran] = RDATA;
                   valid[SET_ID][ran] = 1;
                   dirty[SET_ID][ran] = 0;
                   tag[SET_ID][ran] = addr[8:OFFSET + SET_LEN];
                   if (wen) begin data[SET_ID][ran][addr[OFFSET-1]*32 +: 32] = wdata; dirty[SET_ID][ran] = 1; end
                   rdata = data[SET_ID][ran][addr[OFFSET-1]*32 +: 32];
                 end
        default: begin end
        endcase
        end
        
endmodule
