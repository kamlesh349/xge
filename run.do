vlog \
	+incdir+../../uvm-1.2/src \
xge.svh

##
vsim \
	-c -novopt\
	top -sv_lib "C:/Program Files/Questasim/uvm-1.2/win64/uvm_dpi"\
	+UVM_NO_RELNOTES\
	+UVM_TESTNAME=xge_test
run -all

#quit
