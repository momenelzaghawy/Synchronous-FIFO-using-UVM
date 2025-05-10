package FIFO_sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(FIFO_sequence_item)
    
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

rand bit [FIFO_WIDTH-1:0] data_in;
rand bit rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

integer RD_EN_ON_DIST=30,WR_EN_ON_DIST=70;

function new(string name = "FIFO_sequence_item");
        super.new(name);
endfunction

constraint rst_n_const {rst_n dist {0:=2,1:=98};}
constraint wr_en_const {
    wr_en dist{1:=WR_EN_ON_DIST,0:=(100-WR_EN_ON_DIST)};
}
constraint rd_en_const {
    rd_en dist{1:=RD_EN_ON_DIST,0:=(100-RD_EN_ON_DIST)};
}
    function string convert2string();
        return $sformatf("%s rst_n = 0x%0b, wr_en = 0x%0b, rd_en = 0x%0b, data_in = %0h ,data_out = %0h,
        wr_ack=%0b,full=%0b,empty=%0b,overflow=%0b,underflow=%0b,
        almostfull=%0b,almostempty=%0b",super.convert2string(),rst_n,wr_en,rd_en,data_in,data_out,wr_ack,full,
        empty,overflow,underflow,almostfull,almostempty);
    endfunction

    function string convert2string_stimulus();
        return $sformatf("rst_n = 0x%0b, wr_en = 0x%0b, rd_en = 0x%0b, data_in = %0h",rst_n,wr_en,rd_en,data_in);
    endfunction

 
endclass
endpackage