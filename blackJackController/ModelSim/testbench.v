`timescale 1ns / 1ps

module testbench();

  // reg signals provide inputs to the design under test
  reg clk, rst, deal, hit, stand;

  // wire signals are used for outputs
  wire [2:0] state;
  wire [41:0] seg;

  // instantiate the design under test  
  blackJackController M1 (clk, rst, deal, hit, stand, state, seg);

  // clock generation
  initial
    begin
	   rst = 0;
      clk = 0;
		deal = 1;
		hit = 1;
		stand = 1;
		
		forever #10 clk = ~clk;
    end

	 
	// HERE IS THE SEED USED FOR THIS TESTBENCH:  lfsr = 6'b011110; // SEED 
	
  // assign signal values at various simulation times
	initial
		begin
		
		#20
		rst = 1;
		#30
		rst = 0;
		
		#1000
		
		// Pulse deal button for 1 clk pulse. This will deal initial cards. Dealer will show up card. Player will show first card.
		deal = 0;
		#500
		deal = 1;
	
		#4000
		
		// Pulse deal button for 1 clk pulse. Displays player total sum. Player turn starts
		deal = 0;
		#40
		deal = 1;
		
		// Show next player card
		#50
		
		deal = 0;
		#40
		deal = 1;
		
		
		// Stand
		#50
		
		stand = 0;
		#40
		stand = 1;
		
		// deal dealer
		#50
		
		deal = 0;
		#40
		deal = 1;
		
		// next game
		#70
		
		deal = 0;
		#40
		deal = 1;
		
		// deal
		#50
		
		deal = 0;
		#40
		deal = 1;
		
		// deal
		#50
		
		deal = 0;
		#40
		deal = 1;
		
		// hit
		#50
		
		hit = 0;
		#40
		hit = 1;
	
		end // initial
	endmodule
