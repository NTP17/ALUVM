//------------------------------------------------------------------------------
// Monitor: alu_monitor
//------------------------------------------------------------------------------
class alu_monitor extends uvm_monitor;
    `uvm_component_utils(alu_monitor)
    
    virtual alu_if vif; // Virtual interface handle
    // Analysis port to send captured transactions to the scoreboard
    uvm_analysis_port#(alu_sequence_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not assigned to monitor");
    endfunction

    virtual task run_phase(uvm_phase phase);
        alu_sequence_item trans;
        wait (!vif.reset);
        forever begin
            @(posedge vif.clock);
            if (!vif.reset)
            uvm_wait_for_nba_region();
            if (!vif.reset) begin
                // Capture the current inputs and DUT output
                trans = alu_sequence_item::type_id::create("trans");
                trans.a      = vif.a;
                trans.b      = vif.b;
                trans.opcode = vif.opcode;
                trans.result = vif.result;
                // Send the transaction to the analysis port
                ap.write(trans);
            end
        end
    endtask

endclass