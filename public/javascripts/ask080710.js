function CheckAll(name,obj){
    for (var i=0; i<document.getElementsByName(name).length; i++){
        var e = document.getElementsByName(name)[i];
        e.checked = document.getElementById(obj).checked;
    }
}

function Preview()
{
    var ti = encodeURI(document.getElementsByName("ti")[0].value)
    //    var co = encodeURI(document.getElementsByName("co")[0].value)
    var co = encodeURI(tinyMCE.getInstanceById("co").getBody().innerHTML)
    var cid = encodeURI(document.getElementsByName("cid")[0].value)
    var ut = encodeURI(document.getElementsByName("ut")[0].value)
    var url = "/user/preview"+"?ti="+ti+"&co="+co+"&cid="+cid+"&ut="+ut
    window.open(url, "_blank")
}

function Preview_Share()
{
    var ti = encodeURI(document.getElementsByName("ti")[0].value)
    //    var co = encodeURI(document.getElementsByName("co")[0].value)
    var co = encodeURI(tinyMCE.getInstanceById("co").getBody().innerHTML)
    var cid = encodeURI(document.getElementsByName("cid")[0].value)
    var ut = encodeURI(document.getElementsByName("ut")[0].value)
    var co2 = encodeURI(document.getElementsByName("co2")[0].value)
    var url = "/user/preview_share"+"?ti="+ti+"&co="+co+"&cid="+cid+"&ut="+ut+"&co2="+co2
    window.open(url, "_blank")
}

function Preview_discussion()
{
    var ti = encodeURI(document.getElementsByName("ti")[0].value)
    //    var co = encodeURI(document.getElementsByName("co")[0].value)
    var co = encodeURI(tinyMCE.getInstanceById("co").getBody().innerHTML)
    var cid = encodeURI(document.getElementsByName("cid")[0].value)
    var ut = encodeURI(document.getElementsByName("ut")[0].value)
    var co2 = encodeURI(document.getElementsByName("co2")[0].value)
    var url = "/user/preview_discussion"+"?ti="+ti+"&co="+co+"&cid="+cid+"&ut="+ut+"&co2="+co2
    window.open(url, "_blank")
}

function Preview_Company()
{
    var name = encodeURI(document.getElementById("name").value)
    var description = encodeURI(tinyMCE.getInstanceById("co_description").getBody().innerHTML)
    var address = encodeURI(document.getElementById("address").value)
    var tel = encodeURI(document.getElementById("tel").value)
    var linkman = encodeURI(document.getElementById("linkman").value)
    var web_stage = encodeURI(document.getElementById("web_stage").value)
    var guild_id = encodeURI(document.getElementById("guild_id").value)
    var country = encodeURI(document.getElementById("country").value)
    var area = encodeURI(document.getElementById("area").value)
    
    var url = "/user/preview_company"+"?name="+name+"&description="+description+"&address="+
        address+"&tel="+tel+"&linkman="+linkman+"&web_stage="+web_stage+"&guild_id="+guild_id+
        "&country="+country+"&area="+area
    window.open(url, "_blank")
}

function So()
{
    var type = trim(document.getElementsByName("so_type")[0].value);
    var wd = trim(document.getElementsByName("so_wd")[0].value);
    if(wd == "" || wd.length == 0)
    {
        alert("请输入关键词");
        document.getElementsByName("so_wd")[0].focus();
    }
    else
    {
        var url = "";
        if (type == "图片") 
        { 
            var url = "http://so.51hejia.com/%CD%BC%C6%AC/"+wd+".rbml";
        }
        if (type == "资讯") 
        { 
            var url = "http://so.51hejia.com/%D7%CA%D1%B6/"+wd+".rbml";
        }
        if (type == "产品") 
        { 
            var url = "http://so.51hejia.com/%B2%FA%C6%B7/"+wd+".rbml";
        }
        if (type == "公司") 
        { 
            var url = "http://so.51hejia.com/%B9%AB%CB%BE/"+wd+".rbml";
        }
        window.open(url, "_blank");
    }
}

function checkform(obj){
    gcv();
    
    if(trim(obj.ti.value) =="" || trim(obj.ti.value).length ==0){
        alert("请输入问题标题");
        obj.ti.focus();
        return false;
    }
    var leftChars = getLeftChars(obj.ti,50);
    if ( leftChars < 0){
        ls_str = "问题字数限定在50个汉字以内，请缩短提问字数";
        alert(ls_str);
        obj.ti.focus();
        return false;
    }
    if(leftChars>92){
        ls_str = "问题标题不详细，请重新输入";
        alert(ls_str);
        obj.ti.focus();
        return false;
    }
    
    var co_length = trim(obj.co.value).length;
    if ( co_length >3000){
        ls_str = "问题补充说明字数限定在3000字节以内，请缩短字数";
        alert(ls_str);
        obj.co.focus();
        return false;
    }
    
    if(obj.cid.value=="" || obj.cid.value==0){
        alert("请选择问题分类");
        return false;
    }
    
    if(trim(obj.email.value) =="" || trim(obj.email.value).length ==0){
        alert("请输入邮件地址");
        obj.email.focus();
        return false;
    }
    else{
        var emailPat = /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$/;
        var matchArray = (trim(obj.email.value)).match(emailPat);
        if(matchArray == null){
            alert("请输入正确格式的邮件地址");
            obj.email.focus();
            return false;
        }
    }
}

