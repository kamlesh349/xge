class xge_pkt extends uvm_sequence_item;
	`uvm_object_utils(xge_pkt)
	rand bit [63:0] data[$];
	rand bit [ 2:0] mod;

	function new(string name="xge_pkt");
		super.new(name);
	endfunction
	constraint _len { data.size < 65 ; data.size > 0; }
	constraint _octave {
		foreach(data[i])
			if (i== data.size -1 && mod!=0)
				data[i] < 2**(mod*8);
		}
endclass
