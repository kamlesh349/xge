class xge_base_seq extends uvm_sequence#(xge_pkt);
	`uvm_object_utils(xge_base_seq)
	function new(string name="xge_base_seq");
		super.new(name);
	endfunction
endclass

class xge_crt_seq extends xge_base_seq;
	`uvm_object_utils(xge_crt_seq)
	function new(string name="xge_crt_seq");
		super.new(name);
	endfunction

	task body();
		`uvm_do_with(req,
			{
			data.size dist { 1:/3, [2:9]:/1, [61:64]:/9};
			mod dist { [1:7]:/27, 0:/3};
			}
		)
	endtask
endclass
/*
class xge_base_seq extends uvm_sequence#(xge_pkt);
	`uvm_object_utils()
	function new(string name="");
		super.new(name);
	endfunction
endclass
*/
