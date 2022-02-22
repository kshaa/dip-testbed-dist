# DIP Testbed Platform
DIP Testbed Platform allows users to remotely program and experience physical, embedded devices through various virtual interfaces (uni-directional webcam stream, bi-directional serial connection stream).  

## DIP Client usage
DIP Client is the main CLI tool to interact with the DIP Testbed platform.  
  
The client is available as a compiled release: `https://github.com/kshaa/dip-testbed-dist/releases/download/<version>/dip_client_<arch>`  
  
_Note: Replace `<version>` with a release verion e.g. `v3.0.2`, and `<arch>` with a CPU architecture e.g. `amd64`_  
  
For more documentations see [CLIENT.md](./CLIENT.md)  
For reference the client is a Python application packaged w/ [pyinstaller](https://pyinstaller.readthedocs.io/en/stable/)  
For reference the interesting libraries used in the client stack are:
- `websockets`
- `requests`
- `click`
- `rich`
- `pyserial`

## DIP Platform usage prototypes
The author of this academic work created various prototypes when manually emulating end-user usage of the platform.  
The prototypes, their source codes and descriptions can be seen in [prototypes](../prototypes/README.md)  
  
## DIP Server usage  
DIP Server is a central service responsible for data management and connecting platform end-users, hardware devices & virtual interfaces  
  
The client is available as a compiled release: `https://github.com/kshaa/dip-testbed-dist/releases/download/<version>/dip_server.zip`

_Note: Replace `<version>` with a release verion e.g. `v3.0.2`_  

For more documentations see [SERVER.md](./SERVER.md)  
For reference the server is a Scala application packaged w/ [sbt dist](https://www.playframework.com/documentation/2.8.x/Deploying)  
For reference the interesting libraries used in the server stack are:
- `play`
- `akka`
- `slick`
- `circe`
- `h2` (for testing)

## Academic purpose server
- There is a server hosted in the cloud  
- HTTP server i.e. static server (all point to the same server):
  - `http://159.223.31.101:9000/`  
  - `http://testbed.veinbahs.lv:9000/`  
  - `http://testbed.veinbahs.lv/`  
- WebSocket server i.e. control server:
  - `ws://159.223.31.101:9000/`  
  - `ws://testbed.veinbahs.lv:9000/`  
  - `ws://testbed.veinbahs.lv/`  

_Note: This server is a piece of academic work, no serious guarantees about data security are made, don't sensitive data here_  
_Note: This server is in development, please don't abuse it, it can be abused somewhat easily currently_  
_Note: If you do abuse it, don't be _too_ aggressive/destructive, also create a GitHub issue in this repo describing how you abused it_  
_Note: If you have any suggestions for improvements, also create an issue in this repo_  
_Note: If you have any questions, create an issue or send me an e-mail/message_  
  
