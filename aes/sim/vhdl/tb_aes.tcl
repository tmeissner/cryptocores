set signals [list]
lappend signals "top.tb_aes.s_reset"
lappend signals "top.tb_aes.s_clk"
lappend signals "top.tb_aes.s_validin_enc"
lappend signals "top.tb_aes.s_acceptout_enc"
lappend signals "top.tb_aes.s_key"
lappend signals "top.tb_aes.s_datain"
lappend signals "top.tb_aes.s_validout_enc"
lappend signals "top.tb_aes.s_acceptin_enc"
lappend signals "top.tb_aes.s_dataout_enc"
lappend signals "top.tb_aes.s_validin_dec"
lappend signals "top.tb_aes.s_acceptout_dec"
lappend signals "top.tb_aes.s_key"
lappend signals "top.tb_aes.s_datain"
lappend signals "top.tb_aes.s_validout_dec"
lappend signals "top.tb_aes.s_acceptin_dec"
lappend signals "top.tb_aes.s_dataout_dec"
set num_added [ gtkwave::addSignalsFromList $signals ]
