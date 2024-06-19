module DE1_SoC (
    input logic CLOCK_50, // 50MHz clock.
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0] LEDR,
    input logic [3:0] KEY, // True when not pressed, False when pressed
    input logic [9:0] SW
);

assign HEX1 = 7'b1111111;
assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;

// Generate clk off of CLOCK_50, whichClock picks rate.
logic Reset;
logic [31:0] div_clk;

parameter whichClock = 15; 
clock_divider cdiv (.clock(CLOCK_50), .reset(SW[9]), .divided_clocks(div_clk));

logic clkSelect;
// Uncomment ONE of the following two lines depending on intention
//assign clkSelect = CLOCK_50; // for simulation
assign clkSelect = div_clk[whichClock]; // for board



logic key0, key3; //right and left logic
logic Dffout0, Dffout3; //output of DFFs

//assign other hex to null values


logic [9:0]lfsr_output;
logic cyberpress;

LFSR_mod l (.Clock(clkSelect), .Reset(SW[9]), .Out(lfsr_output));

comparator comp1 (.a({1'b0,SW[8:0]}), .b(lfsr_output), .out(cyberpress));

DFFmod ff1 (.Clock(clkSelect), .Reset(SW[9]), .Key(~KEY[0]), .Out(Dffout0)); //DFF instance for when key 0 is pressed (right)
DFFmod ff2 (.Clock(clkSelect), .Reset(SW[9]), .Key(~cyberpress), .Out(Dffout3)); //DFF instance for when key 3 is pressed (left)

userInput right (.Clock(clkSelect), .Reset(SW[9]), .Key(Dffout0), .Out(key0)); //setting right logic to dff output
userInput left (.Clock(clkSelect), .Reset(SW[9]), .Key(Dffout3), .Out(key3)); //setting left logic to dff output

//LEDR logic modules 

logic leftwin;
logic rightwin;

normalLight LED1 (.Clock(clkSelect), .Reset(SW[9] | leftwin | rightwin ), .L(key3), .R(key0), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]));
normalLight LED2 (.Clock(clkSelect), .Reset(SW[9] | leftwin | rightwin ), .L(key3), .R(key0), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
normalLight LED3 (.Clock(clkSelect), .Reset(SW[9] | leftwin | rightwin ), .L(key3), .R(key0), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
normalLight LED4 (.Clock(clkSelect), .Reset(SW[9] | leftwin | rightwin ), .L(key3), .R(key0), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
centerLight LED5 (.Clock(clkSelect), .Reset(SW[9] | leftwin | rightwin ), .L(key3), .R(key0), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
normalLight LED6 (.Clock(clkSelect), .Reset(SW[9] | leftwin | rightwin ), .L(key3), .R(key0), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
normalLight LED7 (.Clock(clkSelect), .Reset(SW[9] | leftwin | rightwin ), .L(key3), .R(key0), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
normalLight LED8 (.Clock(clkSelect), .Reset(SW[9] | leftwin | rightwin ), .L(key3), .R(key0), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
normalLight LED9 (.Clock(clkSelect), .Reset(SW[9] | leftwin | rightwin ), .L(key3), .R(key0), .NL(1'b0), .NR(LEDR[8]), .lightOn(LEDR[9]));
	 


victory winCond (.Clock(clkSelect), .Reset(SW[9]), .LEDR1(LEDR[1]), .LEDR9(LEDR[9]), .L(key3), .R(key0), .HEX5, .HEX0, .leftwin, .rightwin);

endmodule

module DE1_SoC_testbench();
    logic CLOCK_50; // 50MHz clock.
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0] LEDR;
    logic [3:0] KEY; // True when not pressed, False when pressed
    logic [9:0] SW;

    DE1_SoC dut(.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

    // Set up a simulated clock.
    parameter CLOCK_PERIOD=100;
    initial begin
        CLOCK_50 <= 0;
        forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
    end

    // Set up the inputs to the design. Each line is a clock cycle.
    initial begin
        @(posedge CLOCK_50);
        SW[9] <= 1; @(posedge CLOCK_50); // Always reset FSMs at start
        SW[9] <= 0;  SW[8:0]='1; KEY[0] <= 0;
		  repeat (100) @(posedge CLOCK_50);
        
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
		  SW[8:0]='0; KEY[0] <= 0;
		  repeat (100) @(posedge CLOCK_50);
        $stop; // End the simulation.
    end
endmodule
