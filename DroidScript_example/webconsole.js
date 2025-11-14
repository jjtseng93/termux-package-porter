
import { StartGotty,LoadGottyWebpage } from './backend.js'


export var web2
export var lay2
var btnL,btnR,btnQ
var layh1,layh2,tdk


const btnw=0.14
const wvhp=0.4771
const wvhl=0.7781

if(!globalThis.alert)
{
  var alert=console.log;
}
else
{
  var alert=globalThis.alert;
  var prompt = globalThis.prompt
}
  
if(typeof(app)=='undefined')
  var app=globalThis.app;

var spstate={ctrl:false,shift:false,alt:false};

var btn1gen={
  "Tab\nshf":["TAB","shift"],
  "Esc\nq":["ESCAPE","^Q"],
  "^S\nd":[   "^S",     "^D"],
  "^F\nn" :[   "^F",     "^N"],
  "↑\ntop":  [ "DPAD_UP","^MOVE_HOME" ],
  "^Z\ny":[  "^Z",    "^Y"],
  "PGU":      [ "PAGE_UP",    "MOVE_HOME"]
};

var btn2gen={
  "Ctrl alt":[  "ctrl",   "alt" ],
  "^C x":[   "^C",     "^X" ],
  "^V ot":[   "^V",     "func"],
  "u ←":[  "DPAD_LEFT",    "^U"],
  "↓":   [  "DPAD_DOWN", "^MOVE_END"],
  "→ k":[  "DPAD_RIGHT",    "^K"],
  "PGD":["PAGE_DOWN",  "MOVE_END"]
};

export async function startWebconsole()
{
    StartGotty()
    
    await new Promise(res=>setTimeout(res,1000));
    
    lay2 = app.CreateLayout( "linear", "FillXY,Top,Left" );
    layh1 = app.CreateLayout( "linear","FillX,Horizontal,Left" )
    layh2 = app.CreateLayout( "linear","FillX,Horizontal,Left" )
    
     web2 = app.CreateWebView( 1, wvhp, "Progress" );
     OnConfig();
     web2.SetOnProgress( web2_OnProgess );
     lay2.AddChild( web2 );
     
     let dw=app.GetDisplayWidth()
     let dh=app.GetDisplayHeight()
     let sw=app.GetScreenWidth(  )
     let sh=app.GetScreenHeight(  )
     let minwh
     
     let o=app.GetOrientation()
     if(o[0]=="P") 
       minwh=dw;
     else
       minwh=sh;
    
     //web2.SetSize(w,h,'px')
     
     btnQ=app.CreateButton( "q" )
     btnQ.SetOnTouch( onkeyQ )
     btnQ.SetOnLongTouch(function(){
     	web2.Execute(prompt('execute in webview'));
     })
     btnQ.SetBackColor( 'red' )
     //btnQ.SetOnLongTouch( smkeyQc )
     
     
     
     
     for(let t in btn1gen)
     {
       
       //app.Debug([t,p,lp])    0.147
       let tbtn=app.CreateButton(t,btnw);
       tbtn.SetSize( btnw*minwh,null,'px' )
       layh1.AddChild( tbtn );
       //tbtn.SetOnTouch( (function(){alert(this.GetText())}) )
       //continue
      
          tbtn.SetOnTouch( function(){
            let tt=this.GetText()
            
            let [p,lp]=btn1gen[tt];
            
            if(["ctrl","alt","shift",'meta'].includes(p))
              return specialkeys(p);
            
            if(p[0]=="^")
              web2.SimulateKey( p.slice(1), "META_CTRL_ON"  );
            else
              web2.SimulateKey( p )
          });  //  tbtn set on touch
          
          tbtn.SetOnLongTouch( function(){
            let tt=this.GetText();
            let [p,lp]=btn1gen[tt];
            
            if(["ctrl","alt","shift",'meta'].includes(lp))
              return specialkeys(lp);
            
            if(lp[0]=="^")
              web2.SimulateKey( lp.slice(1), "META_CTRL_ON"  );
            else
              web2.SimulateKey( lp )
          });  //  tbtn set on touch
          
         
     }  //  for t in btn1gen
     
     for(let t in btn2gen)
     {
       
       //app.Debug([t,p,lp])
       let tbtn=app.CreateButton(t,btnw );
       tbtn.SetSize( btnw*minwh,null,'px' )
       layh2.AddChild( tbtn );
       //tbtn.SetOnTouch( (function(){alert(this.GetText())}) )
       //continue
      
          tbtn.SetOnTouch( function(){
            let tt=this.GetText();
            let [p,lp]=btn2gen[tt];
            
            if(["ctrl","alt","shift",'meta'].includes(p))
              return specialkeys(p);
            
            if(p[0]=="^")
              web2.SimulateKey( p.slice(1), "META_CTRL_ON"  );
            else
              web2.SimulateKey( p )
          });  //  tbtn set on touch
          
          tbtn.SetOnLongTouch( function(){
            let tt=this.GetText();
            let [p,lp]=btn2gen[tt];
            
            if(["ctrl","alt","shift",'meta'].includes(lp))
              return specialkeys(lp);
              
            if(lp=='func')
              return customkey();
            
            if(lp[0]=="^")
              web2.SimulateKey( lp.slice(1), "META_CTRL_ON"  );
            else
              web2.SimulateKey( lp )
          });  //  tbtn set on touch
          
         
     }  //  for t in btn2gen
     
     /*
     btnL=app.CreateButton( "u←Left" )
     btnL.SetOnTouch( smkeyL )
     btnL.SetOnLongTouch( smkeyLc )
     
     btnR=app.CreateButton( "Right→k" )
     btnR.SetOnTouch( smkeyR )
     btnR.SetOnLongTouch( smkeyRc )

     layh2.AddChild( btnL );
     layh2.AddChild( btnR )
     */
     layh2.AddChild( btnQ );
     
     app.AddLayout( lay2 );
     lay2.AddChild( layh1 )
     lay2.AddChild( layh2 )

     web2.SetOnTouch(()=>{
       spstate.ctrl=false;
       spstate.alt=false;
       spstate.shift=false;     	
     })
     
     tdk=app.CreateTextEdit("");

     tdk.SetOnChange(function(){
       let t=this.GetText().replaceAll("*","")
                           .replaceAll("\n","");
       this.SetText('')  //"**\n**\n**");

       let key=spstate.ctrl?'ctrl':'alt';
       web2.Focus();
       web2.SimulateKey( t ,
             "META_"+key.toUpperCase()+"_ON",
             100 );
       spstate.ctrl=false;
       spstate.alt=false;
       spstate.shift=false;
        
     });
     
     layh1.AddChild( tdk )

     web2.LoadUrl( "http://localhost:" + globalThis.gottyport );
}

