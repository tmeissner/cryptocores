[![simulation](https://img.shields.io/github/workflow/status/tmeissner/cryptocores/Simulation/master?longCache=true&style=flat-square&label=simulation&logo=Github%20Actions&logoColor=fff)](https://github.com/tmeissner/cryptocores/actions?query=workflow%3ASimulation)

# cryptocores
Cryptography IP-cores & tests written in VHDL / Verilog

The components in this repository are not intended as productional code.
They serve as proof of concept, for example how to implement a pipeline using
only (local) variables instead of (global) signals. Furthermore they were used
how to do a VHDL-to-Verilog conversion for learning purposes.

The testbenches to verify [DES](des/sim/vhdl/), [AES](aes/sim/vhdl/) and [CTR-AES](ctraes/sim/vhdl/) are examples
how useful GHDLs VHPIdirect is. They use openSSL as reference models to check the correctness
of the VHDL implementation.

*HINT:*

The tests of some algorithms use the OSVVM library, which is redistributed as
submodule. To get & initialize the submodule, please use the `--recursive` option
when cloning this repository. Use `git submodule update --recursive` to update the submodule if you already chaked out the main repository.
