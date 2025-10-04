//------------------------------------------------------------------------------
// Interface: alu_if
//------------------------------------------------------------------------------
interface alu_if(input logic clock);
    logic        reset;
    logic [7:0]  a;
    logic [7:0]  b;
    logic        opcode;
    logic [7:0]  result;
endinterface