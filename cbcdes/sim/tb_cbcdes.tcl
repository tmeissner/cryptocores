set signals [list]
lappend signals "top.tb_cbcdes.s_reset"
lappend signals "top.tb_cbcdes.s_clk"
lappend signals "top.tb_cbcdes.s_validin"
lappend signals "top.tb_cbcdes.s_start"
lappend signals "top.tb_cbcdes.s_mode"
lappend signals "top.tb_cbcdes.s_key"
lappend signals "top.tb_cbcdes.s_iv"
lappend signals "top.tb_cbcdes.s_datain"
lappend signals "top.tb_cbcdes.s_validout"
lappend signals "top.tb_cbcdes.s_dataout"
lappend signals "top.tb_cbcdes.s_ready"
set num_added [ gtkwave::addSignalsFromList $signals ]
