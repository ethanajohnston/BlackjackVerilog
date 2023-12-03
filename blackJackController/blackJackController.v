
/*
	Controls all blackjack operations. No splitting, double or insurance. Simple blackjack.
	By: Ethan Johnston B00828763
*/



// Change shuffle module to be independent. When enable bit is high, it is shuffled, and waits until shuffle output interrrupt is set to continue.
// Instead of loading deck from shuffle module to main module for each card, do it all at once. Make a loader state? 
// Only load over card



module blackJackController (
  input clk,
  input rst,
  input deal,  // button
  input hit,	// button
  input stand, // button
  output reg [3:0] state
);


// Define states
parameter IDLE = 4'b0000;
parameter DEAL = 4'b0001;
parameter PLAYER_TURN = 4'b0010;
parameter DEALER_TURN = 4'b0011;
parameter END_GAME = 4'b0100;
parameter LOAD = 4'b0101;

integer i;

reg [4:0] playerSum, dealerSum, dealerDisplay, playerDisplay; // Storing up to 31

reg [3:0] playerCardValues [0:9];
reg [3:0] dealerCardValues [0:9];

reg [3:0] currentCardValue;
reg [5:0] currentCard, previousCard;

reg [31:0] time_ms, startTime, delay = 1000;

reg dealt;

wire shuffleFlag, loadFlag;

reg [5:0] gameDeck [0:51];


shuffle shuffle1 (.clk(clk), .rst(rst), .shuffleFlag(shuffleFlag), .loadFlag(loadFlag), .card(currentCard));

//display display1 (clk, rst, state, playerDisplay, dealerDisplay);

millis millis1 (.clk(clk), .rst(rst), .time_ms(time_ms));


// Define state transitions
always @(posedge clk or posedge rst) begin
  
	if (rst) begin
		
		for (i = 0; i <= 9; i = i + 1) begin
			dealerCards[i] = 0;
			playerCards[i] = 0;
		end
		
		shuffleFlag = 0;
		dealt = 0;
		state = LOAD;
		remainingCards = 52;
	 
	end 
	else begin

		case (state)
			IDLE:
				if (deal) begin
				
					state = DEAL;
					
				end
			LOAD:
				// Load cards from shuffle module and then set state to IDLE.
				
				shuffleFlag = 1; // Tell shuffle to begin.
				
				
				// When shuffle module is ready to load.
				if (loadFlag == 1) begin // run when ready to load, flag is set to 1.
					if (remianingCards != 0) begin
						// check if the card value has changed
						if (currentCard != previousCard) begin
							
							gameDeck[remainingCards - 1] = currentCard; // Load new card over
							
							
							remainingCards = remainingCards - 1;
							
							$display("%d:  %d", remainingCards, currentCard);

							previousCard = currentCard;
						end
					end
					else begin
					
						// once cards are all loaded set 
						state = IDLE;
					
					end
				end
			
			DEAL:
				//if (dealt == 0) begin
					// Deal first cards to hands
					//TODO: REDO ALL OF THIS!!! Set player and dealer cards and display cards with delay in between
					
					/*
					playerCardValues[0] = currentCardValue;

					dealCardFlag = ~dealCardFlag;
					dealerCardValues[0] = currentCardValue;

					dealCardFlag = ~dealCardFlag;
					playerCardValues[1] = currentCardValue;

					dealCardFlag = ~dealCardFlag;
					dealerCardValues[1] = currentCardValue;
					
					playerSum = playerCardValues[0] + playerCardValues[1];
					dealerSum = dealerCardValues[0] + dealerCardValues[1];
					
					playerDisplay = playerCardValues[0];
					dealerDisplay = dealerCardValues[1];
					
					dealt = 1;
					
					startTime = time_ms;
					
				end
				
				if (time_ms - startTime > delay) begin
				
					playerDisplay = playerCardValues[1];
				
				end
				
				
				if (hit) begin
					
				end
				else if (stand) begin
					
				end
				*/
				state = DEALER_TURN;
			PLAYER_TURN:
				if (hit) begin 
				
					// Add logic to check if player busts or not
				end 
				else if (stand) begin
					state = DEALER_TURN;
				end
			DEALER_TURN:
				// Add logic to handle dealer's turn
				
				// iterate through dealer cards on each button press
				
				
				
				
				state = END_GAME;
			END_GAME:
				// Add logic to handle end of game, reset or exit
				
				// celebrate
				
				
				state = IDLE;
			default:
				state = IDLE;
		endcase
	 
	end
end

endmodule


/* used for translation of card to value

			// Aces are set as 1 and checked in controller if they can be a 10.
			case (deck[dealCount])
				0,1,2,3,4,5,6,7,8: cardValue = deck[dealCount] + 1;  		// Cards Ace to 9 clubs
				9,10,11,12: cardValue = 10;  						// 10, Jack, Queen, King clubs
				13,14,15,16,17,18,19,20,21: cardValue = deck[dealCount] - 12;  	// Cards Ace to 9 of Diamonds
				22,23,24,25: cardValue = 10;  					// 10, Jack, Queen, King of Diamonds
				26,27,28,29,30,31,32,33,34: cardValue = deck[dealCount] - 25;  	// Cards Ace to 9 of Hearts
				35,36,37,38: cardValue = 10;  					// 10, Jack, Queen, King of Hearts
				39,40,41,42,43,44,45,46,47: cardValue = deck[dealCount] - 38;  	// Cards Ace to 9 of Spades
				48,49,50,51: cardValue = 10;  					// 10, Jack, Queen, King of Spades
				default: cardValue = 0;  							// Invalid card index
			endcase

*/
