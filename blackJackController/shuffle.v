
/*
	Generates a 52 card deck with random order.
	By: Ethan Johnston B00828763
*/

module shuffle(
	input clk,
	input rst, 
	input shuffleFlag,
	output loadFlag,
	output reg [5:0] card);

	reg [5:0] deck [0:51];
	reg [5:0] remaining_count;

	integer i, k, n, dealCount;
	reg [5:0] randomCard;

	reg [5:0] lfsr;
	reg feedback;
	
	reg generated_values [0:51];

	// Create lfsr with feedback polynomial of x^6 + x^5 + 1  
	assign feedback = lfsr[6-1] ^ lfsr[5-1];

	
	always @(posedge clk or posedge rst) begin
	
		if (rst) begin
		 
			lfsr = 6'b011110; // SEED
			remaining_count = 52;
			k = 0;
			
			for (i = 0; i <= 51; i = i + 1) begin
			
				generated_values[i] = 0; 
				
			end
			
		end
		else if (remaining_count > 0) begin			
			
			lfsr <= {lfsr[4:0], feedback};
			randomCard = lfsr % 52;

			// Find the next unused value
			
			for (i = 0; i < 200; i = i + 1) begin
			  randomCard = (lfsr + i) % 52;
			  if (generated_values[randomCard] == 0) begin
				 i = 200; // Exit the loop if an unused value is found
			  end
			end

			// Mark the value as used
			generated_values[randomCard] = 1;
			
			// Set current index with the randomly generated value
			deck[remaining_count - 1] = randomCard;
						
			remaining_count = remaining_count - 1;
			
		end
		else if(remaining_count == 0 && k == 0) begin
		
			for (i = 0; i < 52; i = i + 1) begin
			
				$display("%d:  %d", i, deck[i]);
				
			end
			
			k = 1;
		
		end
	end
  
  
  /*
  
  // Change card output port to value of next card in shuffled deck when flag input port is toggled.
	always @(posedge dealFlag or posedge rst) begin
	
		if (rst) begin
		
			dealCount = 0;
			
		end
		else if (k == 1) begin
			
			// Set card output port to next card in shuffled deck
			card = deck[dealCount];
			
			// Set cardValue output port to next card in shuffled decks value in blackjack.
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
			
			
			//$display("%d ->  %d", dealCount, card);
			dealCount = dealCount + 1;
			
		end
	end

	*/
endmodule
