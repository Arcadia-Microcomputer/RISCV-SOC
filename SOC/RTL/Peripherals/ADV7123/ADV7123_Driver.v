`timescale 1ns / 1ps

module ADV7123_Driver#(
    //horizontal timing (Line)
    parameter HorSyncTime = 96,
    parameter HorBackPorch = 48,
    parameter HorFrontPorch = 16,
    parameter HorAddrVideoTime = 640,
    parameter HorEndCnt = 800,
    //vertical timing (Frame)
    parameter VertSyncTime = 2,
    parameter VertBackPorch = 32,
    parameter VertFrontPorch = 10,
    parameter VertAddrVideoTime = 480,
    parameter VertEndCnt = 525
    )(
		input i_VidClk,

    output reg o_inVBlank,
    input [15:0]i_Colour,

    //ADV7123 Signals
		output o_Pixel_Clk,
		output o_VSync,
		output o_HSync,
		output reg o_nBlank,
		output reg [4:0]o_R,
		output reg [5:0]o_G,
		output reg [4:0]o_B
    );

    initial begin
      o_inVBlank = 0;
      o_nBlank = 0;
      o_R = 0;
      o_G = 0;
      o_B = 0;
    end

    ODDR2 #(
        .DDR_ALIGNMENT("NONE"), // Sets output alignment to "NONE", "C0" or "C1" 
        .INIT(1'b0),    // Sets initial state of the Q output to 1'b0 or 1'b1
        .SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
    ) ODDR2_ClkOut (
        .Q(o_Pixel_Clk),        // 1-bit DDR output data
        .C0(i_VidClk),    // 1-bit clock input
        .C1(!i_VidClk),   // 1-bit clock input
        .CE(1'b1),    // 1-bit clock enable input
        .D0(1'b1),  // 1-bit data input (associated with C0)
        .D1(1'b0)   // 1-bit data input (associated with C1)
    );

    reg [$clog2(HorEndCnt) - 1:0] r_NextHPos = 0;
    reg [$clog2(VertEndCnt) - 1:0] r_NextVPos = 0;

    reg [$clog2(HorEndCnt) - 1:0] r_HPos = 0;
    reg [$clog2(VertEndCnt) - 1:0] r_VPos = 0;

    assign o_HSync = ((r_HPos > (HorAddrVideoTime + HorFrontPorch)) && (r_HPos < (HorAddrVideoTime + HorFrontPorch + HorSyncTime))) ? 1'b1 : 1'b0;
    assign o_VSync = ((r_VPos > (VertAddrVideoTime + VertFrontPorch)) && (r_VPos < (VertAddrVideoTime + VertFrontPorch + VertSyncTime))) ? 1'b1 : 1'b0;

    always @ (posedge i_VidClk) begin
      //Check to see if the line is finished
      if(r_NextHPos <= HorEndCnt)begin
            r_NextHPos <= r_NextHPos + 1;
      end else begin
          //The line is comlete so reset the HPos counter
          r_NextHPos <= 0;       

          if(r_VPos == VertAddrVideoTime)begin
            o_inVBlank <= 1;
          end

          //Check to see if the frame is complete
          if(r_NextVPos < VertEndCnt)begin
            //Frame isn't done yet
            r_NextVPos <= r_NextVPos + 1;
          end else begin
            //Frame is done so reset the VPos counter
            r_NextVPos <= 0;

            o_inVBlank <= 0;
          end
      end
      
      r_HPos <= r_NextHPos;
      r_VPos <= r_NextVPos;

      //Check to see if in the display area
      if((r_HPos >= HorAddrVideoTime) || (r_VPos >= VertAddrVideoTime))begin
        o_R <= 3'b000;
        o_G <= 3'b000;
        o_B <= 2'b00;
        o_nBlank <= 0;
      end else begin
        o_R <= i_Colour[15:11];
        o_G <= i_Colour[10:5];
        o_B <= i_Colour[4:0];
        o_nBlank <= 1;
      end
    end

endmodule
