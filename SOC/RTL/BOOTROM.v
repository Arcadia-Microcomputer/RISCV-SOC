`timescale 1ns / 1ps

module BOOTROM #(
    parameter ADDR_SEL_BITS = 6,
    parameter DEPTH = 32
    )(
    input i_Clk,

    //Avalon R slave
    input i_AV0_SlaveSel,
    input [29-ADDR_SEL_BITS:0]i_AV0_RegAddr,
    input i_AV0_Read,
    output reg [31:0] o_AV0_ReadData,
    output o_AV0_WaitRequest,

    //Avalon R slave
    input i_AV1_SlaveSel,
    input [29-ADDR_SEL_BITS:0]i_AV1_RegAddr,
    input i_AV1_Read,
    output reg [31:0] o_AV1_ReadData,
    output o_AV1_WaitRequest
    );

    initial begin
        o_AV1_ReadData <= 0;
        o_AV1_ReadData <= 0;
    end
    assign o_AV0_WaitRequest = 0;
    assign o_AV1_WaitRequest = 0;

    //The ROM block
    reg [31:0]Ram[DEPTH - 1:0];

    //Initalize the ROM
    integer i;
    integer numRamUsed;
    initial begin
Ram[0] = 32'hff010113;
Ram[1] = 32'h00112623;
Ram[2] = 32'hc0400117;
Ram[3] = 32'h1f810113;
Ram[4] = 32'hffc00737;
Ram[5] = 32'hc00007b7;
Ram[6] = 32'h57870613;
Ram[7] = 32'h00078693;
Ram[8] = 32'h00d61c63;
Ram[9] = 32'hc00007b7;
Ram[10] = 32'hc0000737;
Ram[11] = 32'h00078793;
Ram[12] = 32'h00070713;
Ram[13] = 32'h02c0006f;
Ram[14] = 32'hc00006b7;
Ram[15] = 32'h00078793;
Ram[16] = 32'h57870713;
Ram[17] = 32'h00068693;
Ram[18] = 32'hfcd7fee3;
Ram[19] = 32'h00470713;
Ram[20] = 32'hffc72603;
Ram[21] = 32'h00478793;
Ram[22] = 32'hfec7ae23;
Ram[23] = 32'hfedff06f;
Ram[24] = 32'h00e7f863;
Ram[25] = 32'h00478793;
Ram[26] = 32'hfe07ae23;
Ram[27] = 32'hff5ff06f;
Ram[28] = 32'h008000ef;
Ram[29] = 32'h0000006f;
Ram[30] = 32'hfc010113;
Ram[31] = 32'h02812c23;
Ram[32] = 32'h02912a23;
Ram[33] = 32'h03212823;
Ram[34] = 32'h03312623;
Ram[35] = 32'h03412423;
Ram[36] = 32'h03512223;
Ram[37] = 32'h02112e23;
Ram[38] = 32'h03612023;
Ram[39] = 32'h01712e23;
Ram[40] = 32'h01812c23;
Ram[41] = 32'h01912a23;
Ram[42] = 32'h01a12823;
Ram[43] = 32'hffc047b7;
Ram[44] = 32'h04b00713;
Ram[45] = 32'h00e79023;
Ram[46] = 32'h0027d703;
Ram[47] = 32'hffc026b7;
Ram[48] = 32'h0e0009b7;
Ram[49] = 32'h02076713;
Ram[50] = 32'h00e79123;
Ram[51] = 32'h00f6c783;
Ram[52] = 32'hffc004b7;
Ram[53] = 32'h00002a37;
Ram[54] = 32'h0017e793;
Ram[55] = 32'h01000437;
Ram[56] = 32'h00f687a3;
Ram[57] = 32'h56048493;
Ram[58] = 32'h00100913;
Ram[59] = 32'hd4ca0a13;
Ram[60] = 32'hf0040413;
Ram[61] = 32'h00298a93;
Ram[62] = 32'hffc04737;
Ram[63] = 32'h00275783;
Ram[64] = 32'h0107f793;
Ram[65] = 32'hfe078ce3;
Ram[66] = 32'h00474b03;
Ram[67] = 32'hffc027b7;
Ram[68] = 32'h000786a3;
Ram[69] = 32'h0ffb7b13;
Ram[70] = 32'h00078723;
Ram[71] = 32'h00500713;
Ram[72] = 32'h37676663;
Ram[73] = 32'h002b1793;
Ram[74] = 32'h00f487b3;
Ram[75] = 32'h0007a783;
Ram[76] = 32'h00078067;
Ram[77] = 32'hffc027b7;
Ram[78] = 32'h00500713;
Ram[79] = 32'h00e78623;
Ram[80] = 32'h00300613;
Ram[81] = 32'h00010593;
Ram[82] = 32'hffc04537;
Ram[83] = 32'h00011023;
Ram[84] = 32'h00010123;
Ram[85] = 32'h3bc000ef;
Ram[86] = 32'hffc09737;
Ram[87] = 32'h00214783;
Ram[88] = 32'h00114603;
Ram[89] = 32'h00014583;
Ram[90] = 32'h01472223;
Ram[91] = 32'h00072683;
Ram[92] = 32'h01079793;
Ram[93] = 32'h00861613;
Ram[94] = 32'h00c7e7b3;
Ram[95] = 32'h0016e693;
Ram[96] = 32'h00b7e7b3;
Ram[97] = 32'h00d72023;
Ram[98] = 32'h00012423;
Ram[99] = 32'h0027d793;
Ram[100] = 32'h04078a63;
Ram[101] = 32'h013787b3;
Ram[102] = 32'h00279693;
Ram[103] = 32'h00000513;
Ram[104] = 32'h380007b7;
Ram[105] = 32'h00000593;
Ram[106] = 32'hffc09637;
Ram[107] = 32'h0007a703;
Ram[108] = 32'h00e12223;
Ram[109] = 32'h00062703;
Ram[110] = 32'h00277713;
Ram[111] = 32'h00070c63;
Ram[112] = 32'h00062703;
Ram[113] = 32'h00158593;
Ram[114] = 32'h00100513;
Ram[115] = 32'h00276713;
Ram[116] = 32'h00e62023;
Ram[117] = 32'h00478793;
Ram[118] = 32'hfcf69ae3;
Ram[119] = 32'h00050463;
Ram[120] = 32'h00b12423;
Ram[121] = 32'h00400613;
Ram[122] = 32'h00810593;
Ram[123] = 32'hffc04537;
Ram[124] = 32'h348000ef;
Ram[125] = 32'hf05ff06f;
Ram[126] = 32'hffc027b7;
Ram[127] = 32'h00400713;
Ram[128] = 32'h00e78623;
Ram[129] = 32'h00300613;
Ram[130] = 32'h00810593;
Ram[131] = 32'hffc04537;
Ram[132] = 32'h00011423;
Ram[133] = 32'h00010523;
Ram[134] = 32'h2f8000ef;
Ram[135] = 32'h00a14783;
Ram[136] = 32'h00914703;
Ram[137] = 32'h00814683;
Ram[138] = 32'h01079793;
Ram[139] = 32'h00871713;
Ram[140] = 32'h00e7e7b3;
Ram[141] = 32'h00d7e7b3;
Ram[142] = 32'h0027d793;
Ram[143] = 32'hea078ee3;
Ram[144] = 32'h013787b3;
Ram[145] = 32'h00279513;
Ram[146] = 32'h380005b7;
Ram[147] = 32'hffc08737;
Ram[148] = 32'h0005a683;
Ram[149] = 32'h00869613;
Ram[150] = 32'h0106d693;
Ram[151] = 32'h00867633;
Ram[152] = 32'h00869693;
Ram[153] = 32'h00072783;
Ram[154] = 32'h0017f793;
Ram[155] = 32'hfe079ce3;
Ram[156] = 32'h00c72223;
Ram[157] = 32'h00c72423;
Ram[158] = 32'h00072783;
Ram[159] = 32'h0017f793;
Ram[160] = 32'hfe079ce3;
Ram[161] = 32'h00d72223;
Ram[162] = 32'h00d72423;
Ram[163] = 32'h00458593;
Ram[164] = 32'hfca590e3;
Ram[165] = 32'he65ff06f;
Ram[166] = 32'hffc027b7;
Ram[167] = 32'h00300713;
Ram[168] = 32'h00e78623;
Ram[169] = 32'hffc01537;
Ram[170] = 32'h218000ef;
Ram[171] = 32'h00000593;
Ram[172] = 32'hffc01537;
Ram[173] = 32'h1e8000ef;
Ram[174] = 32'h00400593;
Ram[175] = 32'hffc01537;
Ram[176] = 32'h1dc000ef;
Ram[177] = 32'he35ff06f;
Ram[178] = 32'h00200713;
Ram[179] = 32'hffc027b7;
Ram[180] = 32'h00e78623;
Ram[181] = 32'h00400613;
Ram[182] = 32'h00810593;
Ram[183] = 32'hffc04537;
Ram[184] = 32'h00012423;
Ram[185] = 32'h22c000ef;
Ram[186] = 32'h00b14b03;
Ram[187] = 32'h00000613;
Ram[188] = 32'hffc046b7;
Ram[189] = 32'hffc01737;
Ram[190] = 32'h020b0a63;
Ram[191] = 32'h0026d783;
Ram[192] = 32'h0107f793;
Ram[193] = 32'hfe078ce3;
Ram[194] = 32'h0046c583;
Ram[195] = 32'h0ff5f593;
Ram[196] = 32'h00174783;
Ram[197] = 32'h0047f793;
Ram[198] = 32'hfe079ce3;
Ram[199] = 32'h00160613;
Ram[200] = 32'h00b70423;
Ram[201] = 32'h0ff67613;
Ram[202] = 32'hfccb1ae3;
Ram[203] = 32'hffc01537;
Ram[204] = 32'h190000ef;
Ram[205] = 32'h00000593;
Ram[206] = 32'hffc01537;
Ram[207] = 32'h160000ef;
Ram[208] = 32'h00a14783;
Ram[209] = 32'h00914703;
Ram[210] = 32'h00814683;
Ram[211] = 32'h01079793;
Ram[212] = 32'h00871713;
Ram[213] = 32'h00e7e7b3;
Ram[214] = 32'h00d7e7b3;
Ram[215] = 32'hffc01737;
Ram[216] = 32'h00f72223;
Ram[217] = 32'h01670123;
Ram[218] = 32'h00500593;
Ram[219] = 32'hffc01537;
Ram[220] = 32'h12c000ef;
Ram[221] = 32'hd85ff06f;
Ram[222] = 32'hffc027b7;
Ram[223] = 32'h01278623;
Ram[224] = 32'hffc01537;
Ram[225] = 32'h13c000ef;
Ram[226] = 32'h00600613;
Ram[227] = 32'h00810593;
Ram[228] = 32'hffc04537;
Ram[229] = 32'h00012423;
Ram[230] = 32'h00011623;
Ram[231] = 32'h174000ef;
Ram[232] = 32'h00a14783;
Ram[233] = 32'h00914703;
Ram[234] = 32'h00814683;
Ram[235] = 32'h01079793;
Ram[236] = 32'h00871713;
Ram[237] = 32'h00e7e7b3;
Ram[238] = 32'h00d7e7b3;
Ram[239] = 32'h00d14b83;
Ram[240] = 32'h00c14603;
Ram[241] = 32'h00279713;
Ram[242] = 32'h38000c37;
Ram[243] = 32'h00ec06b3;
Ram[244] = 32'h00b14583;
Ram[245] = 32'h0006a683;
Ram[246] = 32'h00861613;
Ram[247] = 32'h010b9b93;
Ram[248] = 32'h00cbebb3;
Ram[249] = 32'h00bbebb3;
Ram[250] = 32'h00d12023;
Ram[251] = 32'h00400613;
Ram[252] = 32'h0b765263;
Ram[253] = 32'hffbb8c93;
Ram[254] = 32'h002cdc93;
Ram[255] = 32'h01578d33;
Ram[256] = 32'h00470713;
Ram[257] = 32'h019d0d33;
Ram[258] = 32'h00ec0c33;
Ram[259] = 32'h002d1d13;
Ram[260] = 32'h00400613;
Ram[261] = 32'h00010593;
Ram[262] = 32'hffc04537;
Ram[263] = 32'h11c000ef;
Ram[264] = 32'h000c2683;
Ram[265] = 32'h004c0c13;
Ram[266] = 32'h00d12023;
Ram[267] = 32'hff8d12e3;
Ram[268] = 32'hffcb8b93;
Ram[269] = 32'h002c9c93;
Ram[270] = 32'h419b8bb3;
Ram[271] = 32'hffc04737;
Ram[272] = 32'h00275783;
Ram[273] = 32'h0087f793;
Ram[274] = 32'hfe079ce3;
Ram[275] = 32'h003b1793;
Ram[276] = 32'h00f6d7b3;
Ram[277] = 32'h0ff7f793;
Ram[278] = 32'h001b0b13;
Ram[279] = 32'h00f70223;
Ram[280] = 32'h0ffb7b13;
Ram[281] = 32'hfd7b6ee3;
Ram[282] = 32'hc91ff06f;
Ram[283] = 32'hffc01537;
Ram[284] = 32'h050000ef;
Ram[285] = 32'hffc04737;
Ram[286] = 32'h00275783;
Ram[287] = 32'h0087f793;
Ram[288] = 32'hfe079ce3;
Ram[289] = 32'h01270223;
Ram[290] = 32'hc71ff06f;
Ram[291] = 32'h00078623;
Ram[292] = 32'hc69ff06f;
Ram[293] = 32'hc60b82e3;
Ram[294] = 32'hfa5ff06f;
Ram[295] = 32'h00154783;
Ram[296] = 32'h0027f793;
Ram[297] = 32'hfe079ce3;
Ram[298] = 32'h0ff5f593;
Ram[299] = 32'h00b50023;
Ram[300] = 32'h00154783;
Ram[301] = 32'h0017e793;
Ram[302] = 32'h00f500a3;
Ram[303] = 32'h00008067;
Ram[304] = 32'h00154783;
Ram[305] = 32'h0027f793;
Ram[306] = 32'hfe079ce3;
Ram[307] = 32'h00100793;
Ram[308] = 32'h00f52223;
Ram[309] = 32'h00700713;
Ram[310] = 32'h00154783;
Ram[311] = 32'h0027f793;
Ram[312] = 32'hfe079ce3;
Ram[313] = 32'h00e50023;
Ram[314] = 32'h00154783;
Ram[315] = 32'h0017e793;
Ram[316] = 32'h00f500a3;
Ram[317] = 32'h00154783;
Ram[318] = 32'h0027f793;
Ram[319] = 32'hfe079ce3;
Ram[320] = 32'h00854783;
Ram[321] = 32'h0017f793;
Ram[322] = 32'hfc0798e3;
Ram[323] = 32'h00008067;
Ram[324] = 32'h02060263;
Ram[325] = 32'h00c58733;
Ram[326] = 32'h00255783;
Ram[327] = 32'h0107f793;
Ram[328] = 32'hfe078ce3;
Ram[329] = 32'h00454783;
Ram[330] = 32'h00158593;
Ram[331] = 32'hfef58fa3;
Ram[332] = 32'hfee594e3;
Ram[333] = 32'h00008067;
Ram[334] = 32'h02060263;
Ram[335] = 32'h00c58733;
Ram[336] = 32'h00255783;
Ram[337] = 32'h0087f793;
Ram[338] = 32'hfe079ce3;
Ram[339] = 32'h0005c783;
Ram[340] = 32'h00158593;
Ram[341] = 32'h00f50223;
Ram[342] = 32'hfee594e3;
Ram[343] = 32'h00008067;
Ram[344] = 32'hffc00378;
Ram[345] = 32'hffc002c8;
Ram[346] = 32'hffc00298;
Ram[347] = 32'hffc001f8;
Ram[348] = 32'hffc00134;
Ram[349] = 32'hffc0046c;
numRamUsed = 350;
        for(i = numRamUsed; i < DEPTH; i = i + 1)begin
            Ram[i] = 0;
        end
    end

    always @(posedge i_Clk) begin
        o_AV0_ReadData <= 0;
        o_AV1_ReadData <= 0;

        if(i_AV0_SlaveSel)begin
            if(i_AV0_Read)begin
                o_AV0_ReadData <= Ram[i_AV0_RegAddr]; 
            end
        end

        if(i_AV1_SlaveSel)begin
            if(i_AV1_Read)begin
                o_AV1_ReadData <= Ram[i_AV1_RegAddr]; 
            end
        end
    end

endmodule