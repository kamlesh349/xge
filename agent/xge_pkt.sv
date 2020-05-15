class xge_pkt extends uvm_seq_item;
	`uvm_object_utils(xge_pkt)
	rand bit [63:0] data[$];
	rand bit [ 2:0] mod;

	constraint _len { data.size < 65 ; data.size > 0; }
	constraint _octave {
		for (int i = 8*mod; i!=0, i<64; i+=8)
			data[$][i:i+7] &= 8'b0;
	}
}
