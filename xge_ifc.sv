interface xge_ifc(
	input bit clkWB,
	input bit clkTxRx,
	input bit clkXGMIIRx,
	input bit clkXGMIITx
	);

	//_WB_Interface
	bit [7:0]	wb_adr_i;
	bit			wb_cyc_i;
	bit [31:0]	wb_dat_i;
	bit			wb_stb_i;
	bit			wb_we_i;
	bit			wb_ack_o;
	bit [31:0]	wb_dat_o;
	bit			wb_int_o;

	//_pkt_RX_ifc
	bit			pkt_rx_ren;
	bit			pkt_rx_avail;
	bit [63:0]	pkt_rx_data;
	bit			pkt_rx_eop;
	bit			pkt_rx_val;
	bit			pkt_rx_sop;
	bit [2:0]	pkt_rx_mod;
	bit			pkt_rx_err;

	//_pkt_TX_ifc
	bit [63:0]	pkt_tx_data;
	bit			pkt_tx_val;
	bit			pkt_tx_sop;
	bit			pkt_tx_eop;
	bit [2:0]	pkt_tx_mod;
	bit			pkt_tx_full;

	//_XGMII_rx_ifc
	bit [7:0]	xgmii_rxc;
	bit [63:0]	xgmii_rxd;
	//_XGMII_tx_ifc
	bit [7:0]	xgmii_txc;
	bit [63:0]	xgmii_txd;

	//_resets
	bit wb_rst_i;
	bit reset_156m25_n;
	bit reset_xgmii_rx_n;
	bit reset_xgmii_tx_n;

	clocking cbtxrx @(posedge clkTxRx);
		// Using default delays
		default output #1000;

		// receive interface direction
		input		pkt_rx_avail;
		input		pkt_rx_data;
		input		pkt_rx_eop;
		input		pkt_rx_val;
		input		pkt_rx_sop;
		input		pkt_rx_mod;
		input		pkt_rx_err;
		output	pkt_rx_ren;
		// transmit interface direction
		output	pkt_tx_data;
		output	pkt_tx_val;
		output	pkt_tx_sop;
		output	pkt_tx_eop;
		output	pkt_tx_mod;
		input		pkt_tx_full;

		output	reset_156m25_n;

		output 	wb_rst_i;

	endclocking //_cbTxRx

	clocking cbxGMIIRx @(posedge clkXGMIIRx);
		output xgmii_rxc;
		output xgmii_rxd;

		output reset_xgmii_rx_n;
	endclocking // cbxGMIIRx

	clocking cbxGMIITx @(posedge clkXGMIITx);
		input xgmii_txc;
		input xgmii_txd;

		output reset_xgmii_tx_n;
	endclocking // cbxGMIITx
endinterface
typedef virtual xge_ifc vxge;
