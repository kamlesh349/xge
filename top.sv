module top;
reg		clk,rst_n;
xge_ifc	ifc;
//dut instantiation
//rx_dequeue dut();

//program block instantiation

//clk generation
initial begin
	rx_clk=0;
	forever #5 rx_clk=~rx_clk;
end

//rst apply
initial begin
	rx_rst_n=0;
	repeat(2)@(posedge rx_clk);
	rx_rst_n=1;
	$display("a");

	//run_test("rx_test");

end

initial begin
	run_test("rx_test");
end

initial #5000 $finish;

endmodule
