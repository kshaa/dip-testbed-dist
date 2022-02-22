# Server usage
  
1) Download CLI server:  
```bash
curl https://github.com/kshaa/dip-testbed-dist/releases/download/<version>/dip_server.zip -L -o dip_server.zip  
```
_Note: Replace `<version>` with a release verion e.g. `v3.0.2`_  
  
2) Decompress the zip archive: [read a how-to article](https://lmgtfy.app/?q=linux+unzip+archive)  
3) Enter the extracted directory `web-a.b.c-SNAPSHOT` where `a.b.c` is the version, but currently incorrect - `0.1.0`  
4) Configure the server settings under `./conf/application.conf`  
_Note: See section `Server configuration` for more info_  
  
5) Enter the server binary directory `../bin`
6) Make this binary executable: [read a how-to article](https://lmgtfy.app/?q=linux+make+binary+executable)  
7) Run the server `./web`  
  
## Server configuration
- `play.http.secret.key` must be a random string used for session encryption  
- `slick.dbs.default` must be the database configuration  
- `play.filters.hosts.allowed` must be the external domain or IP address of the application  

For more information use Google e.g.:
- `Scala Play configure Slick` to configure the database connection  
- `Scala Play configure external hostname` to configure the external application hostname   
- `Scala Play configure secret key` to configure the server session key  

## Server usage
Currently the server should only be used using the CLI client (see [README.md](../README.md)).  
If needed, possibly the raw REST API definition will be exposed/documented.  
Although if you really want to know, you can just use the client and WireShark the network requests.  
  
