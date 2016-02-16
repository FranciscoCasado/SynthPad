`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:51:14 02/16/2016
// Design Name:   dac_interface
// Module Name:   C:/Users/K n z o/Dropbox/MIDI-FPGA/Codigo/DAC-Interface/dac_interface/dac_interface_test.v
// Project Name:  dac_interface
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dac_interface
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dac_interface_test;

	// Inputs
	reg CLK_IN = 0;;
	reg [11:0] DATA_IN;
	reg SPI_MISO;

	// Outputs
	wire SPI_MOSI;
	wire SPI_SCK;
	wire DAC_CS;
	wire DAC_CLR;

	// Instantiate the Unit Under Test (UUT)
	dac_interface uut (
		.CLK_IN(CLK_IN), 
		.DATA_IN(DATA_IN), 
		.SPI_MISO(SPI_MISO), 
		.SPI_MOSI(SPI_MOSI), 
		.SPI_SCK(SPI_SCK), 
		.DAC_CS(DAC_CS), 
		.DAC_CLR(DAC_CLR)
	);

    always begin
        #10        
        CLK_IN = ~CLK_IN;
    end

	initial begin
		// Initialize Inputs
		DATA_IN = 0;
		SPI_MISO = 0;

		// Wait 100 ns for global reset to finish
		#1000;
        
		// Add stimulus here
        DATA_IN = 11'b10101000001;
        
        #4000;
	end
      
endmodule

