//------------------------------------------------------------------------------
// External Assertion Module for alu8
//------------------------------------------------------------------------------
module alu_assertions (
    input logic        clock,
    input logic        reset,
    input logic [7:0]  a,
    input logic [7:0]  b,
    input logic        opcode,
    input logic [7:0]  result
);
    // Addition property
    property p_add_ext;
        @(posedge clock) disable iff(reset||$test$plusargs("UVM_TESTNAME=alu_random_reset_test")) (opcode == 1'b0) |=> (result == $past(a) + $past(b));
    endproperty

    // Subtraction property
    property p_sub_ext;
        @(posedge clock) disable iff(reset||$test$plusargs("UVM_TESTNAME=alu_random_reset_test")) (opcode == 1'b1) |=> (result == $past(a) - $past(b));
    endproperty
    
    assert property (p_add_ext) else
        `uvm_error("ALU_ASSERT", $sformatf("external ADD: a=%0h + b=%0h != result=%0h", a, b, result));
    
    assert property (p_sub_ext) else
        `uvm_error("ALU_ASSERT", $sformatf("external SUB: a=%0h - b=%0h != result=%0h", a, b, result));
endmodule