# Description of example upload flow
  
_This document conveys the gist of the upload flow, these aren't exact and correct logs_  
  
`[backend]` Start backend:  
```bash
$ sbt web/run
[info] welcome to sbt 1.5.0 (Azul Systems, Inc. Java 12.0.2)
[info] loading global plugins from /home/kveinbahs/.sbt/1.0/plugins
[info] loading settings for project backend-build from plugins.sbt ...
[info] loading project definition from /home/kveinbahs/Code/dip-testbed/backend/project
[info] loading settings for project root from build.sbt ...
[info] set current project to root (in build file:/home/kveinbahs/Code/dip-testbed/backend/)

--- (Running the application, auto-reloading is enabled) ---

[info] p.c.s.AkkaHttpServer - Listening for HTTP on /0:0:0:0:0:0:0:0:9000

(Server started, use Enter to stop and go back to the console...)
```

`[client]` Create user, hardware and software:
```bash
# User
curl --location --request POST 'http://localhost:9000/api/v1/user/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "username": "kshaa",
    "password": "qwerty123"
}'

# Hardware
curl --location --request POST 'http://localhost:9000/api/v1/hardware/' \
--header 'Authentication: Basic a3NoYWE6cXdlcnR5MTIz' \ 
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "anvyl-01"
}'

# Software
curl --location --request POST 'http://localhost:9000/api/v1/software/' \
--header 'Authentication: Basic a3NoYWE6cXdlcnR5MTIz' \
--form 'software=@"/home/kveinbahs/Code/dip-testbed/notes/firmware.hex"' \
--form 'name="hello_firmware_2.hex"'
```

`[backend]` Executes some database queries:
```bash
# User creation
[debug] s.j.J.statement - Preparing statement: insert into "user" ("uuid","username","hashed_password")  values (?,?,?)
# Auth validation + hardware creation
[debug] s.j.J.statement - Preparing statement: select "uuid", "username", "hashed_password" from "user" where "username" = 'kshaa'
[debug] s.j.J.statement - Preparing statement: select "uuid", "username", "hashed_password" from "user" where "uuid" = 'dd0aed9e-589c-4764-aa55-c9fa65f7e0ab'
[debug] s.j.J.statement - Preparing statement: insert into "hardware" ("uuid","name","battery_percent","owner_uuid")  values (?,?,?,?)
# Auth validation + software creation
[debug] s.j.J.statement - Preparing statement: select "uuid", "username", "hashed_password" from "user" where "username" = 'kshaa'
[debug] s.j.J.statement - Preparing statement: select "uuid", "username", "hashed_password" from "user" where "uuid" = 'dd0aed9e-589c-4764-aa55-c9fa65f7e0ab'
[debug] s.j.J.statement - Preparing statement: insert into "software" ("uuid","owner_uuid","name","content")  values (?,?,?,?)
```
  
`[agent]` Start microcontroller agent:  
```bash
$ ./dip-client.py -i e61aeddd-1119-49b6-9a8e-6c0405c437f1 -c ws://localhost:9000/ -s http://localhost:9000/ cli-client-nrf52 -b 115200 -d /dev/ttyUSB0
[2021-10-15 13:29:37] [INFO] [entrypoint] Running async client
[2021-10-15 13:29:37] [INFO] [client] Connected to control server, listening for commands
```

`[backend]` Creates a microcontroller control actor:  
```bash
# Hardware controller creates WebSocket stream
# Hardware controller spawns new HardwareControlActor and connects w/ WebSocket stream
```

`[client]` Request hardware software upload:  
```bash
curl --location --request GET 'http://localhost:9000/api/v1/hardware/e61aeddd-1119-49b6-9a8e-6c0405c437f1/upload/software/82b0a3ce-3230-4b18-8552-84feea7383f4' \
--header 'Authentication: Basic a3NoYWE6cXdlcnR5MTIz'
```

`[backend]` Forwards hardware software upload request:  
```bash
# Hardware controller forwards UploadMessage to HardwareControlActor
# HardwareControlActor actor forwards UploadMessage to WebSocket stream
```
  
`[agent]` Agent receives message and triggers software download and subsequent upload:  
```bash
[2021-10-15 13:29:40] [INFO] [client] Message received: UploadMessage(software_id=UUID('82b0a3ce-3230-4b18-8552-84feea7383f4'))
[2021-10-15 13:29:40] [INFO] [nrf52] Downloading firmware
[2021-10-15 13:29:40] [INFO] [nrf52] Downloaded software: /tmp/tmpdg2y7ch7
[2021-10-15 13:29:45] [INFO] [nrf52] Upload successful: (0, b'Zip created at /tmp/tmp.anZMhegpVA/firmware-package.zip\nUpgrading target on /dev/ttyUSB0 with DFU package /tmp/tmp.anZMhegpVA/firmware-package.zip. Flow control is disabled, Dual bank, Touch disabled\n########################################\n#######\nActivating new firmware\nDevice programmed.\n', b'')
```
