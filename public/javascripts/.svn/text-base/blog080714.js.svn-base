function checkChoicesForm(obj){
    var len = document.getElementById(obj).length
    var checked = false; 

    for (i = 0; i < len; i++) 
    { 
        if (document.getElementById(obj)[i].checked == true) 
        { 
            checked = true;
            return true;
            //break; 
        } 
    } 
    if (!checked) 
    { 
        alert("请至少选择一条记录！"); 
        return false; 
    }
}

function doListSortChoice(obj){
    //c_sort = document.getElementById(cc_sort).value
    document.getElementById(obj).action = "/blog/list_blog_sort";
    document.getElementById(obj).submit();
}


function CheckMessage(name){
    for(var i=0; i< document.getElementsByName(name).length; i++){
        var e = document.getElementsByName(name)[i];
        e.checked = true;
    }
}

function uncheckmessage(name){
  for(var i=0; i< document.getElementsByName(name).length; i++){
        var e = document.getElementsByName(name)[i];
        e.checked = false;
    }
}

function store_messages(obj){
    document.getElementById(obj).action="/store/messages";
    document.getElementById(obj).submit();
}

function trash_messages(obj){
    document.getElementById(obj).action="/trash/messages";
    document.getElementById(obj).submit();
}

function empty_messages(obj,bid){
    document.getElementById(obj).action="/empty/messages/"+bid;
    document.getElementById(obj).submit();
}

function delete_messages(obj){
    document.getElementById(obj).action="/delete/messages";
    document.getElementById(obj).submit();
}

function destroy_messages(obj){
    document.getElementById(obj).action="/destroy/messages";
    document.getElementById(obj).submit();
}

function check_blog_name_form(obj){
    blog_name = trim(document.getElementById("blog[name]").value)  
    if(blog_name ==""){
        alert("请输入博客名称");
        //obj.blog[name].focus();
        document.getElementById("blog[name]").focus();
        return false;  
    }
}

function check_reply_message_form(obj){
    if(trim(obj.s_m_receive_user.value) == "" || trim(obj.s_m_receive_user.value)== 0){
        alert("请输入收件人名称");
        obj.s_m_receive_user.focus();
        return false;
    }
    
    if(trim(obj.s_m_content.value) == "" || trim(obj.s_m_content.value).length == 0){
        alert("请输入回复内容");
        obj.s_m_content.focus();
        return false;
    }
}

function save_draft()
{
    if (document.getElementById('c_subject').value =="" || document.getElementById('c_subject').length ==0)
    {
        alert("请输入标题");
        document.getElementById('c_subject').focus();
        return false;
    }
    else
    {
        document.getElementById('creat_form').action = "/blog/save_draft";
        document.getElementById('creat_form').submit();
    }
}

function save_draft_modify()
{
    if (document.getElementById('m_subject').value =="" || document.getElementById('m_subject').length ==0)
    {
        alert("请输入标题");
        document.getElementById('m_subject').focus();
        return false;
    }
    else
    {
        document.getElementById('modify_form').action = "/blog/save_draft_modify";
        document.getElementById('modify_form').submit();
    }
}

function check_creat_form(obj)
{
    if(trim(obj.c_subject.value) =="" || trim(obj.c_subject.value).length ==0){
        alert("请输入标题");
        obj.c_subject.focus();
        return false;
    }
    if(trim(tinyMCE.getInstanceById("c_description").getBody().innerHTML) =="" || trim(tinyMCE.getInstanceById("c_description").getBody().innerHTML).length ==0){
        alert("请输入内容");
        return false;
    }
}

function check_modify_form(obj)
{
    if(trim(obj.m_subject.value) =="" || trim(obj.m_subject.value).length ==0){
        alert("请输入标题");
        obj.m_subject.focus();
        return false;
    }
    if(trim(tinyMCE.getInstanceById("m_description").getBody().innerHTML) =="" || trim(tinyMCE.getInstanceById("m_description").getBody().innerHTML).length ==0){
        alert("请输入内容");
        return false;
    }
}

function show_add_category_div()
{
    if (document.getElementById("c_category").value == 0)
    {
        document.getElementById("add_category_div").style.display = "block";
        return false;
    }
    else
    {
        document.getElementById("add_category_div").style.display = "none";
        return false;            
    }
}

function checkreplyform(obj)
{
    if(trim(tinyMCE.getInstanceById("r_content").getBody().innerHTML) =="" || trim(tinyMCE.getInstanceById("r_content").getBody().innerHTML).length ==0){
        alert("请输入内容");
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

function check_send_message_form(obj)
{
    if(trim(obj.s_m_receive_user.value) =="" || trim(obj.s_m_receive_user.value).length ==0){
        alert("请输入收件人");
        obj.s_m_receive_user.focus();
        return false;
    }   
    if(trim(obj.s_m_content.value) =="" || trim(obj.s_m_content.value).length ==0){
        alert("请输入内容");
        obj.s_m_content.focus();
        return false;
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