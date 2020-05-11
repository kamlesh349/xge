class rx_env extends uvm_env;
	`uvm_component_utils(rx_env)

	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("rx_env","RX_ENV",UVM_LOW)
	endfunction
endclass
