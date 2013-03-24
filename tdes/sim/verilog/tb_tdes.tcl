set signals [list]
lappend signals "tb_tdes.reset"
lappend signals "tb_tdes.clk"
lappend signals "tb_tdes.validin"
lappend signals "tb_tdes.mode"
lappend signals "tb_tdes.key1"
lappend signals "tb_tdes.key2"
lappend signals "tb_tdes.key3"
lappend signals "tb_tdes.datain"
lappend signals "tb_tdes.validout"
lappend signals "tb_tdes.dataout"
lappend signals "tb_tdes.ready"
set num_added [ gtkwave::addSignalsFromList $signals ]
