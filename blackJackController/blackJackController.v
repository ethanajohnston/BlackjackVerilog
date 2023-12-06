/*
	Controls all blackjack operations. No splitting, double or insurance. Simple blackjack. Dealer stands on soft 17.
	By: Ethan Johnston B00828763
*/

// NOTE: The player will need to remember that they have an ace in their hand. 
// If playerSum goes up 11 on a turn, this is an ace. This ace may be set to 1 value later in game, if it is better for player.
// TODO: Implement LED to signifiy the player has an ace that is currently worth 11. Could also do the same for dealer.

module blackJackController (
	input clk,			// clk input
	input rst,			// rst switch
	input deal,   		// button
	input hit,			// button
	input stand,  		// button
	output [41:0] seg 	// output to display segments
);

// Define states
parameter IDLE = 3'b000 /* synthesis keep */;		 	// 0
parameter DEAL = 3'b001 /* synthesis keep */; 			// 1
parameter PLAYER_TURN = 3'b010 /* synthesis keep */; 	// 2
parameter DEALER_TURN = 3'b011 /* synthesis keep */; 	// 3
parameter END_GAME = 3'b100 /* synthesis keep */; 		// 4
parameter LOAD = 3'b101 /* synthesis keep */; 			// 5

// Win States
parameter LOSE = 2'b00;		 	// 0
parameter TIE = 2'b01; 			// 1
parameter WIN = 2'b10; 			// 2
parameter BJ = 2'b11; 			// 3

// Variables
reg dealt, dealEdge, standEdge, hitEdge, seedObtained, shuffleFlag, resetToReshuffle;
reg [1:0] displayState;
reg [2:0] state;
reg [3:0] currentCardValue, playerCardNumber, dealerCardNumber;
reg [4:0] playerSum, dealerSum, dealerDisplay, playerDisplay; // Storing up to 31
reg [5:0] previousCard, remainingCards, SEED, cardNumber, deckCardNumber, i;
reg [31:0] startTime;

reg [3:0] playerCardValues [0:9];
reg [3:0] dealerCardValues [0:9];

reg [5:0] gameDeck [0:51];
reg [3:0] gameDeckValues [0:51];

wire loadFlag;
wire [5:0] currentCard;
wire [31:0] timeMicro;

// Module instantiation 
shuffle shuffle1 (.clk(clk), .rst(rst), .shuffleFlag(shuffleFlag), .SEED(SEED), .loadFlag(loadFlag), .card(currentCard));

display display1 (.clk(clk), .rst(rst), .playerHand(playerDisplay), .dealerHand(dealerDisplay), .state(state), .displayState(displayState), .resetToReshuffle(resetToReshuffle), .seg(seg));

microSeconds micros1 (.clk(clk), .rst(rst), .timeMicro(timeMicro));

