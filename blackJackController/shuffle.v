
/*
	Generates a 52 card deck with random order.
	By: Ethan Johnston B00828763
*/

// TODO: Try using a 10bit LFSR. remember to change how the seed is set in controller.


module shuffle(
	input clk,
	input rst, 
	input shuffleFlag, // Set when a shuffle must be executed.
	input [5:0] SEED,
	output reg loadFlag, // Set when a shuffle is complete and module is ready to load cards into main module.
	output reg [5:0] card);

	reg [5:0] deck [0:51];
	reg [5:0] remaining_count;

	integer i, shuffleComplete, n, loadCount, loop_counter;
	reg [5:0] randomCard;

	reg [5:0] lfsr = 6'b101011;
	wire feedback;
	
	reg seedSet;
	reg generated_values [0:51];

	// Declare a counter variable
	reg [2:0] cnt;
	
	
	// Create lfsr with feedback polynomial of x^16 + x^15 + x^13 + x^4 + 1
	//assign feedback = lfsr[16-1] ^ lfsr[15-1] ^ lfsr[13-1] ^ lfsr[4-1];

	// Create lfsr with feedback polynomial of x^6 + x^5 + 1  
	assign feedback = lfsr[6-1] ^ lfsr[5-1];
	
	// shuffler
	always @(posedge clk or posedge rst) begin
	
		if (rst) begin
			lfsr = 6'b101011; // SEED
			remaining_count = 52;
			shuffleComplete = 0;
			seedSet = 0;
			
			for (i = 0; i <= 51; i = i + 1) begin
			
				generated_values[i] = 0; 
				
			end
			
		end
		else if (remaining_count != 0 && shuffleFlag) begin
			if(seedSet == 0) begin
				lfsr = SEED;
				$display("SEED: %d,  LFSR: %d", SEED, lfsr);
				seedSet = 1;
			end
			if (seedSet == 1) begin
			
				lfsr = {lfsr[4:0], feedback};
				randomCard = lfsr % 52;
				
				$display("randInitial: %d, %d", randomCard, lfsr);

				
				// Find the next unused value
				for (i = 0; i < 100 && (generated_values[randomCard] != 0); i = i + 1) begin
					randomCard = (lfsr + i) % 52;
				end
				
				$display("randFinal:   %d, i: %d", randomCard, i);

				// Mark the value as used
				generated_values[randomCard] = 1;
				
				// Set current index with the randomly generated value
				deck[remaining_count - 1] = randomCard;
							
				remaining_count = remaining_count - 1;
			end

		end
		else if(remaining_count == 0 && shuffleComplete == 0) begin
		
			for (i = 0; i <= 51; i = i + 1) begin
			
				$display("%d:  %d", i, deck[i]);
				
			end
			
			shuffleComplete = 1;
		
		end
	end
  
    


  // Implementation of loader
	always @(posedge clk or posedge rst) begin
		
		if (rst) begin
			cnt = 0;
			loadCount = 52;
			loadFlag = 0;
			
		end
		else if (shuffleComplete == 1 && loadCount != 0) begin
		
			loadFlag = 1; // Initiate loading to main module
			cnt = cnt + 1;
			
			// only run every 4 clk pulses
			if(cnt >= 2) begin
				cnt = 0;
				
				card = deck[loadCount - 1];
				loadCount = loadCount - 1;
				
			end
		end
	end


endmodule
