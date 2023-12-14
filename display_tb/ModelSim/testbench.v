`timescale 1ns / 1ps

module testbench;

    // Inputs
    reg clk;
    reg rst;
    reg [4:0] playerHand;
    reg [4:0] dealerHand;
    reg [2:0] state;
    reg [1:0] displayState;
    reg resetToReshuffle;  
    // Outputs
    wire [41:0] seg;
	//params
	parameter IDLE = 3'b000;		 	// 0
	parameter DEAL = 3'b001; 			// 1
	parameter PLAYER_TURN = 3'b010; 	// 2
	parameter DEALER_TURN = 3'b011; 	// 3
	parameter END_GAME = 3'b100; 		// 4
	parameter LOAD = 3'b101; 			// 5
	
	parameter LOSE = 2'b00;		 	// 0
	parameter TIE = 2'b01; 			// 1
	parameter WIN = 2'b10; 			// 2
	parameter BJ = 2'b11; 			// 3

    // Instantiate the Unit Under Test (UUT)
    display uut (
        .clk(clk),
        .rst(rst),
        .playerHand(playerHand),
        .dealerHand(dealerHand),
        .state(state),
        .displayState(displayState),
        .resetToReshuffle(resetToReshuffle), 
        .seg(seg)
    );

    // Generate clock
    initial begin
        clk = 0; // Initial clock value
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test procedure
    initial begin
        // Initialize Inputs
        rst = 1; resetToReshuffle = 0; 
        playerHand = 0;
        dealerHand = 0;
        state = 0;
        displayState = 0;

        // Reset the state
        #50 rst = 0;
        
        // Test each state and displayState
        
        // Test IDLE state with resetToReshuffle = 0 and resetToReshuffle = 1
        state = IDLE;
        resetToReshuffle = 0; 
        #50; // Wait for state to settle
        $display("IDLE state, resetToReshuffle = 0, seg: %b", seg);

        resetToReshuffle = 1; 
        #50; // Wait for state to settle
        $display("IDLE state, resetToReshuffle = 1, seg: %b", seg);

        resetToReshuffle = 0; 
		  // LOAD TEST
        state = LOAD;
        
        #50; // Wait for state to settle
        $display("LOAD state, seg: %b", seg);
        
        // DEAL TEST
        state = DEAL;
        playerHand = 7;
        dealerHand = 8;
        #50; // Wait for state to settle
        $display("DEAL state, seg: %b", seg);
        
        playerHand = 17;
        dealerHand = 18;
        #50; // Wait for state to settle
        $display("DEAL state, seg: %b", seg);
        
        playerHand = 20;
        dealerHand = 20;
        #50; // Wait for state to settle
        $display("DEAL state, seg: %b", seg);
        
        // PLAYER_TURN TEST
        state = PLAYER_TURN;
        playerHand = 4;
        #50; // Wait for state to settle
        $display("PLAYER_TURN state, seg: %b", seg);
        
        playerHand = 14;
        #50; // Wait for state to settle
        $display("PLAYER_TURN state, seg: %b", seg);
        
        playerHand = 24;
        #50; // Wait for state to settle
        $display("PLAYER_TURN state, seg: %b", seg);
        
        // DEALER_TURN TEST
        state = DEALER_TURN; 
        dealerHand = 4;
        #50; // Wait for state to settle
        $display("DEALER_TURN state, seg: %b", seg);
        
        dealerHand = 14;
        #50; // Wait for state to settle
        $display("DEALER_TURN state, seg: %b", seg);
        
        dealerHand = 24;
        #50; // Wait for state to settle
        $display("DEALER_TURN state, seg: %b", seg);
        
        // END_GAME TEST
        state = END_GAME;
        displayState = WIN; 
        dealerHand = 4;
        playerHand = 14;
        #50; // Wait for state to settle
			  $display("END_GAME win state, seg: %b", seg);
        
        displayState = TIE; 
        dealerHand = 17;
        playerHand = 17;
        #50; // Wait for state to settle
        $display("END_GAME tie state, seg: %b", seg);
        
        displayState = LOSE; 
        dealerHand = 21;
        playerHand = 14;
        #50; // Wait for state to settle
        $display("END_GAME lose state, seg: %b", seg);
        
        displayState = BJ;
        dealerHand = 4;
        playerHand = 21;
        #50; // Wait for state to settle
        $display("END_GAME blackjack state, seg: %b", seg);

        // Test round finished
        $display("Testing Completed");

    end

endmodule