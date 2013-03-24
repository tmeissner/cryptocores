set signals [list]
lappend signals "tb_cdes.reset"
lappend signals "tb_cdes.clk"
lappend signals "tb_cdes.start"
lappend signals "tb_cdes.validin"
lappend signals "tb_cdes.mode"
lappend signals "tb_cdes.key"
lappend signals "tb_cdes.iv"
lappend signals "tb_cdes.datain"
lappend signals "tb_cdes.readyout"
lappend signals "tb_cdes.validout"
lappend signals "tb_cdes.dataout"
set num_added [ gtkwave::addSignalsFromList $signals ]
