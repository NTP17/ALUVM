//------------------------------------------------------------------------------
// Transaction: alu_sequence_item
//------------------------------------------------------------------------------
class alu_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(alu_sequence_item)
    
    // Randomizable input fields
    randc bit [7:0] a;
    randc bit [7:0] b;
    randc bit       opcode;
    // Captured DUT output
    bit       [7:0] result;

    function new(string name = "alu_sequence_item");
        super.new(name);
    endfunction

endclass