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
{RAM[3], RAM[2], RAM[1], RAM[0]} <= 32'h20020000;
    {RAM[7], RAM[6], RAM[5], RAM[4]} <= 32'h20080000;
    {RAM[11], RAM[10], RAM[9], RAM[8]} <= 32'h20030200;
    {RAM[15], RAM[14], RAM[13], RAM[12]} <= 32'h8c500000;
    {RAM[19], RAM[18], RAM[17], RAM[16]} <= 32'h01104020;
    {RAM[23], RAM[22], RAM[21], RAM[20]} <= 32'h20420020;
    {RAM[27], RAM[26], RAM[25], RAM[24]} <= 32'h1462fffc;
    {RAM[31], RAM[30], RAM[29], RAM[28]} <= 32'h20020004;
    {RAM[35], RAM[34], RAM[33], RAM[32]} <= 32'h20030204;
    {RAM[39], RAM[38], RAM[37], RAM[36]} <= 32'h8c500000;
    {RAM[43], RAM[42], RAM[41], RAM[40]} <= 32'h01104020;
    {RAM[47], RAM[46], RAM[45], RAM[44]} <= 32'h20420020;
    {RAM[51], RAM[50], RAM[49], RAM[48]} <= 32'h1462fffc;
    {RAM[55], RAM[54], RAM[53], RAM[52]} <= 32'h20020008;
    {RAM[59], RAM[58], RAM[57], RAM[56]} <= 32'h20030208;
    {RAM[63], RAM[62], RAM[61], RAM[60]} <= 32'h8c500000;
    {RAM[67], RAM[66], RAM[65], RAM[64]} <= 32'h01104020;
    {RAM[71], RAM[70], RAM[69], RAM[68]} <= 32'h20420020;
    {RAM[75], RAM[74], RAM[73], RAM[72]} <= 32'h1462fffc;
    {RAM[79], RAM[78], RAM[77], RAM[76]} <= 32'h2002000c;
    {RAM[83], RAM[82], RAM[81], RAM[80]} <= 32'h2003020c;
    {RAM[87], RAM[86], RAM[85], RAM[84]} <= 32'h8c500000;
    {RAM[91], RAM[90], RAM[89], RAM[88]} <= 32'h01104020;
    {RAM[95], RAM[94], RAM[93], RAM[92]} <= 32'h20420020;
    {RAM[99], RAM[98], RAM[97], RAM[96]} <= 32'h1462fffc;
    {RAM[103], RAM[102], RAM[101], RAM[100]} <= 32'h20020010;
    {RAM[107], RAM[106], RAM[105], RAM[104]} <= 32'h20030210;
    {RAM[111], RAM[110], RAM[109], RAM[108]} <= 32'h8c500000;
    {RAM[115], RAM[114], RAM[113], RAM[112]} <= 32'h01104020;
    {RAM[119], RAM[118], RAM[117], RAM[116]} <= 32'h20420020;
    {RAM[123], RAM[122], RAM[121], RAM[120]} <= 32'h1462fffc;
    {RAM[127], RAM[126], RAM[125], RAM[124]} <= 32'h20020014;
    {RAM[131], RAM[130], RAM[129], RAM[128]} <= 32'h20030214;
    {RAM[135], RAM[134], RAM[133], RAM[132]} <= 32'h8c500000;
    {RAM[139], RAM[138], RAM[137], RAM[136]} <= 32'h01104020;
    {RAM[143], RAM[142], RAM[141], RAM[140]} <= 32'h20420020;
    {RAM[147], RAM[146], RAM[145], RAM[144]} <= 32'h1462fffc;
    {RAM[151], RAM[150], RAM[149], RAM[148]} <= 32'h20020018;
    {RAM[155], RAM[154], RAM[153], RAM[152]} <= 32'h20030218;
    {RAM[159], RAM[158], RAM[157], RAM[156]} <= 32'h8c500000;
    {RAM[163], RAM[162], RAM[161], RAM[160]} <= 32'h01104020;
    {RAM[167], RAM[166], RAM[165], RAM[164]} <= 32'h20420020;
    {RAM[171], RAM[170], RAM[169], RAM[168]} <= 32'h1462fffc;
    {RAM[175], RAM[174], RAM[173], RAM[172]} <= 32'h2002001c;
    {RAM[179], RAM[178], RAM[177], RAM[176]} <= 32'h2003021c;
    {RAM[183], RAM[182], RAM[181], RAM[180]} <= 32'h8c500000;
    {RAM[187], RAM[186], RAM[185], RAM[184]} <= 32'h01104020;
    {RAM[191], RAM[190], RAM[189], RAM[188]} <= 32'h20420020;
    {RAM[195], RAM[194], RAM[193], RAM[192]} <= 32'h1462fffc;
    {RAM[199], RAM[198], RAM[197], RAM[196]} <= 32'h00000000;
    {RAM[203], RAM[202], RAM[201], RAM[200]} <= 32'h00000000;

    end
    assign instr = {RAM[a+3], RAM[a+2], RAM[a+1], RAM[a]};
