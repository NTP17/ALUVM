//------------------------------------------------------------------------------
// DUT: 8-bit ALU (alu8)
//------------------------------------------------------------------------------
module alu8(
    input  logic        clock,
    input  logic        reset,
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    input  logic        opcode, // 0: add, 1: subtract
    output logic [7:0]  result
);
    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            result <= 8'd0;
        else begin
            if (opcode == 1'b0)
                result <= a + b;
            else
                result <= a - b;
        end
    end
endmodule