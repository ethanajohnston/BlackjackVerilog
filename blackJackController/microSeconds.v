/*
	Creates timeMicro which iterates every micro second.
	By: Ethan Johnston
*/

module microSeconds (
	input clk, rst,
	output reg [31:0] timeMicro // Output time in microSeconds
);

	reg [31:0] counter;    // 32-bit counter

	// Convert the counter to milliseconds
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			counter = 0;
			timeMicro = 0;
		end	 
		else if (counter >= 50) begin // Assuming a 50 MHz clock. FREQUENCY IN MHZ / 1 000 000 = f_per_uS
			timeMicro = timeMicro + 1;
			counter = 0;
		end
		else begin
			counter = counter + 1;
		end
	end

endmodule
