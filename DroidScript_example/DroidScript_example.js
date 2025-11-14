
//Called when application is started.
async function onStart()
{
  window.gottyport = 3333 ;
  window.modw = await import( "./webconsole.js" );
  modw.startWebconsole()
  window.OnConfig=modw.OnConfig
  //alert(import.meta.url)
  /*
  let mod = await import( "./libds/anci_droidscript.js" );
  Object.assign( window, mod ) ;

  OnStart()
  */
}
