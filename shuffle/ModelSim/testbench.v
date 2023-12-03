`timescale 1ns / 1ps

module testbench();

  // reg signals provide inputs to the design under test
  reg clk, rst, shuffleFlag;

  // wire signals are used for outputs
  wire [5:0] card;
  wire loadFlag;

  // instantiate the design under test
  dealCard M1 (clk, rst, shuffleFlag, loadFlag, card);

  // clock generation
  initial
    begin
	   rst = 1;
      clk = 0;
		shuffleFlag = 0;
      forever #10 clk = ~clk;
    end

  // assign signal values at various simulation times
	initial
		begin
		
		#50
		 rst = 0;
		 
		#100
		
		shuffleFlag = 1;
		
		#2000
		shuffleFlag = 0;
		#50
		shuffleFlag = 1;

		/*
		#200
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#10
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#50
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#50
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#50
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		
		*/
		end // initial
	endmodule
