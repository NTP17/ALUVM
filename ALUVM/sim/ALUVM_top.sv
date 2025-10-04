//------------------------------------------------------------------------------
// Top-Level Testbench Module: ALUVM_top
//------------------------------------------------------------------------------
module ALUVM_top;
    // Clock and reset signals
    logic clock;
    // Instantiate the interface (the reset and data signals are inside the interface)
    alu_if alu_vif(clock);

    // Connect the DUT to the interface signals
    alu8 dut (
        .clock   (clock),
        .reset   (alu_vif.reset),
        .a       (alu_vif.a),
        .b       (alu_vif.b),
        .opcode  (alu_vif.opcode),
        .result  (alu_vif.result)
    );

    // Connect assertion module
    alu_assertions alu_assert (
        .clock   (clock),
        .reset   (alu_vif.reset),
        .a       (alu_vif.a),
        .b       (alu_vif.b),
        .opcode  (alu_vif.opcode),
        .result  (alu_vif.result)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
  
    // Clock generation (10 ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    // Reset generation: assert reset for 1 ns then de-assert
    initial begin
        alu_vif.reset = 1;
        #1;
        alu_vif.reset = 0;
    end

    // Set the virtual interface in the UVM configuration database globally
    initial begin
        uvm_config_db#(virtual alu_if)::set(null, "*", "vif", alu_vif);
    end

    // Start the UVM run-time
    initial begin
        run_test();
    end
endmodule