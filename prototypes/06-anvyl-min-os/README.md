# Verilog UART usage with MinOS
  
This example project contains a Verilog design to receive and send data over a serial UART interface.  
  
## File structure
- `uart_tx.v` - Design to send bytes over a serial interface  
- `uart_rx.v` - Design to receive bytes from a serial interface  
- `uart_tx_typed_chunker.v` - Design to encode and send an array of bytes and an identifier over a serial interface  
- `uart_rx_typed_chunker.v` - Design to decode and parse an array of bytes and an identifier from a serial interface  
- `syntax.bnf` - Syntax in BNF form for the binary protocol used over the serial interface which can be tested [online](https://bnfplayground.pauliankline.com/)  
- `v_buttons.v` - Virtual interface for receiving button inputs over serial  
- `v_display.v` - Virtual interface for sending display data over serial  
- `v_switches.v` - Virtual interface for receiving switch inputs over serial  
- `v_buttons.v` - Virtual interface for sending LED data over serial  
- `min_os.v` - A compact abstraction called MinOS over all the aforementioned virtual interfaces  
- `main.v` - Design with the MinOS which contains a counter on LEDs, blinking RGB lights on display, button movable pixels on the display, switched which affect LEDs   
  
