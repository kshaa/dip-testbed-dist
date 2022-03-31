# Verilog UART usage
  
This example project contains a Verilog design to receive and send data over a serial UART interface.  
  
## File structure
- `uart_tx.v` - Design to send bytes over a serial interface  
- `uart_rx.v` - Design to receive bytes from a serial interface  
- `uart_tx_typed_chunker.v` - Design to encode and send an array of bytes and an identifier over a serial interface  
- `uart_rx_typed_chunker.v` - Design to decode and parse an array of bytes and an identifier from a serial interface  
- `syntax.bnf` - Syntax in BNF form for the binary protocol used over the serial interface which can be tested [online](https://bnfplayground.pauliankline.com/)  
- `main.v` - Design to parse and decode a byte chunk with an identifier and then encode it and send it back over a serial interface  
  
