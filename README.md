# DIP Testbed
  
DIP Testbed Platform is an academic work which allows users to remotely program and experience physical, embedded devices through various virtual interfaces (uni-directional webcam stream, bi-directional serial connection stream).  
  
_N.B. This is an academic piece of work, it's rough around the edges, because time was a significant constraint._  

## Demo
### Installation
[![asciicast](https://asciinema.org/a/doBhf1fLi2v0AA8L9ku5W0hcE.svg)](https://asciinema.org/a/doBhf1fLi2v0AA8L9ku5W0hcE)  

### Usage
[![asciicast](https://asciinema.org/a/TJauvtQSHE06lYrFU7k4htOgn.svg)](https://asciinema.org/a/TJauvtQSHE06lYrFU7k4htOgn)  
  
## Quick installation & usage
Download the CLI tool:
```bash
curl -L https://github.com/kshaa/dip-testbed-dist/releases/latest/download/client_install.sh | bash
```
  
Create a local authentication session:
```bash
dip_client session-auth -u <username> -p <password>
```
  
Upload software to the platform, forward it to a hardware board, start a web video stream in a browser, run a serial connection against the board: 
```bash
dip_client quick-run -f firmware.bit -b ${BOARD_UUID}
```

_Note: This assumes usage of bash, AMD64 architecture, testbed.veinbahs.lv as default server_  
_Note: Also the default buttonled interface is used_  
_Note: Quick run has all of the underlying mechanics configurable, see options with `quick-run --help`_  
  
## Detailed platform usage

### Installation
- Download `https://github.com/kshaa/dip-testbed-dist/releases/latest/download/dip_client_${TARGET_ARCH}`  
- Store in `${PATH}`
- Set executable bit

### Platform access initiation
  
Configure academic DIP Testbed platform server:
```bash
dip_client session-static-server -s http://testbed.veinbahs.lv
dip_client session-control-server -s ws://testbed.veinbahs.lv
```
  
Authenticate:  
```bash
dip_client session-auth -u <username> -p <password>
```
  
### Developer usage

Upload software to platform:
```bash
dip_client software-upload -f firmware.bit
```

Forward software to a hardware board:
```bash
dip_client hardware-software-upload --hardware-id ${BOARD_UUID} --software-id ${SOFTWARE_UUID}
```

Create a serial connection to the board:
```
dip_client hardware-serial-monitor --hardware-id ${BOARD_UUID} -t buttonleds
```

### Lab operator usage
  
Register hardware in platform:
```
dip_client hardware-create --name ${BOARD_NAME}
```
  
Run agent for registered hardware (allows remote access & management by platform):
```
dip_client agent-${AGENT_TYPE} -b ${BOARD_UUID} <AGENT_SPECIFIC_OPTIONS>
```
  
_Note: For agent-specific usage, see `dip_client agent-${AGENT_TYPE} --help`_  
  
## Documentation
- See 🌼 🌻 [docs](./docs/README.md) 🌻 🌼 for user-centric documentation  
- See [prototypes](./prototypes/README.md) for examples of the testbed platform usage  
  
## Development
The following links are currently available only by special request  
  
- See [backend](./backend/README.md) for backend implementation & usage  
- See [client](./client/README.md) for client and agent implementation & usage  
- See [database](./database/README.md) for database usage  
  