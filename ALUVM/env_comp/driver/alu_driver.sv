//------------------------------------------------------------------------------
// Driver: alu_driver
//------------------------------------------------------------------------------
class alu_driver extends uvm_driver #(alu_sequence_item);
    `uvm_component_utils(alu_driver)
    
    virtual alu_if vif; // Virtual interface handle

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not assigned to driver");
    endfunction

    virtual task run_phase(uvm_phase phase);
        alu_sequence_item trans;
        wait (!vif.reset);
        forever begin
            // Wait one clock cycle for DUT to process the inputs
            @(posedge vif.clock);
            if (!vif.reset)
            uvm_wait_for_nba_region();
            if (!vif.reset) begin
                seq_item_port.get_next_item(trans);
                // Drive the DUT inputs using the virtual interface
                vif.a      <= trans.a;
                vif.b      <= trans.b;
                vif.opcode <= trans.opcode;
                seq_item_port.item_done();
            end
        end
    endtask

endclass