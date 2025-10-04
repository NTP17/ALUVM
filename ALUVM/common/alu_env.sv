//------------------------------------------------------------------------------
// Environment: alu_env
//------------------------------------------------------------------------------
class alu_env extends uvm_env;
    alu_sequencer  seqr;
    alu_driver     drv;
    alu_monitor    mon;
    alu_scoreboard scb;
    alu_coverage   cov;

    `uvm_component_utils(alu_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = alu_sequencer ::type_id::create("seqr", this);
        drv  = alu_driver    ::type_id::create("drv", this);
        mon  = alu_monitor   ::type_id::create("mon", this);
        scb  = alu_scoreboard::type_id::create("scb", this);
        cov  = alu_coverage  ::type_id::create("cov", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        // Connect the driver's sequencer port to the sequencer's export
        drv.seq_item_port.connect(seqr.seq_item_export);
        // Connect monitor’s analysis port to the scoreboard’s imp port
        mon.ap.connect(scb.sb_imp);
        // Connect monitor to coverage
        mon.ap.connect(cov.cov_imp);
    endfunction

endclass