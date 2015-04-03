set signals [list]
lappend signals "tb_cbcmac_des.reset"
lappend signals "tb_cbcmac_des.clk"
lappend signals "tb_cbcmac_des.validin"
lappend signals "tb_cbcmac_des.acceptout"
lappend signals "tb_cbcmac_des.start"
lappend signals "tb_cbcmac_des.key"
lappend signals "tb_cbcmac_des.datain"
lappend signals "tb_cbcmac_des.validout"
lappend signals "tb_cbcmac_des.acceptin"
lappend signals "tb_cbcmac_des.dataout"
set num_added [ gtkwave::addSignalsFromList $signals ]
