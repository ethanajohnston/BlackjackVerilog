
// Set clk period to 20ns in simulation

module microSeconds (
	input clk, rst,
	output reg [31:0] time_micro // Output time in microSeconds
);

	reg [31:0] counter;    // 32-bit counter to measure time

	// Convert the counter to milliseconds
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			counter = 0;
			time_micro = 0;
		end	 
		else if (counter >= 10) begin // Assuming a 10 MHz clock for a 1-second period. FREQUENCY IN MHZ / 1 000 000 = f_per_uS
			time_micro = time_micro + 1;
			counter = 0;
		end
		else begin
			counter = counter + 1;
		end
	end

endmodule
