# DIP Testbed Platform
DIP Testbed Platform allows users to remotely program and experience physical, embedded devices through various virtual interfaces (uni-directional webcam stream, bi-directional serial connection stream).  

## 🌸 🌼 DIP User Tutorial Guides 🌼 🌸
_Hopefully if I have enough time I will create detailed tutorials for beginners_  
_Meanwhile you can check out the platform prototypes which are like "get your hands dirty" type of tutorials_  
  
## 🌸 🌼 DIP Client 🌼 🌸
DIP Client is the main CLI tool to interact with the DIP Testbed platform.  
For more documentations see [CLIENT.md](./CLIENT.md)  

Latest release: https://github.com/kshaa/dip-testbed-dist/releases/latest/download/dip_client_amd64  
Quick install: `curl https://github.com/kshaa/dip-testbed-dist/releases/latest/download/client_install.sh | bash`  

## 🌸 🌼 DIP Platform Prototypes 🌼 🌸
The author of this academic work created various prototypes when manually emulating end-user usage of the platform.  
The prototypes, their source codes and descriptions can be seen in [prototypes](../prototypes/README.md)  
  
## DIP Server usage  
DIP Server is a central service responsible for data management and connecting platform end-users, hardware devices & virtual interfaces  
For more documentations see [SERVER.md](./SERVER.md)  
  
Latest release: https://github.com/kshaa/dip-testbed-dist/releases/latest/download/dip_server.zip  

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
  
