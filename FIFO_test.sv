package FIFO_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_env_pkg::*;
import FIFO_reset_sequence_pkg::*;
import FIFO_write_sequence_pkg::*;
import FIFO_read_sequence_pkg::*;
import FIFO_write_read_sequence_pkg::*;
import FIFO_config_pkg::*;
 
class FIFO_test extends uvm_test;
    `uvm_component_utils(FIFO_test)
    virtual FIFO_if FIFO_vif;
    FIFO_env env;
    FIFO_write_sequence write_seq;
    FIFO_read_sequence read_seq;
    FIFO_write_read_sequence write_read_seq;
    FIFO_reset_sequence reset_seq;
    FIFO_config FIFO_cfg;

    function new(string name = "FIFO_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = FIFO_env::type_id::create("env",this);
        FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg",this);
        write_seq = FIFO_write_sequence::type_id::create("write_seq",this);
        read_seq = FIFO_read_sequence::type_id::create("read_seq",this);
        write_read_seq = FIFO_write_read_sequence::type_id::create("write_read_seq",this);
        reset_seq = FIFO_reset_sequence::type_id::create("reset_seq",this);

        if(!uvm_config_db #(virtual FIFO_if)::get(this, "","FIFO_IF",FIFO_cfg.FIFO_vif))
            `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the FIFO from the uvm_config_db")

        uvm_config_db #(FIFO_config)::set(this, "*","CFG",FIFO_cfg);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        `uvm_info("run_phase", "Reset_Assertion", UVM_LOW)
        reset_seq.start(env.agt.sqr);

        `uvm_info("run_phase", "Reset_Deassertion", UVM_LOW)
        `uvm_info("run_phase", "Stimulus Generation Started_1", UVM_LOW)
        write_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "Stimulus Generation Ended_1", UVM_LOW)

        `uvm_info("run_phase", "Stimulus Generation Started_2", UVM_LOW)
        read_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "Stimulus Generation Ended_2", UVM_LOW)

        `uvm_info("run_phase", "Stimulus Generation Started_3", UVM_LOW)
        write_read_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "Stimulus Generation Ended_3", UVM_LOW)

        `uvm_info("run_phase", "Reset_Assertion", UVM_LOW)
        reset_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "Reset_Deassertion", UVM_LOW)

        phase.drop_objection(this);
    endtask
endclass
endpackage