package FIFO_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_sequence_item_pkg::*;

class FIFO_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(FIFO_scoreboard)
    uvm_analysis_export #(FIFO_sequence_item) sb_export;
    uvm_tlm_analysis_fifo #(FIFO_sequence_item) sb_fifo;
    FIFO_sequence_item seq_item_sb;

    int error_count = 0;
    int correct_count = 0;

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic [FIFO_WIDTH-1:0] data_out_ref;
logic [FIFO_WIDTH-1:0] fifo_queue [$];
int count_fifo =0;

   function new(string name = "FIFO_scoreboard", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo = new("sb_fifo",this);
    endfunction
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

     task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_sb);
            reference_model(seq_item_sb);
            #2;
            if((seq_item_sb.data_out != data_out_ref)) begin
                `uvm_error("run_phase", $sformatf("comparison failed, transaction received by the DUT: %s while the reference out: %0d",seq_item_sb.convert2string(),data_out_ref));
                error_count++;
            end
            else begin
                `uvm_info("run_phase", $sformatf("correct FIFO out: %s",seq_item_sb.convert2string()), UVM_HIGH)
                correct_count++;
            end
        end
    endtask

function void reference_model(input FIFO_sequence_item seq_item_sb);
if(!seq_item_sb.rst_n) begin
    fifo_queue <= {};
    count_fifo <= 0 ;
end
else begin
    if (seq_item_sb.wr_en && count_fifo < FIFO_DEPTH) begin
        fifo_queue.push_back(seq_item_sb.data_in);
        count_fifo <= fifo_queue.size();
    end
    if (seq_item_sb.rd_en && count_fifo!=0) begin
        data_out_ref <= fifo_queue.pop_front();
        count_fifo <= fifo_queue.size();
    end
end   
endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase", $sformatf("total successful transaction: %0d",correct_count), UVM_MEDIUM)
        `uvm_info("report_phase", $sformatf("total failed transaction: %0d",error_count), UVM_MEDIUM)
    endfunction
endclass
endpackage