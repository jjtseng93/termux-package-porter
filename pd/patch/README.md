# fla for fixing konsole error cannot save config file
- fakes a system call of file link at 
- use by copying to /root and go
  ```shell
  LD_PRELOAD=/root/fla konsole
  ```
# sbcf.json for http/https proxy
- First run in Termux: 
  ```shell
  pkg install sing-box
  sing-box run -c sbcf.json
  ```
- Then in guest: 
  ```shell
  export http_proxy="http://127.0.0.1:8888"
  export https_proxy="http://127.0.0.1:8888"
  ```
