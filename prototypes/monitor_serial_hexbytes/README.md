# Custom serial port monitoring script `hexbytes`
This folder contains a Python module which can be imported by the DIP Testbed Client `hardware-serial-monitor` command.  
  
**!! Note: This is outdated and might be removed or refactored.**  
  
Module contents:
- `mock.py` - Mocks of all DIP Testbed related Python classes needed to implement a custom monitoring solution,
  this is added for doing type checking in IDEs.
- `monitor.py` - The actual monitoring script, which exports a `monitor` variable containing the monitoring class with a method `run`
  
The monitoring script gets run with an instance of `socketlike: Socketlike`, which allows receiving/transmitting monitoring messages to/from the backend.  

This specific `hexbytes` implementation is a copy-paste of the original `hardware-serial-monitor` monitoring type `hexbytes`, simply implemented as an external script/module.  

This script does the following:
- receives bytes from the `socketlike`, formats and prints them out to `STDOUT`  
- captures/supresses `STDIN` from printing to `STDOUT`  
- redirects all `STDIN` bytes to transmit through `socketlike`  
- on error conditions or exit signals reverts the capture of `STDIN`, closes the `socketlike` connection, returns an exit result
