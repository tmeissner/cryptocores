[![simulation](https://github.com/tmeissner/cryptocores/workflows/test/badge.svg?branch=master)](https://github.com/tmeissner/cryptocores/actions?query=workflow%3Atest)

# cryptocores
Cryptography IP-cores & tests written in VHDL / Verilog

The components in this repository are not intended as productional code.
They serve as proof of concept, for example how to implement a pipeline using
only (local) variables instead of (global) signals. Furthermore they were used
how to do a VHDL-to-Verilog conversion for learning purposes.

*HINT:*

The tests of some algorithms use the OSVVM library, which is redistributed as
submodule. To get & initialize the submodule, please use the `--recursive` option
when cloning this repository.
