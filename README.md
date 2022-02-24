# DIP Testbed
  
DIP Testbed Platform is an academic work which allows users to remotely program and experience physical, embedded devices through various virtual interfaces (uni-directional webcam stream, bi-directional serial connection stream).  
  
## Quick installation & usage
Download the CLI tool:
```bash
curl https://github.com/kshaa/dip-testbed-dist/releases/latest/download/client_install.sh | bash
```
  
Create a local authentication session:
```bash
dip_client session-auth -u <username> -p <password>
```
  
Upload software to the platform, forward it to a hardware board, run a serial connection against it: 
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
  
## Usage
Configure academig DIP Testbed platform server:
```bash
dip_client session-static-server -s http://testbed.veinbahs.lv
dip_client session-control-server -s ws://testbed.veinbahs.lv
```

Authenticate:  
```bash
dip_client session-auth -u <username> -p <password>
```

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
  
## Documentation
- See 🌼 🌻 [docs](./docs/README.md) 🌻 🌼 for user-centric documentation  
- See [prototypes](./prototypes/README.md) for examples of the testbed platform usage  
  
## Development
The following links are currently available only by special request  
  
- See [backend](./backend/README.md) for backend usage  
- See [client](./client/README.md) for client and agent usage
- See [database](./database/README.md) for database usage  
  