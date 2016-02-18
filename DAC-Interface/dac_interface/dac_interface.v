`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kenzo Lobos
// 
// Create Date:    12:15:03 02/16/2016 
// Design Name: 
// Module Name:    dac_interface 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module dac_interface(
    CLK_IN,
    DATA_IN,
    SPI_MISO,
    SPI_MOSI,
    SPI_SCK,
    DAC_CS,
    DAC_CLR
    );

    input CLK_IN;
    input [11:0] DATA_IN;
    input SPI_MISO;
    
    output reg SPI_MOSI;
    output wire SPI_SCK;
    output reg DAC_CS = 1;
    output reg DAC_CLR = 1;
    
    parameter DAC_ID = 4'b0000;
    parameter DAC_COMMAND  = 4'b0011;
    
    reg [31:0] shift_register = 32'b0;
    reg [11:0] last_data = 12'b00000000000;
    
    reg clk0 = 0;
    reg clk1 = 0;
    reg init;
    reg clk_delay = 1'b0;
    reg [5:0] shift_counter;
    
    wire new_data;
    
    assign new_data = |(DATA_IN - last_data);
    assign SPI_SCK = (init == 1 & shift_counter != 0 ) ? clk1 : 0; // Be a greenpeace signal?
       
    // Creates 2 Clocks with a 90 phase delay
    always@(posedge CLK_IN)
    begin
        clk_delay <= clk_delay + 1;
    
        if(clk_delay == 1'b0)
            clk0 <= ~clk0;
        else if(clk_delay == 1'b1)
            clk1 <= ~clk1;
    end
    
    always@(posedge clk1)
    begin
        if(new_data == 1 && init == 0)
        begin
            init <= 1;
            shift_counter <= 5'b00000;
            shift_register <= {8'b00000000,DAC_COMMAND,DAC_ID,DATA_IN, 4'b0000};
            last_data <= DATA_IN;
            DAC_CS <= 0;
        end
        else if(init == 1)
        begin
            if(shift_counter == 6'b100000)
            begin
                init <= 0;
                DAC_CS <= 1;
            end
            else
            begin
                shift_counter <= shift_counter + 5'b00001;  
            end
        end
        else
        begin
            init <= 0;
            DAC_CS <= 1;
        end
    end
    
    always@(posedge clk0)
    begin
        if(init == 1)
        begin
            SPI_MOSI <= shift_register[31 - shift_counter[4:0]];
            //shift_register[31:1] <= shift_register[30:0];   
        end
        else
        begin
            SPI_MOSI <= 0;
        end
    end
    
endmodule
