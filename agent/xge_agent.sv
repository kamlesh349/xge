class xge_agent extends uvm_agent;
	`uvm_component_utils(xge_agent)

	xge_mon	mon;
	xge_drv	drv;
	xge_seqr seqr;

//	uvm_active_passive_enum	is_active;

	function new(string name="xge_agent", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon	= xge_mon  :: type_id :: create("mon", this);
		drv	= xge_drv  :: type_id :: create("drv", this);
		seqr	= xge_seqr :: type_id :: create("seqr", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction
endclass
