class xge_env extends uvm_env;
	`uvm_component_utils(xge_env)
	xge_agent agent;

	function new(string name="xge_env",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent = xge_agent::type_id::create("agent", this);
	endfunction
endclass
