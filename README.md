<p align="center">
  <a title="GitHub Actions workflow 'simulation'" href="https://github.com/tmeissner/cryptocores/actions?query=workflow%3ASimulation"><img alt="'simulation' workflow Status" src="https://img.shields.io/github/workflow/status/tmeissner/cryptocores/Simulation/master?longCache=true&style=flat-square&label=build&logo=Github%20Actions&logoColor=fff"></a><!--
  -->
</p>

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
