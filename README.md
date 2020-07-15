# cryptocores
cryptography ip-cores in vhdl / verilog

The components in this repository are not intended for productional code.
They serve as proof of concept, for example how to implement a pipeline using
only (local) variables instead of (global) signals. Furthermore they were used
how to do a VHDL-to-Verilog conversion for learning purposes.

*HINT:*

The tests of some algorithms use the OSVVM library, which is redistributed as
submodule. To get & initialize the submodule, please use the `--recursive` option
when cloning this repository.
