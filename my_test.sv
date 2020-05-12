class rx_test extends uvm_test;
	`uvm_component_utils(rx_test)

	//rx_env instantiation
	rx_env env;
	//factory registration

	//function new
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	env=rx_env::type_id::create("env",this);
	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
	endfunction
	
	task run_phase(uvm_phase phase);
		#300;
	endtask
endclass
