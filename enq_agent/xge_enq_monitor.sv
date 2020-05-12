class xge_nq_mon extends uvm_monitor;
	`uvm_componet_utils(xge_nq_mon)
	vxge			vif;
	xge_tx_pkt	tx;
	
	uvm_analysis_port#(xge_tx_pkt)	nq_ap;

	function new(string name="xge_nq_mon", uvm_componet parent);
		super.new(name, parent);
		nq_ap = new("nq_ap",this);
	endfunction

	function void build_phase(uvm_phase phase);
		if (!uvm_config_db#(vif)::get(this,"","xge_ifc",vif)
			`uvm_fatal("MON", "failed to get interface")
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			tx	= xge_tx_pkt::type_id::create("tx",this);
		fork
			begin:  rst
				wait(!vif.reset_156m25_n);
				`uvm_info(get_type_name(),"_Reset_applied",UVM_MEDIUM)
				dq_ap.write(tx);
				nq_ap.write(tx);
				disable rx_dq
				disable tx_nq
				while(!vif.reset_156m25_n);
			end:    rst
			begin:  rx_dq
				wait(vif.cbtxrx.pkt_tx_sop);
				do
					tx.data.push_back(vif.cbtxrx.pkt_tx_data);
				while(!vif.cbtxrx.pkt_tx_eop);
				$cast(tx.mod, vif.cbtxrx.pkt_tx_mod);
			end:    rx_dq
			begin:  tx_nq
			end:    tx_nq
		join_any
		end//4ever
