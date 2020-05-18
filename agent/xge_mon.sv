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
			tx	= xge_pkt::type_id::create("tx",this);
			rx	= xge_pkt::type_id::create("rx",this);
		fork
			begin:  rst
				wait(!vif.reset_156m25_n);
				`uvm_info(get_type_name(),"_Reset_applied",UVM_MEDIUM)
				dq_ap.write(rx);
				nq_ap.write(tx);
				disable rx_dq;
				disable tx_nq;
				while(!vif.reset_156m25_n)
					@(vif.cbtxrx);
			end:    rst
			begin:  tx_nq
				wait(vif.pkt_tx_sop);
				do begin
					tx.data.push_back(vif.pkt_tx_data);
					@(vif.cbtxrx);
				end while(!vif.pkt_tx_eop);
				tx.data.push_back(vif.pkt_tx_data);
				$cast(tx.mod, vif.pkt_tx_mod);
			end:    tx_nq
			begin:  rx_dq
				wait(vif.cbtxrx.pkt_rx_sop);
				do begin
					rx.data.push_back(vif.cbtxrx.pkt_rx_data);
					@(vif.cbtxrx);
				end while(!vif.cbtxrx.pkt_rx_eop);
				rx.data.push_back(vif.cbtxrx.pkt_rx_data);
				$cast(rx.mod, vif.cbtxrx.pkt_rx_mod);
			end:    rx_dq
		join_any
		end//4ever
	endtask
endclass
