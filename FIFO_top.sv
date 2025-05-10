import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_pkg::*;

module FIFO_top();
    bit clk;
    
    initial begin
        forever
            #1 clk = ~clk;
    end
    
    FIFO_if fifoif(clk);
    FIFO DUT(fifoif);
    bind FIFO FIFO_SVA FIFO_SVA_inst(fifoif);
    
    initial begin
        uvm_config_db#(virtual FIFO_if)::set(null,"uvm_test_top","FIFO_IF",fifoif);
        run_test("FIFO_test");
    end
endmodule