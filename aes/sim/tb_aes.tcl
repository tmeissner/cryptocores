set signals [list]
lappend signals "top.tb_aes.s_reset"
lappend signals "top.tb_aes.s_clk"
lappend signals "top.tb_aes.s_validin"
lappend signals "top.tb_aes.s_mode"
lappend signals "top.tb_aes.s_key"
lappend signals "top.tb_aes.s_datain"
lappend signals "top.tb_aes.s_validout"
lappend signals "top.tb_aes.s_dataout"
set num_added [ gtkwave::addSignalsFromList $signals ]
