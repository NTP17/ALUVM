//------------------------------------------------------------------------------
// Sequence: alu_sequence
//------------------------------------------------------------------------------
class alu_sequence extends uvm_sequence #(alu_sequence_item);
    `uvm_object_utils(alu_sequence)
    
    function new(string name = "alu_sequence");
        super.new(name);
    endfunction

    virtual task body();
        alu_sequence_item trans;
        // Issue random transactions
        repeat (`RANDOM_RUN_COUNT) begin
            trans = alu_sequence_item::type_id::create("trans");
            if (!trans.randomize()) begin
                `uvm_error("RANDOMIZE", "Failed to randomize transaction")
            end
            start_item(trans);
            finish_item(trans);
        end
    endtask

endclass

//------------------------------------------------------------------------------
// Sequence: alu_add_only_sequence
//------------------------------------------------------------------------------
class alu_add_only_sequence extends alu_sequence;
    `uvm_object_utils(alu_add_only_sequence)
    
    function new(string name = "alu_add_only_sequence");
        super.new(name);
    endfunction

    virtual task body();
        alu_sequence_item trans;
        // Issue random transactions
        repeat (`RANDOM_RUN_COUNT) begin
            trans = alu_sequence_item::type_id::create("trans");
            if (!trans.randomize() with {opcode == 1'b0;}) begin
                `uvm_error("RANDOMIZE", "Failed to randomize transaction")
            end
            start_item(trans);
            finish_item(trans);
        end
    endtask
endclass

//------------------------------------------------------------------------------
// Sequence: alu_subtract_only_sequence
//------------------------------------------------------------------------------
class alu_subtract_only_sequence extends alu_sequence;
    `uvm_object_utils(alu_subtract_only_sequence)
    
    function new(string name = "alu_subtract_only_sequence");
        super.new(name);
    endfunction

    virtual task body();
        alu_sequence_item trans;
        // Issue random transactions
        repeat (`RANDOM_RUN_COUNT) begin
            trans = alu_sequence_item::type_id::create("trans");
            if (!trans.randomize() with {opcode == 1'b1;}) begin
                `uvm_error("RANDOMIZE", "Failed to randomize transaction")
            end
            start_item(trans);
            finish_item(trans);
        end
    endtask
endclass

//------------------------------------------------------------------------------
// Sequence: alu_corner_sequence
//------------------------------------------------------------------------------
class alu_corner_sequence extends alu_sequence;
    `uvm_object_utils(alu_corner_sequence)
    
    function new(string name = "alu_corner_sequence");
        super.new(name);
    endfunction

    virtual task body();
        alu_sequence_item trans;
        bit [7:0] corners[4] = '{8'h00, 8'hFF, 8'h7F, 8'h80};
        foreach (corners[i]) begin
            foreach (corners[j]) begin
                trans = alu_sequence_item::type_id::create("trans");
                trans.a = corners[i];
                trans.b = corners[j];
                trans.opcode = (i + j) % 2;
                start_item(trans);
                finish_item(trans);
            end
        end
    endtask
endclass