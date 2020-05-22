class xge_drv extends uvm_driver#(xge_pkt);
	`uvm_component_utils(xge_drv)
	vxge      vif;
	xge_pkt   req;

	function new(string name="xge_drv", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if (!uvm_config_db#(vxge)::get(this,"","xge_ifc",vif))
			`uvm_fatal("_DRV", "failed to get interface")
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			fork
				_run_tx();
				_run_rx();
			join_none
			wait(!vif.reset_156m25_n);
			`uvm_info("_DRV","_Reset_applied",UVM_HIGH)
			disable fork;
			while(!vif.reset_156m25_n)
				@(vif.cbtxrx);
		end
	endtask
	task _run_tx();
		forever begin:  tx
			wait(!vif.pkt_tx_full && vif.reset_156m25_n);
			seq_item_port.get_next_item(req);
			req.seq_display();
			vif.cbtxrx.pkt_tx_val <= 'b1;
			foreach(req.data[i])begin
				vif.cbtxrx.pkt_tx_data <= req.data[i];
				if(i==0) vif.cbtxrx.pkt_tx_sop <= 'b1;
				else vif.cbtxrx.pkt_tx_sop <= 'b0;
				if(i==(req.data.size-1))begin
					vif.cbtxrx.pkt_tx_eop <= 'b1;
					vif.cbtxrx.pkt_tx_mod <= req.mod;
				end else begin
					vif.cbtxrx.pkt_tx_eop <= 'b0;
					vif.cbtxrx.pkt_tx_mod <= 'b0;
				end
				@(vif.cbtxrx);
			end
			seq_item_port.item_done(req);
			vif.cbtxrx.pkt_tx_sop <=   'b0;
			vif.cbtxrx.pkt_tx_val <=   'b0;
			vif.cbtxrx.pkt_tx_eop <=   'b0;
			vif.cbtxrx.pkt_tx_mod <=   'b0;
			vif.cbtxrx.pkt_tx_data <=  'b0;
		end:    tx
	endtask
	task _run_rx();
		forever begin:  rx
			wait(vif.reset_156m25_n);
			wait(vif.cbtxrx.pkt_rx_avail);
			vif.cbtxrx.pkt_rx_ren <= 'b1;
				@(vif.cbtxrx);
			wait(vif.cbtxrx.pkt_rx_eop);
			vif.cbtxrx.pkt_rx_ren <= 'b0;
		end:    rx
	endtask
endclass
