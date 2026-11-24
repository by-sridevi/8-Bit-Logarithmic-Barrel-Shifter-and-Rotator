
`timescale 1ns / 1ps

// Testbench: 8-Bit Multi-Stage Logarithmic Barrel Shifter and Rotator
// Applies data_in for every operation (LSL, LSR, ASR, ROL, ROR)
// and every shift amount (0 to 7). Each combination is held for 10 ns.

module barrel_shifter_rotator_tb;

    // Inputs
    reg [7:0] data_in;
    reg [2:0] shift_amt;
    reg [2:0] op_sel;

    // Output
    wire [7:0] data_out;

    // Loop variables
    integer i;
    integer j;

    // Operation Encoding Definitions
    localparam LSL = 3'b000;
    localparam LSR = 3'b001;
    localparam ASR = 3'b010;
    localparam ROL = 3'b011;
    localparam ROR = 3'b100;

    // Instantiate the Unit Under Test (UUT)
    barrel_shifter_rotator uut (
        .data_in(data_in),
        .shift_amt(shift_amt),
        .op_sel(op_sel),
        .data_out(data_out)
    );

    // Print every change of inputs and output
    initial begin
        $monitor("Time=%0t ns | op_sel=%b | shift_amt=%0d | data_in=%b | data_out=%b",
                 $time, op_sel, shift_amt, data_in, data_out);
    end

    // Stimulus
    initial begin
        data_in = 8'b01101011;
        shift_amt = 3'b000;
        op_sel = LSL;

        for (i = 0; i < 5; i = i + 1) begin
            op_sel = i;

            for (j = 0; j < 8; j = j + 1) begin
                shift_amt = j;
                #10;
            end
        end

        $finish;
    end

endmodule
