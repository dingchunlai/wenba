function getCookie(c_name){
if (document.cookie.length>0)
  {
  c_start=document.cookie.indexOf(c_name + "=")
  if (c_start!=-1)
    {
    c_start=c_start + c_name.length+1
    c_end=document.cookie.indexOf(";",c_start)
    if (c_end==-1) c_end=document.cookie.length
    return unescape(document.cookie.substring(c_start,c_end))
    }
  }
return ""
}
if (getCookie("ind_id")==""){		//未登录
    document.write("<a href='#de' onclick=\"Divopop('Login');return false;\">会员登录</a> <a href='http://member.51hejia.com/member/reg?forward=" + top.location.href + "' target='_blank'>会员注册</a> <a href='http://member.51hejia.com/member/expert_reg?forward=" + top.location.href + "' target='_blank'>专家注册</a>");
}else{		//已登录
  document.write("<a href='/mine/index' target='_blank'>用户中心</a>　<a href='http://member.51hejia.com/member/loginout?forward=" + top.location.href + "' target='hideiframe_loginout'>注销登录</a>");
}