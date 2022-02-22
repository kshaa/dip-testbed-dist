# Button/LED virtual interface

This example project runs a simulation where you can move a bit left and right in a byte.  
For example:  
```
0: [00010000]
1: [00001000]
2: [00000100]
3: [00000010]
4: [00000100]
```
  
The simulation receives button input over UART.  
The simulation outputs LED output over UART.  
  
## File structure

## Testing
### With open source tools
- `iverilog -o <testbench>.vvp <testbench>.v`  
- `vvp <testbench>.vvp`  
- `gtkwave <testbench>.vcd`  

_Note: The `<testbench>.vcd` has to be configured in the testbench_  
_Note: You can Google and install these tools on most Linux systems_  

### With Xilinx ISE
Just open the `button-led-virtual-interface.xise` and run simulations through the GUI.  
