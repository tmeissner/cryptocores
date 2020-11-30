set signals [list]
lappend signals "top.tb_ctraes.s_reset"
lappend signals "top.tb_ctraes.s_clk"
lappend signals "top.tb_ctraes.s_validin"
lappend signals "top.tb_ctraes.s_acceptin"
lappend signals "top.tb_ctraes.s_start"
lappend signals "top.tb_ctraes.s_key"
lappend signals "top.tb_ctraes.s_nonce"
lappend signals "top.tb_ctraes.s_datain"
lappend signals "top.tb_ctraes.s_validout"
lappend signals "top.tb_ctraes.s_acceptout"
lappend signals "top.tb_ctraes.s_dataout"
set num_added [ gtkwave::addSignalsFromList $signals ]