// Define state transitions
always @(posedge clk or posedge rst) begin
  
	if (rst) begin
		
		for (i = 0; i <= 9; i = i + 1) begin
			dealerCardValues[i] = 0;
			playerCardValues[i] = 0;
		end
		
		// Reset variables
		cardNumber = 0;
		playerCardNumber = 0;
		dealerCardNumber = 0;
		shuffleFlag = 0;
		dealt = 0;
		state = LOAD;
		remainingCards = 52;
		previousCard = 53;
		deckCardNumber = 0;
		dealEdge = 0;
		standEdge = 0;
		hitEdge = 0;
		seedObtained = 0;
		SEED = 6'b101011; // Initial SEED
		resetToReshuffle = 0;
		displayState = 0;
	 
	end 
	else begin
			
		case (state)

			IDLE: // 0
			begin
				if(deckCardNumber >= 40) begin
				
					// deck out of cards... Tell user to RESET.
					resetToReshuffle = 1;
					$display("Out of cards. Need to reshuffle or reset.");
					
				end
				else if (!deal && (dealEdge == 0)) begin // press
					dealEdge = 1; // avoid multiple presses
				
				end
				else if (deal && (dealEdge == 1)) begin // release
					dealEdge = 0; // avoid multiple presses
						
					// Shift deck by cardNumber. This is so that new rounds always start at 0 index in deck.
					// Implementing dynamic array slicing
					//gameDeckValues[0:51-cardNumber-1] = gameDeckValues[cardNumber+1:51];
					if(cardNumber > 0) begin
						for (i = 0; i < (52 - cardNumber - 1) && (i < 52); i = i + 1) begin
							gameDeckValues[i] = gameDeckValues[i + cardNumber + 1];
						end
					end
					
					// Set old hand to 0
					for (i = 0; i <= 9; i = i + 1) begin
						dealerCardValues[i] = 0;
						playerCardValues[i] = 0;
					end
										
					cardNumber = 0;
					playerCardNumber = 0;
					dealerCardNumber = 0;
					dealt = 0;
					
					state = DEAL;
					
				end
			end

			LOAD: // 5
			begin
				// use button 
				if (!deal && (dealEdge == 0) && seedObtained == 0) begin // press
					dealEdge = 1; // avoid multiple presses
					startTime = timeMicro;
				
				end
				else if (deal && (dealEdge == 1) && seedObtained == 0) begin // release
					dealEdge = 0; // avoid multiple presses
					
					// calculate randomish SEED for LFSR
					SEED = (timeMicro - startTime) % 63;
					
					seedObtained = 1;

				end
				else if(seedObtained == 1) begin
					
					// Load cards from shuffle module and then set state to IDLE.
					shuffleFlag = 1; // Tell shuffle to begin.

					// When shuffle module is ready to load.
					if (loadFlag == 1) begin
						if (remainingCards > 0) begin
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
								
								remainingCards = remainingCards - 1;
								
								gameDeckValues[remainingCards] = currentCardValue;
								//gameDeck[remainingCards - 1] = currentCard; // Load new card
								
								$display("%d:  %d:  %d", remainingCards, currentCard, gameDeckValues[remainingCards]);

								previousCard = currentCard;
							end
						end
						else begin
						
							// once cards are all loaded set
							state = IDLE;
						
						end
					end				
				end

			end

			DEAL: // 1
			begin
				if (dealt == 0) begin
					// Deal first cards to hands
					playerCardValues[0] = gameDeckValues[0];
					//$display("%d", playerCardValues[0]);
					dealerCardValues[0] = gameDeckValues[1]; // hole card
					//$display("%d", dealerCardValues[0]);
					playerCardValues[1] = gameDeckValues[2];
					//$display("%d", playerCardValues[1]);
					dealerCardValues[1] = gameDeckValues[3]; // upcard
					//$display("%d", dealerCardValues[1]);
					
					//$display("CARD 0: %d", gameDeckValues[0]);
					
					playerCardNumber = 1;
					dealerCardNumber = 1;
					cardNumber = 3;

					// Check aces for player
					if(playerCardValues[0] == 1) begin
						playerCardValues[0] = 11;
					end
					if(playerCardValues[1] == 1) begin
						if(playerCardValues[0] + 11 <= 21) begin
							playerCardValues[1] = 11;
						end
					end
	
					// Check aces for dealer	
					if(dealerCardValues[0] == 1) begin
						dealerCardValues[0] = 11;
					end
					if(dealerCardValues[1] == 1) begin
						if(dealerCardValues[0] + 11 <= 21) begin
							dealerCardValues[1] = 11;
						end
					end
					
					// Sum hands
					playerSum = playerCardValues[0] + playerCardValues[1];
					dealerSum = dealerCardValues[0] + dealerCardValues[1];
					
					// check if player has blackjack
					if(playerSum == 21) begin
						displayState = 2'b11; // blackjack!
						state = END_GAME;
					end
					
					// display cards
					playerDisplay = playerCardValues[0];
					dealerDisplay = dealerCardValues[1];
					
					dealt = 1;
				end
				else begin
				
					// Button press
					if (!deal && (dealEdge == 0)) begin // press
						dealEdge = 1; // avoid multiple presses
					
					end
					else if (deal && (dealEdge == 1)) begin // release
						dealEdge = 0; // avoid multiple presses
						
						// DO DEAL LOGIC
						state = PLAYER_TURN;		
					end
				
				end
			
			end

			PLAYER_TURN: // 2
			begin
				playerDisplay = playerSum;

				// Stand
				if (!stand && (standEdge == 0)) begin // press
					standEdge = 1; // avoid multiple presses
				
				end
				else if (stand && (standEdge == 1)) begin // release
					standEdge = 0; // avoid multiple presses
					
					// DO STAND LOGIC
					$display("Player Stand.");
					state = DEALER_TURN;
				end
				
				
				// Hit
				if (!hit && (hitEdge == 0)) begin // press
					hitEdge = 1; // avoid multiple presses
				
				end
				else if (hit && (hitEdge == 1)) begin // release
					hitEdge = 0; // avoid multiple presses
					
					// DO HIT LOGIC
					
					$display("Player Hit.");
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
					
						// TOPO: This is not working properly... I got an ACE, then a 9, then I hit and it put my sum to 30... should be 20
						// check for aces
						for(i = 0; i <= 9; i = i + 1) begin
							if(playerCardValues[i] == 11) begin
								playerCardValues[i] = 1;
							end
						
						end
					
						// recalculate playerSum
						playerSum = 0;
						for(i = 0; i <= 9; i = i + 1) begin
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

			DEALER_TURN: // 3
			begin
				dealerDisplay = dealerSum;
				
				// check if dealer wins
				if(dealerSum > 21) begin
					// check for aces valued at 11.
					//loop_counter = 0;
					for(i = 0; i <= 9; i = i + 1) begin
						if(dealerCardValues[i] == 11) begin
							dealerCardValues[i] = 1;
							//i = dealerCardNumber + 1; // break
						end
						
						// To avoid ERROR: loop with non-constant loop condition must terminate within 250 iterations 
						//if (loop_counter >= 9) begin
						//	i = 10;
						//end
						//loop_counter = loop_counter + 1;							
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
				else if(dealerSum >= 17) begin // dealer stands on soft 17 (6 with ace)
					state = END_GAME;
				end
				
				
				// Button press
				if (!deal && (dealEdge == 0)) begin // press
					dealEdge = 1; // avoid multiple presses
				
				end
				else if (deal && (dealEdge == 1)) begin // release
					dealEdge = 0; // avoid multiple presses
					
					// DO DEAL LOGIC
					
					if(dealerSum < 17) begin
						
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

			END_GAME: // 4
			begin
			
				playerDisplay = playerSum;
				dealerDisplay = dealerSum;
				
				if(playerSum > 21) begin
					//Player busted. Dealer wins.
					displayState = LOSE;
					//$display("Player busted. Dealer wins.");
				end
				else if (dealerSum > 21) begin
					// Dealer busts! Player wins.
					displayState = WIN;
					//$display("Dealer busts! Player wins.");
				end
				else if (dealerSum == playerSum) begin
					// It's a tie! Push.
					displayState = TIE;
					//$display("It's a tie! Push.");
				end
				else if (playerSum == 21) begin
					if(displayState != BJ) begin
						displayState = WIN;
					end
					// Player has blackjack! Player wins.
					//$display("Player has blackjack! Player wins.");
				end
				else if (dealerSum == 21) begin
					// Dealer has blackjack! Dealer wins.
					displayState = LOSE;
					//$display("Dealer has blackjack! Dealer wins.");
				end
				else if (playerSum > dealerSum) begin
					// Player wins!
					displayState = WIN;
					//$display("Player wins!");
				end
				else begin
					// Dealer wins.
					displayState = LOSE;
					//$display("Dealer wins.");
				end

				
				// Deal button press
				if (!deal && (dealEdge == 0)) begin // press
					dealEdge = 1; // avoid multiple presses
				
				end
				else if (deal && (dealEdge == 1)) begin // release
					dealEdge = 0; // avoid multiple presses
					
					// DO DEAL LOGIC
					deckCardNumber = deckCardNumber + cardNumber + 1;
					displayState = 2'b00;
					state = IDLE;	
				end
				
			end
			default:
				state = IDLE;
		endcase
	 
	end
end

endmodule



