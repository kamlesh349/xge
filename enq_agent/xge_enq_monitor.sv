class xge_enq_mon extends uvm_monitor;
	`uvm_componet_utils(xge_enq_mon)
	vxge			vif;
	xge_tx_pkt	tx;
	
	uvm_analysis_port#(xge_tx_pkt)	enq_ap;

	function new(string name="xge_enq_mon", uvm_componet parent);
		super.new(name, parent);
		enq_ap = new("enq_ap",this);
	endfunction
