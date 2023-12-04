
/*
	Generates a 52 card deck with random order.
	By: Ethan Johnston B00828763
*/

module shuffle(
	input clk,
	input rst, 
	input shuffleFlag, // Set when a shuffle must be executed.
	output reg loadFlag, // Set when a shuffle is complete and module is ready to load cards into main module.
	output reg [5:0] card);

	reg [5:0] deck [0:51];
	reg [5:0] remaining_count;

	integer i, shuffleComplete, n, loadCount, loop_counter;
	reg [5:0] randomCard;

	reg [5:0] lfsr;
	wire feedback;
	
	reg generated_values [0:51];

	// Create lfsr with feedback polynomial of x^6 + x^5 + 1  
	assign feedback = lfsr[6-1] ^ lfsr[5-1];

	
	always @(posedge clk or posedge rst) begin
	
		if (rst) begin
			lfsr = 6'b011110; // SEED
			remaining_count = 52;
			shuffleComplete = 0;
			
			for (i = 0; i <= 51; i = i + 1) begin
			
				generated_values[i] = 0; 
				
			end
			
		end
		else if (remaining_count != 0 && shuffleFlag) begin
			
			lfsr = {lfsr[4:0], feedback};
			randomCard = lfsr % 52;

			// Find the next unused value
			loop_counter = 0;
			for (i = 0; i < 250; i = i + 1) begin
			  randomCard = (lfsr + i) % 52;
			  if (generated_values[randomCard] == 0) begin
				 i = 250; // Exit the loop if an unused value is found
			  end
			  
			  // To avoid ERROR: loop with non-constant loop condition must terminate within 250 iterations 
			  if (loop_counter >= 240) begin
					i = 250;
			  end
			  loop_counter = loop_counter + 1;
			end

			// Mark the value as used
			generated_values[randomCard] = 1;
			
			// Set current index with the randomly generated value
			deck[remaining_count - 1] = randomCard;
						
			remaining_count = remaining_count - 1;
			
		end
		else if(remaining_count == 0 && shuffleComplete == 0) begin
		
			for (i = 0; i <= 51; i = i + 1) begin
			
				$display("%d:  %d", i, deck[i]);
				
			end
			
			shuffleComplete = 1;
		
		end
	end
  
  
  
	// Declare a counter variable
	reg [2:0] cnt;


  
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
