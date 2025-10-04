//------------------------------------------------------------------------------
// UVM Coverage Component: alu_coverage
//------------------------------------------------------------------------------
class alu_coverage extends uvm_component;
    `uvm_component_utils(alu_coverage)

    // Analysis imp to receive transactions
    uvm_analysis_imp#(alu_sequence_item, alu_coverage) cov_imp;

    // Local variables for covergroup sampling
    bit         opcode_v;
    bit [7:0]   a_v;
    bit [7:0]   b_v;
    bit [7:0]   result_v;

    // Functional coverage group
    covergroup cg;
        option.per_instance = 1;

        // Cover each opcode
        cp_opcode: coverpoint opcode_v {
            bins add = {0};
            bins sub = {1};
        }

        // Cover operand values
        cp_a: coverpoint a_v {
            bins low  = {[0:63]};
            bins high = {[64:255]};
        }
        cp_b: coverpoint b_v {
            bins low  = {[0:63]};
            bins high = {[64:255]};
        }

        // Cover result values
        cp_result: coverpoint result_v;

        // Cross coverage: opcode vs result
        cp_op_res_cross: cross cp_opcode, cp_result;
    endgroup

    function new (string name, uvm_component parent);
        super.new(name, parent);
        cov_imp = new("cov_imp", this);
        cg = new();
    endfunction

    // Write method invoked on incoming transactions
    function void write (alu_sequence_item trans);
        // Sample values
        opcode_v = trans.opcode;
        a_v      = trans.a;
        b_v      = trans.b;
        result_v = trans.result;
        cg.sample();
    endfunction
endclass