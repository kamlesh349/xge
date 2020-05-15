module top;
reg		clk,rst_n;
xge_ifc	ifc(
	clk,
	clk,
	clk,
	clk,
);
xge_mac dut(
	.clk_156m25(        clkTxRx          )
	.pkt_rx_ren(        pkt_rx_ren       )
	.pkt_rx_avail(      pkt_rx_avail     )
	.pkt_rx_data(       pkt_rx_data      )
	.pkt_rx_eop(        pkt_rx_eop       )
	.pkt_rx_err(        pkt_rx_err       )
	.pkt_rx_mod(        pkt_rx_mod       )
	.pkt_rx_sop(        pkt_rx_sop       )
	.pkt_rx_val(        pkt_rx_val       )
	.pkt_tx_data(       pkt_tx_data      )
	.pkt_tx_eop(        pkt_tx_eop       )
	.pkt_tx_mod(        pkt_tx_mod       )
	.pkt_tx_sop(        pkt_tx_sop       )
	.pkt_tx_full(       pkt_tx_full      )
	.pkt_tx_val(        pkt_tx_val       )
	.reset_156m25_n(    reset_156m25_n   )
	.clk_xgmii_rx(      clkXGMIIRx       )
	.reset_xgmii_rx_n(  reset_xgmii_rx_n )
	.xgmii_rxc(         xgmii_rxc        )
	.xgmii_rxd(         xgmii_rxd        )
	.clk_xgmii_tx(      clkXGMIITx       )
	.reset_xgmii_tx_n(  reset_xgmii_tx_n )
	.xgmii_txc(         xgmii_txc        )
	.xgmii_txd(         xgmii_txd        )
	.wb_clk_i(          clkWB            )
	.wb_rst_i(          wb_rst_i         )
	.wb_adr_i(          wb_adr_i         )
	.wb_cyc_i(          wb_cyc_i         )
	.wb_dat_i(          wb_dat_i         )
	.wb_stb_i(          wb_stb_i         )
	.wb_we_i(           wb_we_i          )
	.wb_ack_o(          wb_ack_o         )
	.wb_dat_o(          wb_dat_o         )
	.wb_int_o(          wb_int_o         )
	);
//clk generation
initial begin
	clk=0;
	forever #5 clk=~clk;
end

//rst apply
initial begin
	ifc.  cbtxrx.     wb_rst_i         = 0;
	ifc.  cbtxrx.     reset_156m25_n   = 0;
	ifc.  cbxGMIIRx.  reset_xgmii_rx_n = 0;
	ifc.  cbxGMIITx.  reset_xgmii_tx_n = 0;
	repeat(2)@(posedge clk);
	ifc.  cbtxrx.     wb_rst_i         = 1;
	ifc.  cbtxrx.     reset_156m25_n   = 1;
	ifc.  cbxGMIIRx.  reset_xgmii_rx_n = 1;
	ifc.  cbxGMIITx.  reset_xgmii_tx_n = 1;
end

initial begin
	run_test();
end

initial #5000 $finish;
endmodule
