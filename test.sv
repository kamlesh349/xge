class xge_test extends uvm_test;
	`uvm_component_utils(xge_test)
	xge_env   env;
	vxge      vif;
	bit[31:0] data[4];
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(vxge)::get(this,"","xge_ifc",vif))
			`uvm_fatal("_TEST", "failed to get interface")
		env = xge_env::type_id::create("env",this);
	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		xge_crt_seq seq = xge_crt_seq::type_id::create("seq");
		phase.raise_objection(this);
			@(posedge vif.clkTxRx);
			seq.start(env.agent.seqr);
			repeat(2) @(posedge vif.clkWB);
			cpuread(`CPUREG_STATSTXPKTS,    data[0]);
			cpuread(`CPUREG_STATSRXPKTS,    data[0]);
			cpuread(`CPUREG_STATSTXOCTETS,  data[0]);
			cpuread(`CPUREG_STATSRXOCTETS,  data[0]);
			repeat(2) @(posedge vif.clkWB);
		phase.drop_objection(this);	
	endtask
	task cpuread([31:0] addr,output [31:0] data);
		@(posedge vif.clkWB);
		vif.wb_adr_i <= addr;
		vif.wb_cyc_i <= 1'b1;
		vif.wb_stb_i <= 1'b1;
		@(posedge vif.clkWB);
		vif.wb_stb_i <= 1'b0;
		@(posedge vif.clkWB);
		vif.wb_cyc_i <= 1'b0;
		data = vif.wb_dat_o;
		@(posedge vif.clkWB);
	endtask
endclass
