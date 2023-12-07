/*
	Generates a 52 card deck with random order and no duplicates.
	By: Ethan Johnston
*/

// TODO: Try using a 10bit LFSR. Remember to change how the seed is set in controller.

module shuffle(
	input clk,
	input rst, 
	input shuffleFlag, // Set when a shuffle must be executed.
	input [5:0] SEED,
	output reg loadFlag, // Set when a shuffle is complete and module is ready to load cards into main module.
	output reg [5:0] card
);

// Variables
reg seedSet, shuffleComplete;
reg [2:0] loaderCount;
reg [5:0] remainingCount, randomCard, loadCount, lfsr = 6'b101011;
reg [7:0] i;

reg generatedValues [0:51];
reg [5:0] deck [0:51];

wire feedback;


// Create lfsr with feedback polynomial of x^6 + x^5 + 1  
assign feedback = lfsr[6-1] ^ lfsr[5-1];


// Shuffler
always @(posedge clk or posedge rst) begin

	if (rst) begin
		lfsr = 6'b101011; // SEED
		remainingCount = 52;
		shuffleComplete = 0;
		seedSet = 0;
		
		for (i = 0; i <= 51; i = i + 1) begin
			generatedValues[i] = 0; 
		end
		
	end
	else if (remainingCount != 0 && shuffleFlag) begin

		if(seedSet == 0) begin
			lfsr = SEED; // Use SEED for LFSR
			seedSet = 1;
		end
		if (seedSet == 1) begin
		
			lfsr = {lfsr[4:0], feedback};
			randomCard = lfsr % 52;
			
			// Find the next unused value
			for (i = 0; i < 100 && (generatedValues[randomCard] != 0); i = i + 1) begin
				randomCard = (lfsr + i) % 52;
			end
			
			// Mark the value as used
			generatedValues[randomCard] = 1;
			
			// Set current index with the randomly generated value
			deck[remainingCount - 1] = randomCard;
						
			remainingCount = remainingCount - 1;
		end

	end
	else if(remainingCount == 0 && shuffleComplete == 0) begin
		// Used for debugging
		// for (i = 0; i <= 51; i = i + 1) begin
		// 	$display("%d:  %d", i, deck[i]);
		// end
		shuffleComplete = 1;
	end
end


// Implementation of loader
always @(posedge clk or posedge rst) begin
	
	if (rst) begin

		loaderCount = 0;
		loadCount = 52;
		loadFlag = 0;
		
	end
	else if (shuffleComplete == 1 && loadCount != 0) begin
	
		loadFlag = 1; // Initiate loading to main module
		loaderCount = loaderCount + 1;
		
		// only run every 2 clk pulses
		if(loaderCount >= 2) begin
			loaderCount = 0;
			
			card = deck[loadCount - 1];
			loadCount = loadCount - 1;
			
		end
	end
end

endmodule
