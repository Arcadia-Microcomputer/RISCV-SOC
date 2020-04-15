`timescale 1ns / 1ps

module CPU(
    input i_Clk,

    //DBUS
    output [29:0]o_DBusAddr,
    output o_DBusRe,
    output o_DBusWe,
    output [3:0]o_DBusByteEn,
    input [31:0]i_DBusRd,
    output [31:0]i_DBusWd
    );

    //----PCAdd Signals----/
    wire [31:0]w_PCAdd_Sum;

    //----BranchUnit Signals----/
    wire w_TakeBranch;

    //----PC Signals----/
    wire [31:0]w_PC_F;

    //----IRAM Signals----/
    wire [31:0]w_Inst_F;

    //----IF_ID Signals----/
    wire [31:0]w_PC_D;
    wire [31:0]w_IF_ID_Inst_D;

    //----InstSel Signals----/
    wire [31:0]w_Inst_D;
    
    //----Decoder Signals----/
    wire [12:0]w_Control_D;

    //----RegFile Signals----/
    wire [4:0]w_RS1Addr_D = w_Inst_D[19:15];
    wire [4:0]w_RS2Addr_D = w_Inst_D[24:20];
    wire [4:0]w_RDAddr_D  = w_Inst_D[11:7];

    wire [31:0]w_RS1_D;
    wire [31:0]w_RS2_D;

    //----ImmGen Signals----/
    wire [31:0]w_Immediate_D;

    //----ID_IE Signals----/
    wire [12:0]w_Control_E;   
    wire w_AluBSel_E = w_Control_E[0];
    wire [3:0]w_AluOp_E = w_Control_E[4:1];
    wire w_IsBranch_E = w_Control_E[5];
    wire w_WBSrc_E = w_Control_E[11];

    wire [31:0]w_PC_E;

    wire [31:0]w_RS1_E;
    wire [31:0]w_RS2_E;

    wire [31:0]w_Immediate_E;

    wire [4:0]w_RS1Addr_E;
    wire [4:0]w_RS2Addr_E;
    wire [4:0]w_RDAddr_E;
    
    //----ALU Signals----/
    wire [31:0] w_AluResult_E;
    wire w_AluZero_E;

    //----DBusForwardA Signals----/
    wire [31:0]w_DBusWrData_E;

    //----IE_MEM Signals----/
    wire [7:0]w_Control_M;
    wire w_IsBranch_M = w_Control_M[0];
    wire w_DRAM_We_M = w_Control_M[1];
    wire w_DRAM_Re_M = w_Control_M[2];
    wire [2:0]w_func3_M = w_Control_M[5:3];
    wire w_WBSrc_M = w_Control_M[6];
    wire w_RegWrEn_M = w_Control_M[7];

    wire [31:0]w_PC_M;

    wire w_AluZero_M;
    wire [31:0]w_AluResult_M;
    wire [31:0]w_Immediate_M;
    wire [31:0]w_RS2_M;
    wire [4:0]w_RS2Addr_M;
    wire [4:0]w_RDAddr_M;
    wire [31:0]w_DBusWrDataSReg_M;

    //----DBusForwardB Signals----/
    wire [31:0]w_DBusWrData_M;

    //----DBUS Signals----/
    wire [31:0]w_DRAM_Rd_M;

    //----MEM_WB Signals----/
    wire [1:0]w_Control_W;
    wire w_RegWrEn_W = w_Control_W[1];
    wire w_WBSrc_W = w_Control_W[0];

    wire [31:0]w_AluResult_W;
    wire [4:0]w_RDAddr_W;

    //----WBSrc Signals----/
    wire [31:0] w_WBData_W;

    //----ForwardingUnit Signals----/
    wire [1:0]w_AluForwardASrc;
    wire [1:0]w_AluForwardBSrc;
    wire w_DBusForwardASrc;
    wire w_DBusForwardBSrc;

    //----HazardUnit Signals----/
    wire w_PcEn0;
    wire w_IRAMSel;

    wire w_RegEn_D;
    wire w_RegEn_E;
    wire w_RegEn_M;
    wire w_RegEn_W;

    wire w_RegClr_D;
    wire w_RegClr_E;
    wire w_RegClr_M;
    wire w_RegClr_W;

    //Instruction Fetch Stage//
    PCAdd PCAdd0(
        .i_ASrc(w_IsBranch_M),
        .i_A0(32'd4),
        .i_A1(w_Immediate_M),

        .i_BSrc(w_IsBranch_M),
        .i_B0(w_PC_F),
        .i_B1(w_PC_M),

        .o_Sum(w_PCAdd_Sum)
    );

    BranchUnit BranchUnit0(
        .i_IsBranch_M(w_IsBranch_M),
        .i_BranchType_M(w_func3_M),
        .AluZero_M(w_AluZero_M),

        .o_TakeBranch(w_TakeBranch)
    );

    PC PC0 (
        .i_Clk(i_Clk),
        
        .i_En0(w_PcEn0),
        .i_En1(w_TakeBranch),

        .i_NewPc(w_PCAdd_Sum),
        .o_Pc(w_PC_F)
    );

    IRAM #(
        .DEPTH(64)
    )IRAM0(
        .i_Clk(i_Clk),
        .i_Addr(w_PC_F[31:2]),
        .o_RD(w_Inst_F)
    );

    //Instruction Decode Stage//
    StageReg #(
        .WIDTH(64)
    ) IF_ID (
        .i_Clk(i_Clk),

        .i_En(w_RegEn_D),
        .i_Clear(w_RegClr_D),

        .i_In({w_PC_F, w_Inst_F}),
        .o_Out({w_PC_D, w_IF_ID_Inst_D})
    );

    Mux_2_1 InstSel(
        .i_Sel(w_IRAMSel),
        .i_Src0(w_Inst_F),
        .i_Src1(w_IF_ID_Inst_D),

        .o_Data(w_Inst_D)
    );

    Decoder Decoder0(
        .i_Inst(w_Inst_D),

        .o_Control(w_Control_D)
    );

    RegFile RegFile0 (
        .i_Clk(i_Clk),
        
        .i_AddrR1(w_RS1Addr_D),
        .o_RD1(w_RS1_D),

        .i_AddrR2(w_RS2Addr_D),
        .o_RD2(w_RS2_D),

        .i_WE(w_RegWrEn_W),
        .i_WrAddr(w_RDAddr_W),
        .i_WrData(w_WBData_W)
    );

    ImmGen ImmGen0 (
        .i_Inst(w_Inst_D),
        .o_Imm(w_Immediate_D)
    );

    //Execute Stage//
    StageReg #(
        .WIDTH(156)
    ) ID_IE (
        .i_Clk(i_Clk),

        .i_En(w_RegEn_E),
        .i_Clear(w_RegClr_E),

        .i_In({w_Control_D, w_PC_D, w_RS1_D, w_RS2_D, w_Immediate_D, w_RS1Addr_D, w_RS2Addr_D, w_RDAddr_D}),
        .o_Out({w_Control_E, w_PC_E, w_RS1_E, w_RS2_E, w_Immediate_E, w_RS1Addr_E, w_RS2Addr_E, w_RDAddr_E})
    );

    ALU ALU0 (
        .i_OpCode(w_AluOp_E),

        .i_ForASel(w_AluForwardASrc),
        .i_ForA0(w_RS1_E),
        .i_ForA1(w_AluResult_M),
        .i_ForA2(w_AluResult_W),

        .i_ForBSel(w_AluForwardBSrc),
        .i_ForB0(w_RS2_E),
        .i_ForB1(w_AluResult_M),
        .i_ForB2(w_AluResult_W),

        .i_SrcBSel(w_AluBSel_E),
        .i_SrcB1(w_Immediate_E),

        .o_Result(w_AluResult_E),
        .o_Zero(w_AluZero_E)
    );

    Mux_2_1 DBusForwardA(
        .i_Sel(w_DBusForwardASrc),
        .i_Src0(w_RS2_E),
        .i_Src1(w_WBData_W),

        .o_Data(w_DBusWrData_E)
    );

    //Memory Stage//
    StageReg #(
        .WIDTH(147)
    ) IE_MEM (
        .i_Clk(i_Clk),

        .i_En(w_RegEn_M),
        .i_Clear(w_RegClr_M),

        .i_In({w_Control_E[12:5], w_PC_E, w_AluZero_E, w_AluResult_E, w_Immediate_E, w_DBusWrData_E, w_RS2Addr_E, w_RDAddr_E}),
        .o_Out({w_Control_M, w_PC_M, w_AluZero_M, w_AluResult_M, w_Immediate_M, w_DBusWrDataSReg_M, w_RS2Addr_M, w_RDAddr_M})
    );

    Mux_2_1 DBusForwardB(
        .i_Sel(w_DBusForwardBSrc),
        .i_Src0(w_DBusWrDataSReg_M),
        .i_Src1(w_WBData_W),

        .o_Data(w_DBusWrData_M)
    );

    DBUS DBUS0(
        .i_Clk(i_Clk),

        .o_DBusAddr(o_DBusAddr),
        .o_DBusRe(o_DBusRe),
        .o_DBusWe(o_DBusWe),
        .o_DBusByteEn(o_DBusByteEn),
        .i_DBusRd(i_DBusRd),
        .i_DBusWd(i_DBusWd),

        .i_BusMode(w_func3_M),
        .i_CpuAddr(w_AluResult_M),
        .i_CpuRe(w_DRAM_Re_M),
        .i_CpuWe(w_DRAM_We_M),
        .o_CpuRd(w_DRAM_Rd_M),
        .i_CpuWd(w_DBusWrData_M)
    );

    //Write Back Stage//
    StageReg #(
        .WIDTH(39)
    ) MEM_WB (
        .i_Clk(i_Clk),

        .i_En(w_RegEn_W),
        .i_Clear(w_RegClr_W),
        
        .i_In({w_Control_M[7:6], w_AluResult_M, w_RDAddr_M}),
        .o_Out({w_Control_W, w_AluResult_W, w_RDAddr_W})
    );

    Mux_2_1 WBSrc(
        .i_Sel(w_WBSrc_W),
        .i_Src0(w_AluResult_W),
        .i_Src1(w_DRAM_Rd_M),

        .o_Data(w_WBData_W)
    );
    

    //Misc//
    ForwardingUnit ForwardingUnit0(
        .i_RS1Addr_E(w_RS1Addr_E),
        .i_RS2Addr_E(w_RS2Addr_E),
        .i_RS2Addr_M(w_RS2Addr_M),
        .i_RDAddr_M(w_RDAddr_M),
        .i_RDAddr_W(w_RDAddr_W),
        .i_RegWrEn_M(w_RegWrEn_M),
        .i_RegWrEn_W(w_RegWrEn_W),

        .o_AluForA(w_AluForwardASrc),
        .o_AluForB(w_AluForwardBSrc),

        .o_DBusForA(w_DBusForwardASrc),
        .o_DBusForB(w_DBusForwardBSrc)
    );

    HazardUnit HazardUnit0 (
        .i_Clk(i_Clk),

        .i_RS1Addr_D(w_RS1Addr_D),
        .i_RS2Addr_D(w_RS2Addr_D),
        .i_RDAddr_E(w_RDAddr_E),
        .i_RDAddr_M(w_RDAddr_M),
        .i_RDAddr_E(w_RDAddr_W),
        .i_IsMemRead_E(w_WBSrc_E),
        .i_IsMemRead_M(w_WBSrc_M),
        .i_IsMemRead_W(w_WBSrc_W),
        .i_IsBranch_E(w_IsBranch_E),
        .i_IsBranch_M(w_IsBranch_M),
        .i_TakeBranch_M(w_TakeBranch),
        
        .o_PcEn0(w_PcEn0),
        .o_IRAMSel(w_IRAMSel),

        .o_RegEn_D(w_RegEn_D),
        .o_RegEn_E(w_RegEn_E),
        .o_RegEn_M(w_RegEn_M),
        .o_RegEn_W(w_RegEn_W),

        .o_RegClr_D(w_RegClr_D),
        .o_RegClr_E(w_RegClr_E),
        .o_RegClr_M(w_RegClr_M),
        .o_RegClr_W(w_RegClr_W)
    );

endmodule
