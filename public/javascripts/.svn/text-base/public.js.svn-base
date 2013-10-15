function ge(id){return document.getElementById(id);}
function gebn(name){return document.getElementsByName(name);}
function trim(str){return str.replace(/^\s*(.*?)[\s\n]*$/g,  '$1');}
function a_submit(form, UpdateElementId){ //异步提交表单
    if (UpdateElementId==""){
      new Ajax.Request(form.action, {asynchronous:true, evalScripts:true, onComplete:function(request){eval(request.responseText)}, parameters:Form.serialize(form)});
    }else{
      new Ajax.Updater(UpdateElementId, form.action, {asynchronous:true, evalScripts:true, parameters:Form.serialize(form)});
    }
}
function a_link(url, UpdateElementId){ //异步执行链接
    if (UpdateElementId==""){
      new Ajax.Request(url, {asynchronous:true, evalScripts:true, onComplete:function(request){eval(request.responseText)}});
    }else{
      new Ajax.Updater(UpdateElementId, url, {asynchronous:true, evalScripts:true});
    }
}
function EncodeURI(str){
    var   m="",sp="!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~"
    for(var   i=0;i<str.length;i++){
    if(sp.indexOf(str.charAt(i))!=-1){
    m+=str.charAt(i)
    }else{
    var   n=str.charCodeAt(i)
    var   t="0"+n.toString(8)
    if(n>0x7ff)
    m+=("%"+(224+parseInt(t.slice(-6,-4),8)).toString(16)+"%"+(128+parseInt(t.slice(-4,-2),8)).toString(16)+"%"+(128+parseInt(t.slice(-2),8)).toString(16)).toUpperCase()
    else   if(n>0x7f)
    m+=("%"+(192+parseInt(t.slice(-4,-2),8)).toString(16)+"%"+(128+parseInt(t.slice(-2),8)).toString(16)).toUpperCase()
    else   if(n>0x3f)
    m+=("%"+(64+parseInt(t.slice(-2),8)).toString(16)).toUpperCase()
    else   if(n>0xf)
    m+=("%"+n.toString(16)).toUpperCase()
    else
    m+=("%"+"0"+n.toString(16)).toUpperCase()
    }
    }
    return   m;
}
function page_index_list(recordcount, pagesize, curpage, curlist, listsize){
	pagecount = Math.ceil(recordcount / pagesize);
	if (curlist==0) curlist = Math.ceil(curpage / listsize);
	startpage = listsize * (curlist - 1) + 1;
	endpage = startpage + listsize - 1;
	if (endpage > pagecount) endpage = pagecount
	str = "";

	if (curpage==1)
	  str += "前一页　"
	else
	  str += "<a href='javascript:gotopage(" + (curpage-1) + ");' title='跳转至前一页' target='_self'>前一页</a>　";

	if (curlist==1)
	str += "<< ";
	else
	str += "<a href='javascript:page_index_list(recordcount, pagesize, curpage, cur_list-1, listsize);' title='显示前一批页码' target='_self'><<</a> ";

	for (var i = startpage; i <= endpage; i++)
	{
		if (i.toString().length == 1) i = "0" + i;
		if (i == curpage)
			str += (i + " ");
		else
			str += ("<a href='javascript:gotopage(" + i + ");' title='跳转至第" + i + "页' target='_self'>" + i + "</a> ");
	}

	if (curlist==Math.ceil(pagecount / listsize))
	str += ">>　";
	else
	str += "<a href='javascript:page_index_list(recordcount, pagesize, curpage, cur_list+1, listsize);' title='显示后一批页码' target='_self'>>></a>　";

	if (curpage==pagecount)
	  str += "后一页 "
	else
	  str += "<a href='javascript:gotopage(" + (curpage+1) + ");' title='跳转至后一页' target='_self'>后一页</a> ";
	if (recordcount==0) str = "[没有任何数据记录]"
	document.getElementById("pagelist").innerHTML = str;
	cur_list = curlist;
}

function StrLenthByByte(str){ 	//计算字符串的字节长度，即英文算一个，中文算两个字节
	var len; 
	var i; 
	len = 0; 
	for (i=0;i<str.length;i++) 
	{ 
		if (str.charCodeAt(i)>255) len+=2; else len++; 
	} 
	return len; 
} 

function blank_filter(str){		//过滤空格
	while (str.indexOf(" ")>=0||str.indexOf("　")>=0){
			str = str.replace(" ","").replace("　","");
	}
	return str;
}

function generate_select_by_number(num1, num2, selected, firstoption, id, params){
	str = "<select";
	if (trim(id)!="") str += " id='" + id + "'";
	if (trim(params)!="") str += " " + params;
	str += ">"
	if (trim(firstoption)!="") str += "<option value=''>" + firstoption + "</option>";
	for (i=num1; i<=num2; i++)
	{

		str += "<option value='" + i + "'";
		if (selected==i) str += " selected";
		str += ">" + i + "</option>";
	}
	str += "</select>";
	return str;
}