package FIFO_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_sequence_item_pkg::*;

class FIFO_coverage extends uvm_component;
    `uvm_component_utils(FIFO_coverage)
    uvm_analysis_export #(FIFO_sequence_item) cov_export;
    uvm_tlm_analysis_fifo #(FIFO_sequence_item) cov_fifo;
    FIFO_sequence_item seq_item_cov;

     covergroup cg ;
   wr_en_cp:coverpoint seq_item_cov.wr_en;
   rd_en_cp:coverpoint seq_item_cov.rd_en;
   wr_ack_cp:coverpoint seq_item_cov.wr_ack;
   overflow_cp:coverpoint seq_item_cov.overflow;
   underflow_cp:coverpoint seq_item_cov.underflow;
   full_cp:coverpoint seq_item_cov.full;
   almostempty_cp:coverpoint seq_item_cov.almostempty;
   almostfull_cp:coverpoint seq_item_cov.almostfull;
   empty_cp:coverpoint seq_item_cov.empty; 

   cross_1: cross wr_en_cp,rd_en_cp,wr_ack_cp;
   cross_2: cross wr_en_cp,rd_en_cp,overflow_cp;
   cross_3: cross wr_en_cp,rd_en_cp,underflow_cp;
   cross_4: cross wr_en_cp,rd_en_cp,full_cp;
   cross_5: cross wr_en_cp,rd_en_cp,almostempty_cp;
   cross_6: cross wr_en_cp,rd_en_cp,almostfull_cp;
   cross_7: cross wr_en_cp,rd_en_cp,empty_cp;
    endgroup 

    function new(string name = "FIFO_coverage", uvm_component parent = null);
        super.new(name,parent);
        cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export",this);
        cov_fifo = new("cov_fifo",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(seq_item_cov);
            cg.sample();
        end
    endtask
endclass
endpackage