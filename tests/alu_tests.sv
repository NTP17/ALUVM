//------------------------------------------------------------------------------
// Test: alu_test
//------------------------------------------------------------------------------
class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)
    
    alu_env      env;
    alu_sequence seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = alu_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq = alu_sequence::type_id::create("seq");
        // Start the sequence on the sequencer (not the driver)
        seq.start(env.seqr);
        phase.drop_objection(this);
    endtask

endclass

//------------------------------------------------------------------------------
// Test: alu_add_only_test
//------------------------------------------------------------------------------
class alu_add_only_test extends alu_test;
    `uvm_component_utils(alu_add_only_test)

    alu_add_only_sequence seq;

    function new(string name = "alu_add_only_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
   
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq = alu_add_only_sequence::type_id::create("seq");
        seq.start(env.seqr);
        phase.drop_objection(this);
    endtask
endclass

//------------------------------------------------------------------------------
// Test: alu_subtract_only_test
//------------------------------------------------------------------------------
class alu_subtract_only_test extends alu_test;
    `uvm_component_utils(alu_subtract_only_test)

    alu_subtract_only_sequence seq;

    function new(string name = "alu_subtract_only_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
   
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq = alu_subtract_only_sequence::type_id::create("seq");
        seq.start(env.seqr);
        phase.drop_objection(this);
    endtask
endclass

//------------------------------------------------------------------------------
// Test: alu_corner_test
//------------------------------------------------------------------------------
class alu_corner_test extends alu_test;
    `uvm_component_utils(alu_corner_test)

    alu_corner_sequence seq;

    function new(string name = "alu_corner_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
   
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq = alu_corner_sequence::type_id::create("seq");
        seq.start(env.seqr);
        phase.drop_objection(this);
    endtask
endclass

//------------------------------------------------------------------------------
// Test: alu_random_reset_test
//------------------------------------------------------------------------------
class alu_random_reset_test extends alu_test;
    `uvm_component_utils(alu_random_reset_test)

    virtual interface alu_if vitf;

    function new(string name = "alu_random_reset_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!(uvm_config_db #(virtual alu_if)::get(this, "*", "vif", vitf))) begin
            `uvm_fatal(get_type_name(), "Unable to get any ALU interface")
        end
    endfunction

    task random_reset();
        repeat (`RANDOM_RUN_COUNT) begin
            @(posedge vitf.clock);
            if ($urandom_range(1, 9) == 5) begin
                #($urandom_range(1, 10));
                vitf.reset <= 1;
                #($urandom_range(1, 10));
                vitf.reset <= 0;
            end
        end
    endtask

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        fork
            begin
                seq = alu_sequence::type_id::create("seq");
                seq.start(env.seqr);
            end
            begin
                random_reset();
            end
        join
        phase.drop_objection(this);
    endtask
endclass