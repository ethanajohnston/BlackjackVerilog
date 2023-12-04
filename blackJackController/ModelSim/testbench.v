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

  // assign signal values at various simulation times
	initial
		begin
		
		#20
		rst = 1;
		#30
		rst = 0;
		
	   // Wait for shuffle and load...
		#3500
		
		// Pulse deal button for 1 clk pulse. This will deal initial cards. Dealer will show up card. Player will show first card.
		deal = 1;
		#20
		deal = 0;
	
		#50
		
		// Pulse deal button for 1 clk pulse. Displays player total sum. Player turn starts
		deal = 1;
		#20
		deal = 0;
		
		#50
		//simulate a stand
		stand = 1;
		#20
		stand = 0;
		
		#50
		
		// check if dealer won. deal new card?
		deal = 1;
		#20
		deal = 0;
		
		
		/*
		#200
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#10
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#50
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#50
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#50
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		
		*/
		end // initial
	endmodule
