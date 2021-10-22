# DIP Testbed
DIP Testbed is a an academic university work, so I can only open-source 
this after I've handed the work in at university.  
  
However this repository will serve as a means to distribute documentation
and executables.  
  
Currently only the client is distributed. If I manage to compile the 
Scala server with GraalVM, then the server will also be distributed. 
If you would really like that, send me an e-mail to motivate me.  
  
## Installation
1) Download CLI client:  
```bash
curl https://github.com/kshaa/dip-testbed-dist/releases/download/<version>/dip_client -L -o dip_client
```
_Note: Replace `<version>` with a release verion e.g. `v1.0.0`_  
  
2) Make this binary executable: [read a how-to article](https://lmgtfy.app/?q=linux+make+binary+executable)  
3) Configure this binary in your PATH permanently: [read a how-to article](https://lmgtfy.app/?q=ubuntu+add+binary+to+path+permanently)  
  
## Usage
- `dip_client --help` - Read thorough help instructions  
- `dip_client <subcommand> --help` - Read thorough help instructions for a subcommand  

_Note: Before sending me e-mails, please read the help documentations_  

## Usage recommendations
- The client accepts a lot of parameters/options as environment variables
- So you can call `dip_client list-users -s http://<server>`
- And you can call `DIP_CLIENT_STATIC_SERVER="http://<server>" dip_client list-users`
- And you can also do the following:
    1) Create an environment file `env.sh`
    ```bash
    #!/usr/bin/env bash
    export DIP_CLIENT_STATIC_SERVER="http://<server>"
    export DIP_CLIENT_CONTROL_SERVER="ws://<server>"

    # .. later add more environment variables if needed
    # .. for example you could add authentication as follows
    # export DIP_USER_USERNAME="<username>" 
    # export DIP_USER_PASSWORD="<password>" 
    ```
    2) Source the environment variables into your shell using `source ./env.sh`  
    3) Call the CLI client without the fluff: `dip_client list-users`  

### Usage example: Creating a user
```bash
$ source ./env.sh # Load static server URL into environment
$ ./dip_client user-create -u kshaa -p <password>
                     User list                     
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━┓
┃ Id                                   ┃ Username ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━┩
│ 84633ccd-d089-4127-8a9c-b10cb21eef9c │ kshaa    │
└──────────────────────────────────────┴──────────┘
```

### Usage example: Setting up an Anvyl upload agent
First register the hardware in the Testbed  
```bash
$ echo 'export DIP_USER_USERNAME="<username>"' > ./env.sh
$ echo 'export DIP_USER_PASSWORD="<password>"' > ./env.sh
$ source ./env.sh # Load static server and auth into environment
$ dip_client hardware-create -n kshaa-anvyl-01
                                         Hardware list                                          
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ Id                                   ┃ Name           ┃ Owner id                             ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
│ adc0d413-468d-4719-b202-79dacc47ba2d │ kshaa-anvyl-01 │ 84633ccd-d089-4127-8a9c-b10cb21eef9c │
└──────────────────────────────────────┴────────────────┴──────────────────────────────────────┘
```

Then initiate the agent
```bash
$ source ./env.sh # Load static server and auth into environment
$ dip_client agent-anvyl-upload -i adc0d413-468d-4719-b202-79dacc47ba2d -d Anvyl -s 0
[2021-10-22 17:51:47] [INFO] [entrypoint] Running async client
[2021-10-22 17:51:47] [INFO] [client] Connected to control server, listening for commands, running start hook
```

_Note: This agent will fail if the server connection drops, if you want to set up a permanent agent
you should create a wrapper script which will re-start this agent script. This could also be created as
a systemd service for example. Alternatively I could add an option for retrying connections with backoff,
but that's not currently implemented._  
  
_Note: Only one agent can be spawned for a given hardware id._  
  
### Usage example: Uploading software to an Anvyl agent
First you need to upload a program file  
```bash
$ source ./env.sh # Load static server and auth into environment
$ dip_client software-upload -f $HOME/Code/dip/MD_ADD/main.bit -n kshaa_md_add.bit
                                          Software list                                           
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ Id                                   ┃ Name             ┃ Owner id                             ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
│ b4e1cedf-c118-4517-bfbe-68ae754593fb │ kshaa_md_add.bit │ 84633ccd-d089-4127-8a9c-b10cb21eef9c │
└──────────────────────────────────────┴──────────────────┴──────────────────────────────────────┘
```

Then you can upload that software to a given hardware  
```bash
$ source ./env.sh # Load static server and auth into environment
$ dip_client hardware-software-upload --hardware-id adc0d413-468d-4719-b202-79dacc47ba2d --software-id b4e1cedf-c118-4517-bfbe-68ae754593fb
Success: Uploaded software to hardware!
```

Also you can abuse this service and upload complete gibberish  
```bash
$ source ./env.sh # Load static server and auth into environment
$ ./dip_client software-upload -f ../notes/potato.txt -n potato.txt
                                       Software list                                        
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ Id                                   ┃ Name       ┃ Owner id                             ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
│ f57bb995-4f2f-40b1-a4f9-1baa2d2141ca │ potato.txt │ 84633ccd-d089-4127-8a9c-b10cb21eef9c │
└──────────────────────────────────────┴────────────┴──────────────────────────────────────┘
$ dip_client software-download -i f57bb995-4f2f-40b1-a4f9-1baa2d2141ca -f potato.txt
Success: Downloaded software: potato.txt
$ cat potato.txt 
potato
potato
potato
$ dip_client hardware-software-upload --hardware-id adc0d413-468d-4719-b202-79dacc47ba2d --software-id f57bb995-4f2f-40b1-a4f9-1baa2d2141ca
Error: Failed to upload software to hardware:
#### Status code: 1
#### Stdout:
Initializing scan chain...
Found Device ID: 44008093

Found 1 device(s):
    Device 0: XC6SLX45
Uploading '/tmp/tmpkzch7eow.bit'
Upload failed, was the firmware a valid program?

#### Stderr:
/tmp/_MEIKYAIie/static/digilent_anvyl/upload.sh: line 84: 644782 Segmentation fault      (core dumped) djtgcfg prog -d "${device}" -i ${scanchainindex} -f "${firmwarehextmp}"
```

### Usage extras
Most requests are capable of also printing out JSON instead of tables:
```bash
$ source ./env.sh # Load static server and auth into environment
$ ./dip_client software-list -j true # Option no. 1
$ DIP_CLIENT_JSON_OUTPUT=true ./dip_client software-list # Option no. 2
[
  {
    "id": "b4e1cedf-c118-4517-bfbe-68ae754593fb",
    "name": "kshaa_md_add.bit",
    "owner_uuid": "84633ccd-d089-4127-8a9c-b10cb21eef9c"
  },
  {
    "id": "f57bb995-4f2f-40b1-a4f9-1baa2d2141ca",
    "name": "potato.txt",
    "owner_uuid": "84633ccd-d089-4127-8a9c-b10cb21eef9c"
  }
]

```

### Academic purpose server
- There is a server hosted in the cloud  
- It does hash and salt passwords  
- It doesn't have TLS server encryption setup, so don't send sensitive data  
- In other words, use randomly generated passwords not your personal ones  
- HTTP server (static server): `http://159.223.31.101:9000/`  
- WebSocket server (control server): `ws://159.223.31.101:9000/`  
- _Note: This server is in development, please don't abuse it_  
- _Note: If you do abuse it, create a GitHub issue in this repo describing how you abused it_  
- _Note: If you have any suggestions for improvements, also create an issue in this repo_  
- _Note: If you have any questions, create an issue or write an e-mail/message to me_  
  