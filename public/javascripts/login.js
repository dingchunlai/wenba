var BgDiv=document.createElement("div");
function Divopop(ID){
    zhucela();denglula();pswla();
    var Moled=document.getElementById(ID);
    Moled.style.display="block";
    var bodyw=document.body.scrollWidth;
    var bodyh=document.body.scrollHeight;
    var firefox = document.getElementById && !document.all;
    BgDiv.style.position="absolute";
    BgDiv.style.left="0";
    BgDiv.style.top="0";
    BgDiv.style.width=bodyw+"px";
    BgDiv.style.height=bodyh+"px";
    BgDiv.style.zindex="50";
    if(firefox==false){BgDiv.style.background="url(http://www.51hejia.com/css/newback/images/divbg.png)";BgDiv.style.filter="Alpha(Opacity=50)";}else

    {BgDiv.style.background="url(http://www.51hejia.com/css/newback/images/divbg.png)";}
    document.body.appendChild(BgDiv);
    var As=document.getElementsByTagName("a");
    for (var i=0;i<As.length;i++){
        if(As[i].className=="Divopop-none"){
            As[i].onclick=function(){Moled.style.display="none";BgDiv.style.display="none";return false;};
        }
        else if(As[i].className=="othen"){
            As[i].onclick=function(){
                var othenId=this.getAttribute("toid");
                var othenDiv=document.getElementById(othenId);
                Moled.style.display="none";
                othenDiv.style.display="block";
                return false;
            };
        }
        else if(As[i].className=="Divopop-nonenei"){
            As[i].onclick=function(){this.parentNode.style.display="none";BgDiv.style.display="none";return false;};
        }
    }
}