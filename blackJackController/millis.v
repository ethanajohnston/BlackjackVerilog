

// Set clk period to 20ns in simulation

module millis (
  input clk, rst,
  output reg [31:0] time_ms // Output time in milliseconds
);

  reg [31:0] counter;    // 32-bit counter to measure time

  // Convert the counter to milliseconds
  always @(posedge clk or posedge rst) begin
	 if(rst) begin
		counter = 0;
		time_ms = 0;
	 end	 
	 else if (counter >= 50000000) begin // Assuming a 50 MHz clock for a 1-second period
      time_ms = time_ms + 1;
      counter = 0;
    end
	 else begin
		counter = counter + 1;
	 end
  end

endmodule
