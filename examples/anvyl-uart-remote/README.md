# Anvyl UART remote

## Testbed agent architecture
The agent connected to the hardware is written in Python.  
For reading the serial port the [pyserial](https://github.com/pyserial/pyserial) library was used.  
The defaults for the `pyserial` library are as follows:  
```
port=None,
baudrate=9600,
bytesize=EIGHTBITS,
parity=PARITY_NONE,
stopbits=STOPBITS_ONE,
timeout=None,
xonxoff=False,
rtscts=False,
write_timeout=None,
dsrdtr=False,
inter_byte_timeout=None,
exclusive=None,
```

As of writing this documentation the only changes applied are:  
- `baudrate` is `115200`  
- `timeout` is `0.05`  

When remote monitor connections are active the agent runs a monitoring loop.  
That monitoring loop uses `Serial.read(size)` ([more info](https://pyserial.readthedocs.io/en/latest/pyserial_api.html#serial.Serial.read)) which uses the aforementioned configurations.  
In addition the `size` is set to `8` as of writing.  
After every serial read, a packet is asynchronously sent to clients (_you_).  
After every serial read a timeout of value `timeout` (previously mentioned) is run, because otherwise single-threaded asynchronous Python has no time to process other functionality.  
  
### Testbed serial port messaging architecture
`Hardware` <-`Serial`-> `Agent (Python)` <-`HTTP/Websocket`-> `Server (Scala)` <-`HTTP/Websocket`-> `Client (Python, _you_)`  

### The `anvyl-uart-remote` program
In essence this program receives a byte, increments it in binary and send it back every second.  
In other words, you send in `a`, you receive back `b`.  

- [anvyl-uart-remote.xise](anvyl-uart-remote.xise) - Xilinx ISE project file containing all of the following source code  
- [uart_tx.v](uart_tx.v) - Module to send data over a [RS232-standard](https://en.wikipedia.org/wiki/RS-232) port, sourced from [NANDLAND](https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html)  
- [uart_rx.v](uart_rx.v) - Module to receive data from a [RS232-standard](https://en.wikipedia.org/wiki/RS-232) port, sourced from [NANDLAND](https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html)  
- [main.v](main.v) - Program showcasing reading, writing, processing to/from a serial port
    - Receive data from a serial port  
    - Stores exact received data in `rx_data_reg`  
    - Assigns `rx_data_reg` bits to Anvyl LED's (irrelevant as they can't currently be monitored remotely)  
    - Stores received data `+1` in `rx_data_reg_prim`  
    - Every `parameter sleep` cycles transmits `rx_data_reg_prim` over the serial port  
    - Uses `CLK` for counting sleep cycles and parsing serial data as a `115200` baudrate stream  
- [anvyl.ucf](anvyl.ucf) - Constraints file defining program pins and actual corresponding hardware pins, sourced from [elomage/FPGA-resources](https://github.com/elomage/FPGA-resources/blob/main/ucf_templates/Anvyl.ucf)
    - `CLK` is defined as the pin `D11` i.e. a `100000 kHz` clock signal source  
    - `T19` is the serial port receive channel pin  
    - `T20` is the serial port transmit channel pin  

### Notes
If you have any more questions, ask google.  
If you really think you need answers from me, send me an email or create an issue in this repository.  
