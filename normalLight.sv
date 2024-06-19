module normalLight (Clock, Reset, L, R, NL, NR, lightOn);
input logic Clock, Reset;
input logic L, R, NL, NR;
output logic lightOn;
// L is true when left key is pressed, R is true when the right key
// is pressed, NL is true when the light on the left is on, and NR
// is true when the light on the right is on.
enum { onState, offState} ps, ns;
// ns logic
always_comb begin
case (ps)
    onState: begin
	 lightOn = 1;
          if ((L & ~R)|(R & ~L))  //if only left or only right button is pressed
               ns = offState;
          else 
			      ns = onState;   //stay in same on state otherwise
	 end
	 offState: begin
	 lightOn = 0;
	       if ((NL & R & ~L & ~NR)|(NR & L & ~R & ~NL)) //if neighbouring lights are on and left and right is pressed, center light turns on
			      ns = onState;
			 else 
			      ns = offState;  //stay in same off state oherwise
	 end
endcase
end

//when reset, make normal light turn off
always_ff @(posedge 	Clock) begin
if (Reset)
ps <= offState;
else
ps <= ns;
end
endmodule

module normalLight_testbench();
logic clk, reset;
logic L, R, NL, NR;
logic lightOn;

normalLight dut(.Clock(clk), .Reset(reset), .L, .R, .NL, .NR, .lightOn);

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
reset <= 0;     L <= 1 ; R <= 0; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0;     L <= 0 ; R <= 1; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0;     
L <= 0 ; R <= 1; @(posedge clk);
NR <= 1 ; NL <= 0; R <= 0; L <= 1; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0;    
L <= 0 ; R <= 1; @(posedge clk); NL <= 1 ; NR <= 0; R <= 1; L <= 0; @(posedge clk);               
@(posedge clk);
@(posedge clk);
@(posedge clk);
$stop; // End the simulation.
end
endmodule
