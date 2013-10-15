function checklistform(obj){
    if(trim(obj.co_subject.value) =="" || trim(obj.co_subject.value).length ==0){
        alert("请输入问题标题");
        obj.co_subject.focus();
        return false;
    }
    if(trim(obj.co_desc.value) =="" || trim(obj.co_desc.value).length ==0){
        alert("请输入问题描述");
        //        obj.co_desc.focus();
        return false;
    }
    if(trim(obj.co_guest_email.value) =="" || trim(obj.co_guest_email.value).length ==0){
        alert("请输入邮件地址");
        obj.co_guest_email.focus();
        return false;
    }
    else{
        var emailPat = /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$/;
        var matchArray = (trim(obj.co_guest_email.value)).match(emailPat);
        if(matchArray == null){
            alert("请输入正确格式的邮件地址");
            obj.co_guest_email.focus();
            return false;
        }
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