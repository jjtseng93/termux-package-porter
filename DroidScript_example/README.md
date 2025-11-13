# Making your own tmpk_anci.zip
- use something like this
    ```shell
    zip -r DroidScript_example/tmpk_anci.zip bash.zip fish.zip getpkn.sh gruntm.sh gt.zip r less.zip micro.zip pkg_name.txt rsync.zip ssh.zip strace.zip tarcp.sh wget.zip nd.zip
    ```
- required: bash.zip getpkn.sh gruntm.sh gt.zip r pkg_name.txt
# Installing app
- make a tarball first
  ```shell
  tar -cvf DroidScript_example.tar DroidScript_example
  ```
- insert this script to a new simple native helloworld app
  ```js
app.ChooseFile('tar','application/x-tar',fp=>
{
  if(!confirm('Do you trust this tar file?')) return;

  let fc = app.ReadFile(fp,"base64") ;
  let fn = "/sdcard/DroidScript/tmpinstall.tar" ;
  app.WriteFile( fn , fc ,  "Base64" ) ;
  let result = app.SysExec( "cd /sdcard/Android" +
  "/data/com.smartphoneremote.androidscriptfree" +
  "/files/DroidScript && tar -xvf tmpinstall.tar; exit",
  "sh,log"  ) ;

  alert(result) ;
}) ;
// 安裝到DroidScript  Install App to DroidScript
  ```
