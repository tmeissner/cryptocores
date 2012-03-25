set signals [list]
lappend signals "tb_des.reset"
lappend signals "tb_des.clk"
lappend signals "tb_des.validin"
lappend signals "tb_des.mode"
lappend signals "tb_des.key"
lappend signals "tb_des.datain"
lappend signals "tb_des.validout"
lappend signals "tb_des.dataout"
lappend signals "tb_des.outdex"
set num_added [ gtkwave::addSignalsFromList $signals ]
