`timescale 1ns / 1ps

module SOC_tb();
    reg r_Clk = 0;
    
    //Flash Signals
    wire w_Flash_nCS;
    wire w_Flash_Clk;
    wire [3:0]w_Flash_IO;

    //Generate the clock
    initial begin
        #10;
        forever #10 r_Clk = ~r_Clk;
    end

    SOC SOC0(
        .i_OscClk_100Mhz(r_Clk),

        .o_UserFlash_Clk(w_Flash_Clk),
        .o_UserFlash_nCS(w_Flash_nCS),
        .io_UserFlash_IO(w_Flash_IO)
    );

    W25Q16JV W25Q16JV_0(
        .CSn(w_Flash_nCS),
        .CLK(w_Flash_Clk),

        .DIO(w_Flash_IO[0]),
        .DO(w_Flash_IO[1]),
        .WPn(w_Flash_IO[2]),
        .HOLDn(w_Flash_IO[3])
    );
endmodule
