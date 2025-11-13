const csl=console.log;

var gottyfirstrun=true;

export async function StartGotty()
{
  let pv = app.GetPrivateFolder().replace('files','')
  let pvhome = pv + 'no_backup' ;
  let gtp = pvhome + '/gotty' ;
  let tmpkp = pvhome + '/tmpk_anci.zip' ;
  let frp = pvhome + '/tmpk_firstrun.sh' ;
  let grp = pvhome + '/gruntm.sh' ;

  if(gottyfirstrun)
  {
    window.gottyport=prompt('Port 通訊埠',window.gottyport)||3333 ;
    gottyfirstrun=false

    let fssz = app.GetFileSize(tmpkp)
    fssz = fssz- -app.GetFileSize(frp)

    app.CopyFile("tmpk_anci.zip", tmpkp+1 );
    app.CopyFile("tmpk_firstrun.sh", frp+1);

    let apksz = app.GetFileSize(tmpkp+1)
    apksz = apksz- -app.GetFileSize(frp+1)

    app.ShowPopup(["version",fssz,apksz]);
    if(fssz!=apksz)
    {
      app.DeleteFile(tmpkp)
      app.DeleteFile(frp)
      app.RenameFile( (tmpkp+1) , tmpkp ) ;
      app.RenameFile( (frp+1) , frp ) ;

      let r = app.SysExec(`sh ${frp}; exit`,"sh,log");
      alert(r);
    }
  }

  if(await hasurl('http://localhost:'+window.gottyport))
    return;

  if(!app.FileExists(gtp))
  {
    app.CopyFile("gotty", gtp );
  }

  app.SysExec(`linker64 ${gtp} `+
        `-w -p ${window.gottyport} `+
        `sh -c 'cd ${pvhome} ; exec sh ${grp} bash'`+
        `; `,"sh,log,noread");

  alert('Server running at http://localhost:'+window.gottyport);
}


export async function LoadGottyWebpage(url)
{
  //lay.Hide()

  if(!url)
    window.modw.web2.LoadUrl('http://localhost:'+window.gottyport)
  else
    window.modw.web2.LoadUrl(url)
}

/*
function SwitchtoGottyWebpage()
{
  lay.Hide();
}
*/

export function hasurl(url)
{
  return new Promise(resolve=>{

  fetch(url, { method: "HEAD" })
  .then(res => {
    if (res.ok) {
      csl("Exist! 存在 ✅");
      resolve(true);
    } else {
      csl("Not exist! 不存在 ❌，Code狀態碼：", res.status);
      resolve(false)
    }
  })
  .catch(err => {
    csl("Bad request! 請求錯誤 🚫", err);
    resolve(false);
  });

  });
}
