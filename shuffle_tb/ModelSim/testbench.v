`timescale 1ns / 1ps

module testbench();

// reg signals provide inputs to the design under test
reg clk, rst, shuffleFlag;
reg [5:0] SEED;

// wire signals are used for outputs
wire loadFlag;
wire [5:0] card;

// instantiate the design under test  
shuffle M1 (clk, rst, shuffleFlag, SEED, loadFlag, card);

// clock generation
initial
begin
	clk = 0;
	rst = 0;
	shuffleFlag = 0;
	SEED = 0;
	
	forever #10 clk = ~clk;
end


// assign signal values at various simulation times
initial
	begin
		
		#20
		rst = 1;
		#30
		rst = 0;
		
		// Wait to show that the module is waiting
		#500
		
		// Set SEED
		SEED = 6'b101011;
		#500
		
		// Set shuffleFlag high
		shuffleFlag = 1;
		
		
	end
endmodule
