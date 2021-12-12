# DIP Testbed
DIP Testbed is a an academic university work, so I can only open-source 
this after I've handed the work in at university.  
  
However this repository will serve as a means to distribute documentation
and executables.  
  
## Client usage
  
The client is available as a compiled release:
  `https://github.com/kshaa/dip-testbed-dist/releases/download/<version>/dip_client -L -o dip_client`

_Note: Replace `<version>` with a release verion e.g. `v2.0.1`_  

For more documentations see [CLIENT.md](./CLIENT.md)  
For reference the client is a Python application packaged w/ [pyinstaller](https://pyinstaller.readthedocs.io/en/stable/)  
For reference the interesting libraries used in the client stack are:
- `websockets`
- `requests`
- `click`
- `rich`
- `pyserial`

## Server usage
  
The client is available as a compiled release:
  `https://github.com/kshaa/dip-testbed-dist/releases/download/<version>/dip_server.zip -L -o dip_server.zip`

_Note: Replace `<version>` with a release verion e.g. `v2.0.1`_  

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
- It does hash and salt passwords  
- It doesn't have TLS server encryption setup, so don't send sensitive data  
- In other words, use randomly generated passwords not your personal ones  
- HTTP server (static server): `http://159.223.31.101:9000/`  
- WebSocket server (control server): `ws://159.223.31.101:9000/`  
- _Note: This server is in development, please don't abuse it, it can be abused somewhat easily currently_  
- _Note: If you do abuse it, don't be _too_ aggressive/destructive, also create a GitHub issue in this repo describing how you abused it_  
- _Note: If you have any suggestions for improvements, also create an issue in this repo_  
- _Note: If you have any questions, create an issue or send me an e-mail/message_  
  