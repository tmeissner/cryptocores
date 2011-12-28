set signals [list]
lappend signals "top.tb_des.s_reset"
lappend signals "top.tb_des.s_clk"
lappend signals "top.tb_des.s_validin"
lappend signals "top.tb_des.s_mode"
lappend signals "top.tb_des.s_key"
lappend signals "top.tb_des.s_datain"
lappend signals "top.tb_des.s_validout"
lappend signals "top.tb_des.s_dataout"
set num_added [ gtkwave::addSignalsFromList $signals ]