export function specialkeys(key)
{
  if(key=='shift')
    var r=prompt(key+"+?");
  else
    var r=0;

  if(!r)
  {
    tdk.Focus();
    spstate[key]=true;
  	return 0;
  }
  
  let kmap={ up:"DPAD_UP", dn:"DPAD_DOWN",
                      lt:"DPAD_LEFT",rt:"DPAD_RIGHT" };
                      
  if(kmap[r]) r=kmap[r] ;
  
  web2.SimulateKey(r ,
      "META_"+key.toUpperCase()+"_ON",
      100 );
}

export function customkey(key)
{
  web2.SimulateKey( key || prompt(),null,100 )
}

export function OnConfig()
{
  let o=app.GetOrientation()
  if(o[0]=="P")
    web2.SetSize( 1,wvhp );
  else
    web2.SetSize( 1,wvhl );
  
}

function onkeyQ()
{
  if(confirm('Reload?'))
    web2.Reload();
  //globalThis.lay.Show();
}

function web2_OnProgess( progress )
{
    if(progress==100)
      //alert('load complete');
    app.Debug( "progress = " + progress );
}

function smkeyL()
{
  //app.ShowPopup(  'btn pressed')
  web2.SimulateKey( "DPAD_LEFT" )
}

function smkeyLc()
{
  //web2.SimulateKey( "CTRL_LEFT" )
  web2.SimulateKey( "U","META_CTRL_ON" )
}

function smkeyR()
{
  //app.ShowPopup(  'btn pressed')
  web2.SimulateKey( "DPAD_RIGHT" )
}

function smkeyRc()
{
  //web2.SimulateKey( "CTRL_LEFT" )
  web2.SimulateKey( "K","META_CTRL_ON" )
}
