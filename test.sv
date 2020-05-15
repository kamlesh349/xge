class xge_test extends uvm_test;
	`uvm_component_utils(xge_test)
	xge_env env;
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	env = xge_env::type_id::create("env",this);
	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		xge_crt_seq seq = xge_crt_seq::create::type_id::create("seq");
		phase.raise_objection(this);
			seq.start(env.agent.seqr);
		phase.drop_objection(this);	
	endtask
endclass
