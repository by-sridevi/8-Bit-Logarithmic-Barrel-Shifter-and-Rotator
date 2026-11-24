
`timescale 1ns / 1ps

// Project: 8-Bit Multi-Stage Logarithmic Barrel Shifter and Rotator
// Tool: Vivado (Verilog on FPGA)
// Description: Single-cycle combinational design using a logarithmic MUX chain.
// Supports LSL, LSR, ASR, ROL, and ROR operations via a 3-bit amount.

module barrel_shifter_rotator (
    input wire [7:0] data_in,
    input wire [2:0] shift_amt,
    input wire [2:0] op_sel,
    output reg [7:0] data_out
);

    // Operation Encoding Definitions
    localparam LSL = 3'b000;  // Logical Shift Left
    localparam LSR = 3'b001;  // Logical Shift Right
    localparam ASR = 3'b010;  // Arithmetic Shift Right
    localparam ROL = 3'b011;  // Rotate Left
    localparam ROR = 3'b100;  // Rotate Right

    // Internal signals for preprocessing and postprocessing
    reg [7:0] pre_processed;
    reg fill_bit;

    // Logarithmic stage wires
    wire [7:0] stage1;
    wire [7:0] stage2;
    wire [7:0] stage3;

    // STEP 1: INPUT NORMALIZATION (Pre-processing)
    // Left shifts/rotates are treated as reversed right shifts/rotates
    always @(*) begin
        case (op_sel)
            LSL, ROL: begin
                // Reverse bits for left operations
                // to reuse the right-shift core
                pre_processed = {
                    data_in[0], data_in[1],
                    data_in[2], data_in[3],
                    data_in[4], data_in[5],
                    data_in[6], data_in[7]
                };
            end

            default: begin
                // Keep original orientation for right operations
                pre_processed = data_in;
            end
        endcase
    end

    // Determine padding/fill bit for Arithmetic Right Shift (ASR)
    always @(*) begin
        if (op_sel == ASR)
            fill_bit = data_in[7];  // Sign bit
        else
            fill_bit = 1'b0;
    end

    // STEP 2: LOGARITHMIC MULTIPLEXER CHAIN (Right Core)

    // Stage 1: Conditional Right Shift/Rotate by 1 bit
    assign stage1 = (shift_amt[0]) ?
        ((op_sel == ROL || op_sel == ROR) ?
            {pre_processed[0], pre_processed[7:1]} :
            {fill_bit, pre_processed[7:1]})
        : pre_processed;

    // Stage 2: Conditional Right Shift/Rotate by 2 bits
    assign stage2 = (shift_amt[1]) ?
        ((op_sel == ROL || op_sel == ROR) ?
            {stage1[1:0], stage1[7:2]} :
            {{2{fill_bit}}, stage1[7:2]})
        : stage1;

    // Stage 3: Conditional Right Shift/Rotate by 4 bits
    assign stage3 = (shift_amt[2]) ?
        ((op_sel == ROL || op_sel == ROR) ?
            {stage2[3:0], stage2[7:4]} :
            {{4{fill_bit}}, stage2[7:4]})
        : stage2;

    // STEP 3: OUTPUT DENORMALIZATION (Post-processing)
    always @(*) begin
        case (op_sel)
            LSL, ROL: begin
                // Reverse output back to original order
                // for left operations
                data_out = {
                    stage3[0], stage3[1],
                    stage3[2], stage3[3],
                    stage3[4], stage3[5],
                    stage3[6], stage3[7]
                };
            end

            default: begin
                data_out = stage3;
            end
        endcase
    end

endmodule
