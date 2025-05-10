module FIFO_SVA(FIFO_if.DUT fifoif);
    property no_1;
@(posedge fifoif.clk) !fifoif.rst_n |=> $past(!FIFO.wr_ptr) && $past(!FIFO.rd_ptr) && FIFO.count == 0;
endproperty
property no_2;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) fifoif.wr_en && !fifoif.full |=> fifoif.wr_ack; 
endproperty
property no_3;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) fifoif.wr_en && fifoif.full |=> fifoif.overflow;  
endproperty
property no_4;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) fifoif.rd_en && fifoif.empty |=> fifoif.underflow;
endproperty
property no_5;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) FIFO.count==0 |=> $past(fifoif.empty); 
endproperty
property no_6;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) FIFO.count==fifoif.FIFO_DEPTH |=> $past(fifoif.full);  
endproperty
property no_7;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) FIFO.count==fifoif.FIFO_DEPTH-1 |=> $past(fifoif.almostfull); 
endproperty
property no_8;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) FIFO.count==1 |=> $past(fifoif.almostempty); 
endproperty
property no_9;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) fifoif.wr_en && !fifoif.full && FIFO.wr_ptr==fifoif.FIFO_DEPTH-1 |=> FIFO.wr_ptr==0 ;
endproperty
property no_10;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n)  fifoif.rd_en && !fifoif.empty && FIFO.rd_ptr==fifoif.FIFO_DEPTH-1 |=>  FIFO.rd_ptr==0 ;
endproperty
property no_11;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) FIFO.wr_ptr<=fifoif.FIFO_DEPTH-1 && FIFO.rd_ptr<=fifoif.FIFO_DEPTH-1 && FIFO.count<=fifoif.FIFO_DEPTH ;
endproperty


reset_assert:assert property (no_1);
reset_cover:cover property (no_1);
wr_ack_assert:assert property (no_2);
wr_ack_cover:cover property (no_2);
overflow_assert:assert property (no_3);
overflow_cover:cover property (no_3);
underflow_assert:assert property (no_4);
underflow_cover:cover property (no_4);
empty_assert:assert property (no_5);
empty_cover:cover property (no_5);
full_assert:assert property (no_6);
full_cover:cover property (no_6);
almostfull_assert:assert property (no_7);
almostfull_cover:cover property (no_7);
almostempty_assert:assert property (no_8);
almostempty_cover:cover property (no_8);
wraparound_wr_assert:assert property (no_9);
wraparound_wr_cover:cover property (no_9);
wraparound_rd_assert:assert property (no_10);
wraparound_rd_cover:cover property (no_10);
threshold_assert:assert property (no_11);
threshold_cover:cover property (no_11);
endmodule