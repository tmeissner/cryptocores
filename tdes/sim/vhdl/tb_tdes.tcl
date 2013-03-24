set signals [list]
lappend signals "top.tb_tdes.s_reset"
lappend signals "top.tb_tdes.s_clk"
lappend signals "top.tb_tdes.s_validin"
lappend signals "top.tb_tdes.s_mode"
lappend signals "top.tb_tdes.s_key1"
lappend signals "top.tb_tdes.s_key2"
lappend signals "top.tb_tdes.s_key3"
lappend signals "top.tb_tdes.s_datain"
lappend signals "top.tb_tdes.s_validout"
lappend signals "top.tb_tdes.s_dataout"
lappend signals "top.tb_tdes.s_ready"
set num_added [ gtkwave::addSignalsFromList $signals ]
