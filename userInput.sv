module userInput(Out, Clock, Reset, Key);

input logic Key, Clock, Reset;
output logic Out;

enum { onState, offState} ps, ns;
// ns logic
always_comb begin
case (ps)
    onState: begin
          if (Key) //if key is pressed, state is same
               ns = onState;
          else 
			      ns = offState;   //else change to off
      end
	 offState: begin
	       if (Key) //if key is pressed, state changes to on
			      ns = onState;
			 else 
			      ns = offState;  //else stay in same state
		end
    
endcase
end

assign Out = (ps == onState) && (Key);
	
	always_ff @(posedge Clock) begin
		if(Reset) //stay in off state for reset
			ps <= offState;
		else
			ps <= ns;
	end
endmodule

module userInput_testbench();

logic Key, clk, reset;
logic Out;

userInput dut (.Out, .Clock(clk), .Reset(reset), .Key);

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
reset <= 0; Key <= 0; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; Key <= 1; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; Key <= 0; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; Key <= 1; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; Key <= 0; @(posedge clk);
reset <= 1; @(posedge clk); // Always reset FSMs at start
reset <= 0; Key <= 1; @(posedge clk);


@(posedge clk);
@(posedge clk);
@(posedge clk);
$stop; // End the simulation.
end
endmodule

