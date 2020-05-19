class xge_pkt extends uvm_sequence_item;
	rand bit [63:0] data[$];
	rand bit [ 2:0] mod;
	`uvm_object_utils_begin(xge_pkt)
		`uvm_field_queue_int ( data,  UVM_DEFAULT)
		`uvm_field_int       ( mod,   UVM_DEFAULT)
	`uvm_object_utils_end

	constraint _len { data.size < 65 ; data.size > 0; }
	constraint _octave {
		foreach(data[i])
			if (i== data.size -1 && mod!=0)
				data[i] < 2**(mod*8);
	}
	function new(string name="xge_pkt");
		super.new(name);
	endfunction
	function void seq_display();
		$display("%p%d\t%d",data,data.size,mod);
	endfunction
	function string convert2string();
		return $sformatf("%p\t%d",data,mod);
	endfunction
endclass
