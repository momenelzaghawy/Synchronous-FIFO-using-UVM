package FIFO_write_read_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_sequence_item_pkg::*;

class FIFO_write_read_sequence extends uvm_sequence #(FIFO_sequence_item);
    `uvm_object_utils(FIFO_write_read_sequence)
    FIFO_sequence_item seq_item;

    function new(string name = "FIFO_write_read_sequence");
        super.new(name);
    endfunction

    task body;
        seq_item = FIFO_sequence_item::type_id::create("seq_item");
        repeat(1000) begin
            start_item(seq_item);
            seq_item.randomize(rst_n);
            seq_item.wr_en=1;
            seq_item.rd_en=1;
            seq_item.randomize(data_in);
            finish_item(seq_item);
        end
    endtask
endclass
endpackage