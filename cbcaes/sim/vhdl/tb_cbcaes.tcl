set signals [list]
lappend signals "top.tb_cbcaes.s_reset"
lappend signals "top.tb_cbcaes.s_clk"
lappend signals "top.tb_cbcaes.s_validin"
lappend signals "top.tb_cbcaes.s_acceptin"
lappend signals "top.tb_cbcaes.s_start"
lappend signals "top.tb_cbcaes.s_key"
lappend signals "top.tb_cbcaes.s_iv"
lappend signals "top.tb_cbcaes.s_datain"
lappend signals "top.tb_cbcaes.s_validout"
lappend signals "top.tb_cbcaes.s_acceptout"
lappend signals "top.tb_cbcaes.s_dataout"
set num_added [ gtkwave::addSignalsFromList $signals ]
