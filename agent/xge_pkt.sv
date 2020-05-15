class xge_pkt extends uvm_sequence_item;
	`uvm_object_utils(xge_pkt)
	rand bit [63:0] data[$];
	rand bit [ 2:0] mod;

	constraint _len { data.size < 65 ; data.size > 0; }
	constraint _octave {
		foreach(data[$][i]) (i >= mod*8 && mod!=0) -> ( data[$][i] == 0);
	}
}
