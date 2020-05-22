class xge_mon extends uvm_monitor;
	`uvm_component_utils(xge_mon)
	vxge		vif;
	xge_pkt	rx,tx;

	uvm_analysis_port#(xge_pkt)	nq_ap;
	uvm_analysis_port#(xge_pkt)	dq_ap;

	function new(string name="xge_mon", uvm_component parent);
		super.new(name, parent);
		nq_ap = new("nq_ap",this);
		dq_ap = new("dq_ap",this);
	endfunction

	function void build_phase(uvm_phase phase);
		if (!uvm_config_db#(vxge)::get(this,"","xge_ifc",vif))
			`uvm_fatal("MON", "failed to get interface")
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			fork
				_run_tx_mon();
				_run_rx_mon();
			join_none
			wait(!vif.reset_156m25_n);
			`uvm_info("_MON","_Reset_applied",UVM_HIGH)
			disable fork;
			dq_ap.write(rx);
			nq_ap.write(tx);
			while(!vif.reset_156m25_n)
				@(vif.cbtxrx);
		end//4ever
	endtask
	task _run_tx_mon();
		forever begin:  tx_nq
			tx	= xge_pkt::type_id::create("tx");
			wait(vif.cbtxrx.pkt_tx_sop);
			do
				@(vif.cbtxrx) tx.data.push_back(vif.pkt_tx_data);
			while(!vif.pkt_tx_eop); 
			$cast(tx.mod, vif.pkt_tx_mod);
			nq_ap.write(tx);
			tx.seq_display();
		end:    tx_nq
	endtask
	task _run_rx_mon();
		forever begin:  rx_dq
			rx	= xge_pkt::type_id::create("rx");
			wait(vif.cbtxrx.pkt_rx_sop);
			while(!vif.cbtxrx.pkt_rx_eop) begin
				rx.data.push_back(vif.cbtxrx.pkt_rx_data);
				@(vif.cbtxrx);
			end
			rx.data.push_back(vif.cbtxrx.pkt_rx_data);
			$cast(rx.mod, vif.cbtxrx.pkt_rx_mod);
			dq_ap.write(rx);
			rx.seq_display();
		end:    rx_dq
	endtask
endclass
