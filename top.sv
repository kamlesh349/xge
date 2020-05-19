module top;
reg		clk,rst_n;
xge_ifc	ifc(
	clk,
	clk,
	clk,
	clk
);
xge_mac dut(
	.clk_156m25       ( ifc.clkTxRx          ) ,
	.pkt_rx_ren       ( ifc.pkt_rx_ren       ) ,
	.pkt_rx_avail     ( ifc.pkt_rx_avail     ) ,
	.pkt_rx_data      ( ifc.pkt_rx_data      ) ,
	.pkt_rx_eop       ( ifc.pkt_rx_eop       ) ,
	.pkt_rx_err       ( ifc.pkt_rx_err       ) ,
	.pkt_rx_mod       ( ifc.pkt_rx_mod       ) ,
	.pkt_rx_sop       ( ifc.pkt_rx_sop       ) ,
	.pkt_rx_val       ( ifc.pkt_rx_val       ) ,
	.pkt_tx_data      ( ifc.pkt_tx_data      ) ,
	.pkt_tx_eop       ( ifc.pkt_tx_eop       ) ,
	.pkt_tx_mod       ( ifc.pkt_tx_mod       ) ,
	.pkt_tx_sop       ( ifc.pkt_tx_sop       ) ,
	.pkt_tx_full      ( ifc.pkt_tx_full      ) ,
	.pkt_tx_val       ( ifc.pkt_tx_val       ) ,
	.reset_156m25_n   ( ifc.reset_156m25_n   ) ,
	.clk_xgmii_rx     ( ifc.clkXGMIIRx       ) ,
	.reset_xgmii_rx_n ( ifc.reset_xgmii_rx_n ) ,
	.xgmii_rxc        ( ifc.xgmii_rxc        ) ,
	.xgmii_rxd        ( ifc.xgmii_rxd        ) ,
	.clk_xgmii_tx     ( ifc.clkXGMIITx       ) ,
	.reset_xgmii_tx_n ( ifc.reset_xgmii_tx_n ) ,
	.xgmii_txc        ( ifc.xgmii_txc        ) ,
	.xgmii_txd        ( ifc.xgmii_txd        ) ,
	.wb_clk_i         ( ifc.clkWB            ) ,
	.wb_rst_i         ( ifc.wb_rst_i         ) ,
	.wb_adr_i         ( ifc.wb_adr_i         ) ,
	.wb_cyc_i         ( ifc.wb_cyc_i         ) ,
	.wb_dat_i         ( ifc.wb_dat_i         ) ,
	.wb_stb_i         ( ifc.wb_stb_i         ) ,
	.wb_we_i          ( ifc.wb_we_i          ) ,
	.wb_ack_o         ( ifc.wb_ack_o         ) ,
	.wb_dat_o         ( ifc.wb_dat_o         ) ,
	.wb_int_o         ( ifc.wb_int_o         )
	);
//clk generation
initial begin
	clk=0;
	forever #5 clk=~clk;
end

assign ifc.xgmii_rxc = ifc.xgmii_txc;

assign ifc.xgmii_rxd = ifc.xgmii_txd;

//rst apply
initial begin
	ifc.wb_rst_i         =0;
	ifc.reset_156m25_n   =0;
	ifc.reset_xgmii_rx_n =0;
	ifc.reset_xgmii_tx_n =0;
	repeat(2)@(posedge clk);
	ifc.wb_rst_i         =1;
	ifc.reset_156m25_n   =1;
	ifc.reset_xgmii_rx_n =1;
	ifc.reset_xgmii_tx_n =1;
end

initial begin
	uvm_config_db #(vxge) :: set(null,"*","xge_ifc",ifc);
	run_test();
end

initial #5000 $finish;
endmodule
