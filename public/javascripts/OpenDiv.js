document.write("<style>#Loading {position:absolute;z-index:10;left:10px;top:10px;border:1px #666666 solid;background:#eeeeee;width:10px;height:10px}</style>");
function $(){return document.getElementById?document.getElementById(arguments[0]):eval(arguments[0]);}
var OverH,OverW,ChangeDesc,ChangeH=50,ChangeW=50;
function OpenDiv(_Dw,_Dh,_Desc) {
$("Loading").innerHTML="";
OverH=_Dh;OverW=_Dw;ChangeDesc=_Desc;
$("Loading").style.display='';
if(_Dw>_Dh){ChangeH=Math.ceil((_Dh-10)/((_Dw-10)/50))}else if(_Dw<_Dh){ChangeW=Math.ceil((_Dw-10)/((_Dh-10)/50))}
$("Loading").style.top=(document.documentElement.clientHeight-10)/2+"px";
$("Loading").style.left=(document.documentElement.clientWidth-10)/2+"px";
OpenNow()
}
var Nw=10,Nh=10;
function OpenNow() {
if (Nw>OverW-ChangeW)ChangeW=2;
if (Nh>OverH-ChangeH)ChangeH=2;
Nw=Nw+ChangeW;Nh=Nh+ChangeH;

if(OverW>Nw||OverH>Nh) {
	if(OverW>Nw) {
	$("Loading").style.width=Nw+"px";
	$("Loading").style.left=(document.documentElement.clientWidth-Nw)/2+"px";
	}
	if(OverH>Nh) {
	$("Loading").style.height=Nh+"px";
	$("Loading").style.top=(document.documentElement.clientHeight-Nh)/2+"px"
	}
	window.setTimeout("OpenNow()",10)
	}else{
	Nw=10;Nh=10;ChangeH=50;ChangeW=50;
	$("Loading").innerHTML=ChangeDesc;
	}
}