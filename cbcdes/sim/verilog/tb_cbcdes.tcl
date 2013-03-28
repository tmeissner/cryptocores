set signals [list]
lappend signals "tb_cbcdes.reset"
lappend signals "tb_cbcdes.clk"
lappend signals "tb_cbcdes.start"
lappend signals "tb_cbcdes.validin"
lappend signals "tb_cbcdes.mode"
lappend signals "tb_cbcdes.key"
lappend signals "tb_cbcdes.iv"
lappend signals "tb_cbcdes.datain"
lappend signals "tb_cbcdes.readyout"
lappend signals "tb_cbcdes.validout"
lappend signals "tb_cbcdes.dataout"
set num_added [ gtkwave::addSignalsFromList $signals ]
