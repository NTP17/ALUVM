//------------------------------------------------------------------------------
// Scoreboard: alu_scoreboard
//------------------------------------------------------------------------------
class alu_scoreboard extends uvm_component;
    `uvm_component_utils(alu_scoreboard)
    
    // Use an analysis imp to receive transactions
    uvm_analysis_imp#(alu_sequence_item, alu_scoreboard) sb_imp;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        sb_imp = new("sb_imp", this);
    endfunction

    // This method will be called when a transaction is received.
    virtual function void write(alu_sequence_item trans);
        bit [7:0] expected;
        if(trans.opcode == 1'b0)
            expected = trans.a + trans.b;
        else
            expected = trans.a - trans.b;
        if (expected !== trans.result)
            `uvm_error("ALU_SCB", $sformatf("Mismatch: a=%0h, b=%0h, opcode=%0b, expected=%0h, got=%0h", trans.a, trans.b, trans.opcode, expected, trans.result))
        else
            `uvm_info("ALU_SCB", $sformatf("Match: a=%0h, b=%0h, opcode=%0b, result=%0h", trans.a, trans.b, trans.opcode, trans.result), UVM_LOW);
    endfunction

endclass