function checkreplyform(obj){
    //    ls_str = getCookie("ind_id");
    ls_str = 1;
    if (ls_str > 0)
    {
        if(trim(obj.ro.value) =="" || trim(obj.ro.value).length ==0){
            alert("请输入您的回答");
            //            obj.ro.focus();
            return false;
        }
    
        var ro_length = trim(obj.ro.value).length;
        if ( ro_length < 10){
            ls_str = "回答不详细，请重新输入";
            alert(ls_str);
            //            obj.ro.focus();
            return false;
        }
        
        if(trim(obj.email.value) =="" || trim(obj.email.value).length ==0){
            alert("请输入邮件地址");
            obj.email.focus();
            return false;
        }
        else{
            var emailPat = /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$/;
            var matchArray = (trim(obj.email.value)).match(emailPat);
            if(matchArray == null){
                alert("请输入正确格式的邮件地址");
                obj.email.focus();
                return false;
            }
        }
    }
    else
    {
        alert("请先登录");
        return false;
    }
}

function checksearchform(obj){
    if(trim(obj.wd.value) =="" || trim(obj.wd.value).length ==0){
        alert("请输入关键词");
        obj.wd.focus();
        return false;
    }
}

// utility function called by getCookie()
function getCookieVal(offset)
{
    var endstr = document.cookie.indexOf(";", offset);
    if(endstr == -1)
    {
        endstr = document.cookie.length;
    }
    return unescape(document.cookie.substring(offset, endstr));
}

// primary function to retrieve cookie by name
function getCookie(name)
{
    var arg = name + "=";
    var alen = arg.length;
    var clen = document.cookie.length;
    var i = 0;
    while(i < clen)
    {
        var j = i + alen;
        if (document.cookie.substring(i, j) == arg)
        {
            return getCookieVal(j);
        }
        i = document.cookie.indexOf(" ", i) + 1;
        if(i == 0) break;
    }
    return;
}

function isLogin()
{
    //    ls_str = getCookie("ind_id");
    ls_str = 1;
    if (ls_str > 0)
    {
        window.open('/user/ask', '_self');
    }
    else
    {
        alert("请先登录");
    }
}

function isLoginEntry()
{
    //    ls_str = getCookie("ind_id");
    ls_str = 1;
    if (ls_str > 0)
    {
        window.open('/user/share', '_self');
    }
    else
    {
        alert("请先登录");
    }
}

function isLogindiscussion()
{
    //    ls_str = getCookie("ind_id");
    ls_str = 1;
    if (ls_str > 0)
    {
        window.open('/user/discussion', '_self');
    }
    else
    {
        alert("请先登录");
    }
}

function isLoginCompany()
{
    //    ls_str = getCookie("ind_id");
    ls_str = 1;
    if (ls_str > 0)
    {
        window.open('/user/company', '_self');
    }
    else
    {
        alert("请先登录");
    }
}

function ltrim(s){
    return s.replace( /^\s*/, "");
}

function rtrim(s){
    return s.replace( /\s*$/, "");
}

function trim(s){
    return rtrim(ltrim(s));
}

function getLeftChars(varField,limit_len) {
    var i = 0;
    var counter = 0;
    var cap = limit_len*2;
    var j=0;
    var runtime = (varField.value.length>cap)?(cap+1):varField.value.length;
    for (i = 0; i< runtime; i++) {
        if (varField.value.charCodeAt(i) > 127 || varField.value.charCodeAt(i) == 94) {
            j=j+2;
        }
        else {
            j=j+1
        }
    }  //结束FOR循环
    //var leftchars = cap - varField.value.length;
    var leftchars = cap - j;
    return (leftchars);
}

function  gcv(){
    var  aa  =  document.getElementsByName("ra");
    for  (var  i=0;  i<aa.length;  i++)
    {
        if(aa[i].checked)
            document.ftiwen.cid.value = aa[i].value;
    }
}

function So_S()
{
    var date1 = trim(document.getElementsByName("date1")[0].value);
    var date2 = trim(document.getElementsByName("date2")[0].value);
    if(date1 == "" || date1.length == 0)
    {
        alert("请输入起始时间");
        document.getElementsByName("date1")[0].focus();
    }
    else if(date2 == "" || date2.length == 0)
    {
        alert("请输入结束时间");
        document.getElementsByName("date2")[0].focus();
    }
    else if (date1 > date2)
    {
        alert("起始时间不得早于结束时间");
        document.getElementsByName("date1")[0].focus();
    }
}

