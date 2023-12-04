
/*
	Controls all blackjack operations. No splitting, double or insurance. Simple blackjack.
	By: Ethan Johnston B00828763
*/



// Change shuffle module to be independent. When enable bit is high, it is shuffled, and waits until shuffle output interrrupt is set to continue.
// Instead of loading deck from shuffle module to main module for each card, do it all at once. Make a loader state? 
// Only load over card not value


// If dealer has 


module blackJackController (
  input clk,
  input rst,	// rst
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

integer i, remainingCards, cardNumber, playerCardNumber, dealerCardNumber, loop_counter;

reg [4:0] playerSum, dealerSum, dealerDisplay, playerDisplay; // Storing up to 31

reg [3:0] playerCardValues [0:9];
reg [3:0] dealerCardValues [0:9];

reg [3:0] currentCardValue;
reg [5:0] previousCard;

wire [5:0] currentCard;

reg [31:0] startTime;

wire [31:0] time_ms;

reg dealt;

reg shuffleFlag;
wire loadFlag;


reg [5:0] gameDeck [0:51];
reg [3:0] gameDeckValues [0:51];



shuffle shuffle1 (.clk(clk), .rst(rst), .shuffleFlag(shuffleFlag), .loadFlag(loadFlag), .card(currentCard));

//display display1 (clk, rst, state, playerDisplay, dealerDisplay);

millis millis1 (.clk(clk), .rst(rst), .time_ms(time_ms));

// TODO: There will likely be an issue with how buttons are handled... since we are not checking for a button posedge or negedge, just that is it pressed.
// different always block to handle button press logic?

//TODO implement function to get time in between button clicks and set it as the seed.

// Define state transitions
always @(posedge clk or posedge rst) begin
  
	if (rst) begin
		
		for (i = 0; i <= 9; i = i + 1) begin
			dealerCardValues[i] = 0;
			playerCardValues[i] = 0;
		end
		cardNumber = 0;
		shuffleFlag = 0;
		dealt = 0;
		state = LOAD;
		remainingCards = 52;
		previousCard = 53;
	 
	end 
	else begin
			
		case (state)
			IDLE:
				if(cardNumber >= 40) begin
				
					// reshuffle or tell user to RESET? <- easier
					
				end
				else if (deal) begin
					// Shift deck by cardNumber. This is so that new rounds always start at 0 index in deck.
					//gameDeckValues[0:51-cardNumber-1] = gameDeckValues[cardNumber+1:51]; // The cardNumber >= 40 catches 
				
					for (i = 0; i < (52 - cardNumber - 1) && (i < 52); i = i + 1) begin
						gameDeckValues[i] = gameDeckValues[i + cardNumber + 1];
					end
					
					for (i = 0; i <= 9; i = i + 1) begin
						dealerCardValues[i] = 0;
						playerCardValues[i] = 0;
					end
					
					cardNumber = 0;
					playerCardNumber = 0;
					dealerCardNumber = 0;
					
					state = DEAL;				
				
				end
			
			LOAD:
			begin
				// Load cards from shuffle module and then set state to IDLE.
				
				shuffleFlag = 1; // Tell shuffle to begin.
				
				
				// When shuffle module is ready to load.
				
				 // run when ready to load, flag is set to 1.
				if (loadFlag == 1) begin
					if (remainingCards != 0) begin
						// check if the card value has changed
						if (currentCard != previousCard) begin
														
							// Convert currentCard to the value of card.
							// Aces are set as 1 and checked in controller if they can be a 10.
							case (currentCard)
								0,1,2,3,4,5,6,7,8: currentCardValue = currentCard + 1;  		// Cards Ace to 9 clubs
								9,10,11,12: currentCardValue = 10;  						// 10, Jack, Queen, King clubs
								13,14,15,16,17,18,19,20,21: currentCardValue = currentCard - 12;  	// Cards Ace to 9 of Diamonds
								22,23,24,25: currentCardValue = 10;  					// 10, Jack, Queen, King of Diamonds
								26,27,28,29,30,31,32,33,34: currentCardValue = currentCard - 25;  	// Cards Ace to 9 of Hearts
								35,36,37,38: currentCardValue = 10;  					// 10, Jack, Queen, King of Hearts
								39,40,41,42,43,44,45,46,47: currentCardValue = currentCard - 38;  	// Cards Ace to 9 of Spades
								48,49,50,51: currentCardValue = 10;  					// 10, Jack, Queen, King of Spades
								default: currentCardValue = 0;  							// Invalid card index
							endcase
							
							gameDeckValues[remainingCards - 1] = currentCardValue;
							//gameDeck[remainingCards - 1] = currentCard; // Load new card

							
							remainingCards = remainingCards - 1;
							
							$display("%d  %d", remainingCards, currentCard);

							previousCard = currentCard;
						end
					end
					else begin
					
						// once cards are all loaded set 
						state = IDLE;
					
					end
				end
			end
			
			DEAL:
			begin
				if (dealt == 0) begin
					// Deal first cards to hands					
					playerCardValues[0] = gameDeckValues[0]; 
					dealerCardValues[0] = gameDeckValues[1]; // hole card
					playerCardValues[1] = gameDeckValues[2];
					dealerCardValues[1] = gameDeckValues[3]; // upcard
					
					playerCardNumber = 1;
					dealerCardNumber = 1;

					// Check aces for player
					if(playerCardValues[0] == 1) begin
						playerCardValues[0] = 11;
					end
					if(playerCardValues[1] == 1) begin
						if(playerCardValues[0] + 11 > 21) begin
							playerCardValues[1] = 1;
						end
					end
	
					// Check aces for dealer	
					if(dealerCardValues[0] == 1) begin
						dealerCardValues[0] = 11;
					end
					if(dealerCardValues[1] == 1) begin
						if(dealerCardValues[0] + 11 > 21) begin
							dealerCardValues[1] = 1;
						end
					end
					
					// Sum hands
					playerSum = playerCardValues[0] + playerCardValues[1];
					dealerSum = dealerCardValues[0] + dealerCardValues[1];
					
					// check if player has blackjack
					if(playerSum == 21) begin
						state = END_GAME;
					end
					
					// display cards
					playerDisplay = playerCardValues[0];
					dealerDisplay = dealerCardValues[1];
					
					dealt = 1;
				end
				
				// Could make this a separate state:
				if(deal) begin
					cardNumber = 3;
					state = PLAYER_TURN;
				end
				
			end
			PLAYER_TURN:
			begin
				playerDisplay = playerSum;

				// Stand
				if (stand) begin
					state = DEALER_TURN;
				end
				// Hit
				else if (hit) begin
				
					// give player new card
					playerCardNumber = playerCardNumber + 1;
					cardNumber = cardNumber + 1;
					
					// checking if ace should be 11 or 1
					if(gameDeckValues[cardNumber] == 1) begin
						if(playerSum + 11 <= 21) begin
							playerCardValues[playerCardNumber] = 11;
						end
						else begin
							playerCardValues[playerCardNumber] = 1;
						end
					end
					else begin
						playerCardValues[playerCardNumber] = gameDeckValues[cardNumber];
					end
					
					playerSum = playerSum + playerCardValues[playerCardNumber];				
					
					

					// check if player has busted. Change aces to 1 if possible and continue game.
					if(playerSum > 21) begin
					
						// check for aces
						loop_counter = 0;
						for(i = 0; i <= playerCardNumber && (i < 9); i = i + 1) begin
							if(playerCardValues[i] == 11) begin
								playerCardValues[i] = 1;
								i = playerCardNumber + 1; // break
							end
							
							// To avoid ERROR: loop with non-constant loop condition must terminate within 250 iterations 
							if (loop_counter >= 240) begin
								i = 240;
							end
							loop_counter = loop_counter + 1;
						
						end
					
						// recalculate playerSum
						playerSum = 0;
						for(i = 0; i <= playerCardNumber && (i < 9); i = i + 1) begin
							playerSum = playerSum + playerCardValues[i];
						end
						
						if(playerSum > 21) begin
							state = END_GAME;
						end
					end
					// check if player has won		
					else if(playerSum == 21) begin
						state = END_GAME;
					end
					
					playerDisplay = playerSum;
				end
							
			end
			DEALER_TURN:
			begin
				dealerDisplay = dealerSum;
				
				if(deal) begin
					
					// check if dealer wins
					if(dealerSum > 21) begin
						// check for aces valued at 11.
						loop_counter = 0;
						for(i = 0; i <= dealerCardNumber && (i < 9); i = i + 1) begin
							if(dealerCardValues[i] == 11) begin
								dealerCardValues[i] = 1;
								i = dealerCardNumber + 1; // break
							end
							
							// To avoid ERROR: loop with non-constant loop condition must terminate within 250 iterations 
							if (loop_counter >= 240) begin
								i = 240;
							end
							loop_counter = loop_counter + 1;							
						end
					
						// recalculate dealerSum
						dealerSum = 0;
						for(i = 0; i <= dealerCardNumber && (i < 9); i = i + 1) begin
							dealerSum = dealerSum + dealerCardValues[i];
						end
						
						if(dealerSum > 21) begin
							state = END_GAME;
						end
						
					end
					else if(dealerSum == 21) begin
						state = END_GAME;
					end
					// Check for soft 17
					else if(dealerSum <= 17) begin
						
						// give dealer new card
						dealerCardNumber = dealerCardNumber + 1;
						cardNumber = cardNumber + 1;
						
						// checking if ace should be 11 or 1
						if(gameDeckValues[cardNumber] == 1) begin
							if(dealerSum + 11 <= 21) begin
								dealerCardValues[dealerCardNumber] = 11;
							end
							else begin
								dealerCardValues[dealerCardNumber] = 1;
							end
						end
						else begin
							dealerCardValues[dealerCardNumber] = gameDeckValues[cardNumber];
						end
						
						dealerSum = dealerSum + dealerCardValues[dealerCardNumber];				

					end
					dealerDisplay = dealerSum;
				end

			end
			END_GAME:
			begin
			
				if(playerSum > 21) begin
					//Player busted. Dealer wins.
				end
				else if (dealerSum > 21) begin
					// Dealer busts! Player wins.
				end
				else if (dealerSum == playerSum) begin
					// It's a tie! Push.
				end
				else if (playerSum == 21) begin
					// Player has blackjack! Player wins.
				end
				else if (dealerSum == 21) begin
					// Dealer has blackjack! Dealer wins.
				end
				else if (playerSum > dealerSum) begin
					// Player wins!
				end
				else begin
					// Dealer wins.
				end
				
				if(deal) begin
					state = IDLE;
				end
			end
			default:
				state = IDLE;
		endcase
	 
	end
end

endmodule

