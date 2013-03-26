set signals [list]
lappend signals "top.tb_cbctdes.s_reset"
lappend signals "top.tb_cbctdes.s_clk"
lappend signals "top.tb_cbctdes.s_validin"
lappend signals "top.tb_cbctdes.s_start"
lappend signals "top.tb_cbctdes.s_mode"
lappend signals "top.tb_cbctdes.s_key"
lappend signals "top.tb_cbctdes.s_iv"
lappend signals "top.tb_cbctdes.s_datain"
lappend signals "top.tb_cbctdes.s_validout"
lappend signals "top.tb_cbctdes.s_dataout"
lappend signals "top.tb_cbctdes.s_ready"
set num_added [ gtkwave::addSignalsFromList $signals ]
