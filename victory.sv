module victory (Clock, Reset, LEDR1, LEDR9, L, R, HEX5, HEX0, leftwin, rightwin);

input logic Clock, Reset;
input logic LEDR1, LEDR9, L, R;
output logic [6:0] HEX5, HEX0;
output logic leftwin, rightwin;

enum {tie, Player1, Player2} ps, ns;

always_comb begin
		case(ps)
			tie:   
			if(LEDR9 & L & ~R & ~LEDR1) ns = Player1; //player 1 is on the left
							
					 else if(LEDR1 & R & ~L & ~LEDR9) ns = Player2; //player 2 is on the right
					
					 else ns = tie;
							
			Player1: ns = Player1;
			
			Player2: ns = Player2;
			
		endcase
end

assign leftwin = (ps == Player1);
assign rightwin = (ps == Player2);

counter c1(.input_signal(leftwin), .counter(HEX5), .Clock, .Reset);
counter c2(.input_signal(rightwin), .counter(HEX0), .Clock, .Reset);


always_ff @(posedge Clock) begin
		if(Reset | leftwin | rightwin)
			ps <= tie;
		else
			ps <= ns;
	end
	
endmodule

module victory_testbench();

logic clk, reset;
logic LEDR1, LEDR9, L, R;
logic [6:0] HEX5, HEX0;

victory dut (.Clock(clk), .Reset(reset), .LEDR1, .LEDR9, .L, .R, .HEX5, .HEX0);

// Set up a simulated clock.
parameter CLOCK_PERIOD=100;
initial begin
clk <= 0;
forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
end
// Set up the inputs to the design. Each line is a clock cycle.
initial begin
@(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; @(posedge clk); L <= 1 ; R <= 0; LEDR1 <= 0; LEDR9 <= 1; @(posedge clk); @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; @(posedge clk); LEDR9 <= 0 ; LEDR1 <= 0; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; @(posedge clk); LEDR1 <= 0 ; R <= 1; @(posedge clk); 
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; @(posedge clk); L <= 0 ; R <= 1; LEDR1 <= 1; LEDR9 <= 0; @(posedge clk); @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; @(posedge clk); LEDR9 <= 1 ; @(posedge clk); 
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; @(posedge clk); LEDR9 <= 0 ; L <= 1; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
@(posedge clk);
@(posedge clk);
@(posedge clk);
$stop; // End the simulation.
end
endmodule

		