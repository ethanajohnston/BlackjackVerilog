`timescale 1ns / 1ps

module testbench();

  // reg signals provide inputs to the design under test
  reg clk, rst, deal, hit, stand;

  // wire signals are used for outputs
  wire [2:0] state;

  // instantiate the design under test  
  blackJackController M1 (clk, rst, deal, hit, stand, state);

  // clock generation
  initial
    begin
	   rst = 0;
      clk = 0;
		deal = 0;
		hit = 0;
		stand = 0;
		
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
		
	   // Wait for shuffle and load...
		#1200
		
		// Pulse deal button for 1 clk pulse. This will deal initial cards. Dealer will show up card. Player will show first card.
		deal = 1;
		#5000
		deal = 0;
	
		#4000
		
		// Pulse deal button for 1 clk pulse. Displays player total sum. Player turn starts
		deal = 1;
		#60
		deal = 0;
		
		#50
		
		// check if dealer won. deal new card?
		deal = 1;
		#60
		deal = 0;
		
		#50
		
		// Dealer wins in this case
		
		// start next game
		
		deal = 1;
		#60
		deal = 0;
				
		#100
		
		// Hit on playerTurn
		
		hit = 1;
		#60
		hit = 0;
		
		#50
		
		// Goto IDLE next turn
		deal = 1;
		#60
		deal = 0;
		
		#50
		
		// start next game
		deal = 1;
		#100
		deal = 0;
		
		#50
		
		// player Turn
		deal = 1;
		#60
		deal = 0;
		
		#50
		
		// Hit on playerTurn
		
		hit = 1;
		#55
		hit = 0;
		
		
		#50
		
		// Stand on playerTurn
		
		stand = 1;
		#60
		stand = 0;
		
		#50
		
		// Deal dealer because dealerSum < 17
		
		deal = 1;
		#100
		deal = 0;
		
		#50
		
		// Deal to continue. game should be done
		
		deal = 1;
		#80
		deal = 0;
		
		#50

		// goto idle
		
		deal = 1;
		#56
		deal = 0;
		
		#50

		
		// goto idle
		
		deal = 1;
		#20
		deal = 0;
		
		
	
		end // initial
	endmodule
