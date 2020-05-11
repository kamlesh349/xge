class tx_enq;

	rand bit [63:0] pkt_tx_data[$];
//	rand bit			 pkt_tx_val[$];
	rand bit			 pkt_tx_sop[$];
	rand bit			 pkt_tx_eop[$];
	rand bit [ 2:0] pkt_tx_mod[$];
//		  bit			 pkt_tx_full[$];

	rand int			 len;

	constraint _len { len < 1024; }
	constraint _mod0 { 
		foreach (pkt_tx_eop[i]) {
			(pkt_tx_eop[i] == 0) -> (pkt_tx_mod[i] == 3'b0);
			(pkt_tx_eop[i] == 1) -> (pkt_tx_mod[i] == len % 8);
		}
	}
	constraint _size {
		pkt_tx_mod.size == (len + 7) / 8;
		pkt_tx_mod.size == pkt_tx_eop.size;
		pkt_tx_mod.size == pkt_tx_sop.size;
		pkt_tx_mod.size == pkt_tx_data.size;
		pkt_tx_mod.size == pkt_tx_full.size;
	}
	constraint _op {
		foreach (pkt_tx_sop[i]) {
			if (i==0) 
				pkt_tx_sop[i] == 1;
			else 
				pkt_tx_sop[i] == 0;
		}
		pkt_tx_eop == pkt_tx_sop.sort();
	}
}