endmodule

module Dmem #(parameter BLOCK_SIZE=32) (clk, reset, addr, wen, wdata, rdata);
    input clk, wen, reset;
    input [8:0] addr;
    input [BLOCK_SIZE-1:0] wdata;
    output reg [BLOCK_SIZE-1:0] rdata;
    reg [7:0] j;
    reg [7:0] RAM[511:0];
    initial
    begin
        {RAM[3], RAM[2], RAM[1], RAM[0]}<=32'h5;
    {RAM[7], RAM[6], RAM[5], RAM[4]}<=32'h0;
    {RAM[11], RAM[10], RAM[9], RAM[8]}<=32'h9;
    {RAM[15], RAM[14], RAM[13], RAM[12]}<=32'h0;
    {RAM[19], RAM[18], RAM[17], RAM[16]}<=32'h9;
    {RAM[23], RAM[22], RAM[21], RAM[20]}<=32'h0;
    {RAM[27], RAM[26], RAM[25], RAM[24]}<=32'h5;
    {RAM[31], RAM[30], RAM[29], RAM[28]}<=32'h7;
    {RAM[35], RAM[34], RAM[33], RAM[32]}<=32'h2;
    {RAM[39], RAM[38], RAM[37], RAM[36]}<=32'h5;
    {RAM[43], RAM[42], RAM[41], RAM[40]}<=32'h7;
    {RAM[47], RAM[46], RAM[45], RAM[44]}<=32'h0;
    {RAM[51], RAM[50], RAM[49], RAM[48]}<=32'h5;
    {RAM[55], RAM[54], RAM[53], RAM[52]}<=32'h0;
    {RAM[59], RAM[58], RAM[57], RAM[56]}<=32'h1;
    {RAM[63], RAM[62], RAM[61], RAM[60]}<=32'h3;
    {RAM[67], RAM[66], RAM[65], RAM[64]}<=32'h0;
    {RAM[71], RAM[70], RAM[69], RAM[68]}<=32'h9;
    {RAM[75], RAM[74], RAM[73], RAM[72]}<=32'h7;
    {RAM[79], RAM[78], RAM[77], RAM[76]}<=32'h9;
    {RAM[83], RAM[82], RAM[81], RAM[80]}<=32'h4;
    {RAM[87], RAM[86], RAM[85], RAM[84]}<=32'h5;
    {RAM[91], RAM[90], RAM[89], RAM[88]}<=32'h0;
    {RAM[95], RAM[94], RAM[93], RAM[92]}<=32'h8;
    {RAM[99], RAM[98], RAM[97], RAM[96]}<=32'h1;
    {RAM[103], RAM[102], RAM[101], RAM[100]}<=32'h6;
    {RAM[107], RAM[106], RAM[105], RAM[104]}<=32'h7;
    {RAM[111], RAM[110], RAM[109], RAM[108]}<=32'h5;
    {RAM[115], RAM[114], RAM[113], RAM[112]}<=32'h4;
    {RAM[119], RAM[118], RAM[117], RAM[116]}<=32'h3;
    {RAM[123], RAM[122], RAM[121], RAM[120]}<=32'h8;
    {RAM[127], RAM[126], RAM[125], RAM[124]}<=32'h9;
    {RAM[131], RAM[130], RAM[129], RAM[128]}<=32'h9;
    {RAM[135], RAM[134], RAM[133], RAM[132]}<=32'h0;
    {RAM[139], RAM[138], RAM[137], RAM[136]}<=32'h0;
    {RAM[143], RAM[142], RAM[141], RAM[140]}<=32'h2;
    {RAM[147], RAM[146], RAM[145], RAM[144]}<=32'h8;
    {RAM[151], RAM[150], RAM[149], RAM[148]}<=32'h8;
    {RAM[155], RAM[154], RAM[153], RAM[152]}<=32'h5;
    {RAM[159], RAM[158], RAM[157], RAM[156]}<=32'h3;
    {RAM[163], RAM[162], RAM[161], RAM[160]}<=32'h9;
    {RAM[167], RAM[166], RAM[165], RAM[164]}<=32'h7;
    {RAM[171], RAM[170], RAM[169], RAM[168]}<=32'h6;
    {RAM[175], RAM[174], RAM[173], RAM[172]}<=32'h1;
    {RAM[179], RAM[178], RAM[177], RAM[176]}<=32'h0;
    {RAM[183], RAM[182], RAM[181], RAM[180]}<=32'h4;
    {RAM[187], RAM[186], RAM[185], RAM[184]}<=32'h4;
    {RAM[191], RAM[190], RAM[189], RAM[188]}<=32'h6;
    {RAM[195], RAM[194], RAM[193], RAM[192]}<=32'h9;
    {RAM[199], RAM[198], RAM[197], RAM[196]}<=32'h5;
    {RAM[203], RAM[202], RAM[201], RAM[200]}<=32'h0;
    {RAM[207], RAM[206], RAM[205], RAM[204]}<=32'h0;
    {RAM[211], RAM[210], RAM[209], RAM[208]}<=32'h5;
    {RAM[215], RAM[214], RAM[213], RAM[212]}<=32'h2;
    {RAM[219], RAM[218], RAM[217], RAM[216]}<=32'h9;
    {RAM[223], RAM[222], RAM[221], RAM[220]}<=32'h2;
    {RAM[227], RAM[226], RAM[225], RAM[224]}<=32'h8;
    {RAM[231], RAM[230], RAM[229], RAM[228]}<=32'h5;
    {RAM[235], RAM[234], RAM[233], RAM[232]}<=32'h2;
    {RAM[239], RAM[238], RAM[237], RAM[236]}<=32'h7;
    {RAM[243], RAM[242], RAM[241], RAM[240]}<=32'h3;
    {RAM[247], RAM[246], RAM[245], RAM[244]}<=32'h0;
    {RAM[251], RAM[250], RAM[249], RAM[248]}<=32'h7;
    {RAM[255], RAM[254], RAM[253], RAM[252]}<=32'h2;
    {RAM[259], RAM[258], RAM[257], RAM[256]}<=32'h6;
    {RAM[263], RAM[262], RAM[261], RAM[260]}<=32'h2;
    {RAM[267], RAM[266], RAM[265], RAM[264]}<=32'h8;
    {RAM[271], RAM[270], RAM[269], RAM[268]}<=32'h4;
    {RAM[275], RAM[274], RAM[273], RAM[272]}<=32'h2;
    {RAM[279], RAM[278], RAM[277], RAM[276]}<=32'h0;
    {RAM[283], RAM[282], RAM[281], RAM[280]}<=32'h9;
    {RAM[287], RAM[286], RAM[285], RAM[284]}<=32'h1;
    {RAM[291], RAM[290], RAM[289], RAM[288]}<=32'h4;
    {RAM[295], RAM[294], RAM[293], RAM[292]}<=32'h4;
    {RAM[299], RAM[298], RAM[297], RAM[296]}<=32'h8;
    {RAM[303], RAM[302], RAM[301], RAM[300]}<=32'h2;
    {RAM[307], RAM[306], RAM[305], RAM[304]}<=32'h9;
    {RAM[311], RAM[310], RAM[309], RAM[308]}<=32'h3;
    {RAM[315], RAM[314], RAM[313], RAM[312]}<=32'h1;
    {RAM[319], RAM[318], RAM[317], RAM[316]}<=32'h1;
    {RAM[323], RAM[322], RAM[321], RAM[320]}<=32'h3;
    {RAM[327], RAM[326], RAM[325], RAM[324]}<=32'h9;
    {RAM[331], RAM[330], RAM[329], RAM[328]}<=32'h6;
    {RAM[335], RAM[334], RAM[333], RAM[332]}<=32'h2;
    {RAM[339], RAM[338], RAM[337], RAM[336]}<=32'h9;
    {RAM[343], RAM[342], RAM[341], RAM[340]}<=32'h1;
    {RAM[347], RAM[346], RAM[345], RAM[344]}<=32'h6;
    {RAM[351], RAM[350], RAM[349], RAM[348]}<=32'h6;
    {RAM[355], RAM[354], RAM[353], RAM[352]}<=32'h9;
    {RAM[359], RAM[358], RAM[357], RAM[356]}<=32'h6;
    {RAM[363], RAM[362], RAM[361], RAM[360]}<=32'h8;
    {RAM[367], RAM[366], RAM[365], RAM[364]}<=32'h7;
    {RAM[371], RAM[370], RAM[369], RAM[368]}<=32'h1;
    {RAM[375], RAM[374], RAM[373], RAM[372]}<=32'h4;
    {RAM[379], RAM[378], RAM[377], RAM[376]}<=32'h7;
    {RAM[383], RAM[382], RAM[381], RAM[380]}<=32'h1;
    {RAM[387], RAM[386], RAM[385], RAM[384]}<=32'h7;
    {RAM[391], RAM[390], RAM[389], RAM[388]}<=32'h7;
    {RAM[395], RAM[394], RAM[393], RAM[392]}<=32'h1;
    {RAM[399], RAM[398], RAM[397], RAM[396]}<=32'h2;
    {RAM[403], RAM[402], RAM[401], RAM[400]}<=32'h2;
    {RAM[407], RAM[406], RAM[405], RAM[404]}<=32'h7;
    {RAM[411], RAM[410], RAM[409], RAM[408]}<=32'h0;
    {RAM[415], RAM[414], RAM[413], RAM[412]}<=32'h5;
    {RAM[419], RAM[418], RAM[417], RAM[416]}<=32'h2;
    {RAM[423], RAM[422], RAM[421], RAM[420]}<=32'h7;
    {RAM[427], RAM[426], RAM[425], RAM[424]}<=32'h9;
    {RAM[431], RAM[430], RAM[429], RAM[428]}<=32'h0;
    {RAM[435], RAM[434], RAM[433], RAM[432]}<=32'h5;
    {RAM[439], RAM[438], RAM[437], RAM[436]}<=32'h4;
    {RAM[443], RAM[442], RAM[441], RAM[440]}<=32'h7;
    {RAM[447], RAM[446], RAM[445], RAM[444]}<=32'h9;
    {RAM[451], RAM[450], RAM[449], RAM[448]}<=32'h4;
    {RAM[455], RAM[454], RAM[453], RAM[452]}<=32'h6;
    {RAM[459], RAM[458], RAM[457], RAM[456]}<=32'h9;
    {RAM[463], RAM[462], RAM[461], RAM[460]}<=32'h9;
    {RAM[467], RAM[466], RAM[465], RAM[464]}<=32'h4;
    {RAM[471], RAM[470], RAM[469], RAM[468]}<=32'h6;
    {RAM[475], RAM[474], RAM[473], RAM[472]}<=32'h7;
    {RAM[479], RAM[478], RAM[477], RAM[476]}<=32'h1;
    {RAM[483], RAM[482], RAM[481], RAM[480]}<=32'h6;
    {RAM[487], RAM[486], RAM[485], RAM[484]}<=32'h4;
    {RAM[491], RAM[490], RAM[489], RAM[488]}<=32'h2;
    {RAM[495], RAM[494], RAM[493], RAM[492]}<=32'h2;
    {RAM[499], RAM[498], RAM[497], RAM[496]}<=32'h1;
    {RAM[503], RAM[502], RAM[501], RAM[500]}<=32'h3;
    {RAM[507], RAM[506], RAM[505], RAM[504]}<=32'h6;
    {RAM[511], RAM[510], RAM[509], RAM[508]}<=32'h2;

    end
    always @(posedge clk)
      if (reset)
      begin
        /*for (j = 0; j < 32; j = j + 1) 
            RAM[j] <= 0;*/
      end
      else if (wen) 
             for (j = 0; j < BLOCK_SIZE; j = j + 8)
                RAM[addr + j/8] <= wdata[j +: 8];
    always @(*)
        for (j = 0; j < BLOCK_SIZE; j = j + 8)
            rdata[j +: 8] <= RAM[addr + j/8];
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

