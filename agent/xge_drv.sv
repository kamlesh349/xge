class xge_drv extends uvm_driver;
	`uvm_component_utils(xge_drv)
	vxge vif;

	function new(string name="xge_drv", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if (!uvm_config_db#(vif)::get(this,"","xge_ifc",vif)
			`uvm_fatal("DRV", "failed to get interface")
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
		fork
			begin:  tx
				seq_item_port.get_next_item(req);
				vif.cbtxrx.pkt_tx_val = 'b0;
				wait(!vif.pkt_tx_full);
				vif.cbtxrx.pkt_tx_val = 'b1;
				vif.cbtxrx.pkt_tx_sop = 'b1;
				vif.cbtxrx.pkt_tx_eop = 'b0;
				vif.cbtxrx.pkt_tx_mod = 'b0;
				req.data.pop_front(vif.cbtxrx.pkt_tx_data);
				@(cbtxrx);
				vif.cbtxrx.pkt_tx_sop = 'b0;
				while(req.data.size != 1)begin
					req.data.pop_front(vif.cbtxrx.pkt_tx_data);
					@(cbtxrx);
				end
				vif.cbtxrx.pkt_tx_eop = 'b1;
				vif.cbtxrx.pkt_tx_mod = req.mod;
				req.data.pop_front(vif.cbtxrx.pkt_tx_data);
			end:    tx
			begin:  rx
				wait(vif.cbtxrx.pkt_rx_avail);
				vif.cbtxrx.pkt_rx_ren = 'b1;
				wait(vif.cbtxrx.pkt_rx_eop);
				vif.cbtxrx.pkt_rx_ren = 'b0;
			end:    rx
			begin:  rst
				wait(!vif.reset_156m25_n);
				`uvm_info("DRV","_Reset_applied",UVM_MEDIUM)
				disable rx
				disable tx
				while(!vif.reset_156m25_n);
			end:    rst
		join_any
		end
	endtask
endclass
