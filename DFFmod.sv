module DFFmod(Clock, Reset, Key, Out);

input logic Clock, Reset;
input logic Key;
output logic Out;

logic DFFoutput;
	always_ff @(posedge Clock) begin //first dff
		DFFoutput <= Key;
	end
	always_ff @(posedge Clock) begin //second dff
		Out <= DFFoutput;
	end
endmodule

module DFFmod_testbench();

logic clk, reset;
logic Key;
logic Out;

DFFmod dut (.Clock(clk), .Reset(reset), .Key, .Out);

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
reset <= 0; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0;     Key <= 0 ; @(posedge clk); @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0;     Key <= 1 ; @(posedge clk); @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0;     Key <= 0 ; @(posedge clk); 
                Key <= 1 ; @(posedge clk);
					 Key <= 0 ; @(posedge clk); 
                Key <= 1 ; @(posedge clk); 
reset <= 1; @(posedge clk); // Always reset FSMs at start
@(posedge clk);
@(posedge clk);
@(posedge clk);
$stop; // End the simulation.
end
endmodule