function checkform_select(obj){
    if(trim(obj.wd.value) =="" || trim(obj.wd.value).length ==0){
        alert("请输入文章编号");
        obj.wd.focus();
        return false;
    }
}

function Preview1(){
    var wd = document.getElementsByName("wd")[0].value
    if(wd =="" || wd.length ==0){
        alert("请输入文章编号");
        document.getElementsByName("wd")[0].focus();
        return false;
    }
    else
    {
        var wd = encodeURI(document.getElementsByName("wd")[0].value) 
        var url = "/visitor/question/"+wd+".html";
        window.open(url, "_blank");
        return false;
    }  
}

function Showtoday()
{
    var date1 = trim(document.getElementsByName("date1")[0].value);
    var date2 = trim(document.getElementsByName("date2")[0].value);
    if(date1 == "" || date1.length == 0)
    {
        alert("请输入起始时间");
        document.getElementsByName("date1")[0].focus();
        return false;
    }
    else if(date2 == "" || date2.length == 0)
    {
        alert("请输入结束时间");
        document.getElementsByName("date2")[0].focus();
        return false;
    }
    if(date1 > date2 && date2 != "")
    {
        alert("起始时间不得早于结束时间");
        document.getElementsByName("date1")[0].focus();
        return false;
    }  
}

function checkshareform(obj){
    gcv();
    
    if(trim(obj.ti.value) =="" || trim(obj.ti.value).length ==0){
        alert("请输入词条名称");
        obj.ti.focus();
        return false;
    }
    var leftChars = getLeftChars(obj.ti,50);
    if ( leftChars < 0){
        ls_str = "词条字数限定在50个汉字以内，请缩短词条字数";
        alert(ls_str);
        obj.ti.focus();
        return false;
    }
    if(leftChars > 92){
        ls_str = "词条名称不能少于8个字节，请重新输入";
        alert(ls_str);
        obj.ti.focus();
        return false;
    }
    
    if(trim(obj.co.value) =="" || trim(obj.co.value).length ==0){
        alert("请输入详细内容");
        //        obj.co.focus();
        return false;
    }
    var leftChars2 = getLeftChars(obj.co,3000);
    if ( leftChars2 < 0){
        ls_str = "详细内容字数限定在3000个汉字以内，请缩短详细内容字数";
        alert(ls_str);
        //        obj.co.focus();
        return false;
    }
    if(leftChars2 > 5900){
        ls_str = "内容不能少于100个字节，请重新输入";
        alert(ls_str);
        //        obj.co.focus();
        return false;
    }
    
    if(obj.cid.value=="" || obj.cid.value==0){
        alert("请选择分类");
        return false;
    }
    
    if(trim(obj.email.value) =="" || trim(obj.email.value).length ==0){
        alert("请输入邮件地址");
        obj.email.focus();
        return false;
    }
    else{
        var emailPat = /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$/;
        var matchArray = (trim(obj.email.value)).match(emailPat);
        if(matchArray == null){
            alert("请输入正确格式的邮件地址");
            obj.email.focus();
            return false;
        }
    }
}

function checkcompanyform(obj){

    cn_name = trim(obj.name.value);
    if(cn_name == "" || cn_name.length == 0){
        alert("请输入公司名称");
        document.getElementById("name").focus();
        return false;
    } 
    
    if(trim(obj.co_description.value) =="" || trim(obj.co_description.value).length ==0){
        alert("请输入详细内容");
        return false;
    }
}

function dele()
{
    var wd = document.getElementsByName("wd")[0].value
    if(wd =="" || wd.length ==0){
        alert("请输入用户ID");
        document.getElementsByName("wd")[0].focus();
        return false;
    }
}

function dele1()
{
    var wd = document.getElementsByName("wd")[0].value
    if(wd =="" || wd.length ==0){
        alert("请输入用户ID");
        document.getElementsByName("wd")[0].focus();
        return false;
    }
}

function dele2()
{
    var wd = document.getElementsByName("wd")[0].value
    if(wd =="" || wd.length ==0){
        alert("请输入用户ID");
        document.getElementsByName("wd")[0].focus();
        return false;
    }
}

function submitForm(){
    if(document.urlForm.wd.value.length < 1){
        alert("请输入搜索信息");
        document.urlForm.wd.focus();
    }else{
        document.urlForm.action="http://so.51hejia.com";
        document.urlForm.submit();
    }
}

function piliang_tag(obj)
{
    if(obj.cid.value=="" || obj.cid.value==0){
        alert("请选择问题分类");
        return false;
    }
}