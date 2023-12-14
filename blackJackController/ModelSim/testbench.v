`timescale 1ns / 1ps

module testbench();

// reg signals provide inputs to the design under test
reg clk, rst, deal, hit, stand;

// wire signals are used for outputs
wire [41:0] seg;

// instantiate the design under test
blackJackController M1 (clk, rst, deal, hit, stand, seg);

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


// assign signal values at various simulation times
initial
	begin
		
		#20
		rst = 1;
		#30
		rst = 0;
		
		#1200
		
		// LOAD STATE
		deal = 0;
		#6000 // This button hold time will dictate the SEED. SEED is 6.
		deal = 1;

		// Wait for shuffler and loader
		#4000

		// IDLE STATE

		// This will deal initial cards.
		// Dealer will show up card. 
		// Player will show first card.
		deal = 0;
		#40
		deal = 1;
		
		// Show next player card
		#50
		
		deal = 0;
		#40
		deal = 1;

		// PLAYER_TURN
		// Stand
		#50
		
		stand = 0;
		#40
		stand = 1;

		// DEALER_TURN
		// Deal dealer
		#50
		
		deal = 0;
		#40
		deal = 1;

		// END_GAME
		
		// Deal to go to IDLE
		#70
		
		deal = 0;
		#40
		deal = 1;

// New game 2
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

		// Deal to go to IDLE
		#50
		
		deal = 0;
		#40
		deal = 1;

// NEW GAME 3
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

		// hit
		#50
		
		hit = 0;
		#40
		hit = 1;

		// Deal to go to IDLE
		#50
		
		deal = 0;
		#40
		deal = 1;

// NEW GAME 4

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

		// Deal to go to IDLE
		#50

		deal = 0;
		#40
		deal = 1;

// NEW GAME 5

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

		// Deal to go to IDLE
		#50

		deal = 0;
		#40
		deal = 1;
// NEW GAME 6

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

		// Deal to go to IDLE
		#50

		deal = 0;
		#40
		deal = 1;

// New Game 7

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

		// Deal to go to IDLE
		#50

		deal = 0;
		#40
		deal = 1;

// New Game 8

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

		// stand
		#50
		
		stand = 0;
		#40
		stand = 1;

		// deal dealer
		#50

		deal = 0;
		#40
		deal = 1;

		// Deal to go to IDLE
		#50

		deal = 0;
		#40
		deal = 1;
// Game over
// need to reset to reshuffle

		// TRY INPUT
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

		// deal
		#50

		deal = 0;
		#40
		deal = 1;


	end
endmodule
