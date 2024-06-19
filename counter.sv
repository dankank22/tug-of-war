module counter (
    input logic Clock,
    input logic Reset,
    input logic input_signal,
    output logic [6:0] counter
);

    enum {one, two, three, four} ps, ns;

    always_comb begin
        case(ps)

            
            one: begin
                counter <= 7'b1111001; 
                if(input_signal) ns = two;
                else ns = one;
            end
            
            two: begin
                counter <= 7'b0100100; 
                if(input_signal) ns = three;
                else ns = two;
            end
            
            three: begin 
                counter <= 7'b0110000; 
                if(input_signal) ns = four;
                else ns = three; 
            end
            
            four: begin
                counter <= 7'b0011001; 
                if(input_signal) ns = five;
                else ns = four;
            end
            
           
        endcase
    end

    always_ff @(posedge Clock, posedge Reset) begin
        if(Reset)
            ps <= zero;
        else
            ps <= ns;
    end
    
endmodule

module counter_testbench();

logic Clock;
logic Reset;
logic input_signal;
logic [6:0] counter;

counter dut(.Clock, .Reset, .input_signal, .counter);

// Set up a simulated clock.
parameter CLOCK_PERIOD=15;
initial begin
Clock <= 0;
forever #(CLOCK_PERIOD/2) Clock <= ~Clock; // Forever toggle the clock
end
// Set up the inputs to the design. Each line is a clock cycle.
initial begin
@(posedge Clock);
Reset <= 1; @(posedge Clock); // Always reset FSMs at start
Reset <= 0; input_signal <= 1; repeat(8) @(posedge Clock);
@(posedge Clock);
@(posedge Clock);
@(posedge Clock);
$stop; // End the simulation.
end
endmodule

		
