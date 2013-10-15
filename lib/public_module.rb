module PublicModule

  #数据获取及处理

  def get_key(prefix, *keywords)
    return ["#{MEMCACHE_PREFIX_KEY}_#{prefix}"].concat(keywords).join("_").gsub(" ","")
  end

  def mc(key, value="", expire=7.days)  #memorycache快捷存取方法（旧方法）
    if value == ""
      return CACHE.get(key)
    else
      begin
        expire = 1 if value.nil?
        CACHE.set(key, value, expire)
        return true
      rescue Exception => e
        return false
      end
    end
  end

  def get_cache_key(templet, *values)
    0.step(values.length-1, 2) do |i|
      templet = templet.sub(values[i].to_s, values[i+1].to_s)
    end
    return templet.gsub(" ","")
  end

  #尝试获取相应关键字的memcache缓存
  def get_memcache(kw, expire=1.month)
    rv = memcache(kw)
    if rv.nil?
      rv = yield
      memcache(kw, rv, expire)
    end
    return rv
  end

  #调用或保存本地memcache缓存缓存
  def memcache(kw, value=nil, expire=1.month)
    kw = kw.to_s.gsub(" ","")
    fail("The memcache's keyword can't be blank!") if kw.blank?
    if value.nil?
      return CACHE.get(kw)
    else
      if expire == 0
        CACHE.set(kw, value)
      else
        expire = 1.month if expire > 1.month
        CACHE.set(kw, value, expire)
      end
    end
  end

  def expire_memcache(key)
    kw = kw.to_s.gsub(" ","")
    CACHE.set(key, nil, 1)
  end

  #取得“通过多个关键字查询到的数据集合”，并返回其中指定数量的记录。
  def get_rs_by_any_keywords(kws, limit)
    ars = []
    for kw in kws.split(",")
      rs = yield(kw, limit)
      for r in rs
        ars << r
        return ars if ars.length == limit
      end
    end
    return ars
  end

  def ul(str, len, preview=0, replacer="...")
    if preview == 1
      str = "预览内容" * 80
    end
    str = strip_tags(str.to_s)
    if str.length > 0
      s = str.split(//u)
      if s.length > len.to_i && len.to_i != 0
        return s[0, len.to_i].to_s + replacer
      else
        return str
      end
    else
      return ""
    end
  end

  def isrole(*name)
    user_id = user_logged_in? ? current_user.id : 0
    if user_id.class != String
      if cookies["ind_id"].nil?
        user_id = 0
      else
        user_id = cookies["ind_id"][0].to_i
      end
    end
    return true if is_web_admin(user_id)
    if cookies["login_user_rolename"].nil?
      return false
    else
      rv = false
      if cookies["login_user_rolename"].length > 0
        for n in name
          v = cookies["login_user_rolename"].value rescue cookies["login_user_rolename"]
          rv = true if v.to_s.split(' ').include?(n)
        end
      end
      return rv
    end
  end

  def is_web_admin(user_id=0)
    admins = []
    admins << 7213592 #林松波
    admins << 7252468 #孟超俊
    admins << 15086   #王晓艳
    if admins.include?(user_id.to_i) && user_id.to_i != 0
      return true
    else
      return false
    end
  end

  def expire_topic_info(topic_id) #清除某个问题详细信息的memcache缓存
    topic_id = topic_id.to_i
    if topic_id != 0
      kw = get_cache_key(KW_TOPIC_INFO, "topic_id", topic_id)
      mc(kw, nil)
    end
  end

  def get_parent_tag_id(tag_id)
    kw_parent_id = "parent_id_#{tag_id}"
    parent_id = mc(kw_parent_id).to_i
    if parent_id == 0
      tag = nil
      tag = Tag.find(tag_id,:select=>"parent_id") if tag_id.to_i > 0
      if tag.nil?
        parent_id = 1
      else
        parent_id = tag.parent_id.to_i
      end
      mc(kw_parent_id, parent_id)
    end
    return parent_id
  end
  def get_tag_name_by_tag_id(tag_id)
    tag_id = tag_id.to_i
    if tag_id != 0
      kw_tag = "tag_#{tag_id.to_s}"
      tag_name = mc(kw_tag)
      if tag_name.nil? #如果缓存不存在
        tag = Tag.find(tag_id, :select => "name") rescue nil
        if tag.nil?
          tag_name = "未知板块"
        else
          tag_name = tag.name
        end
        mc(kw_tag, tag_name)
      end
    else
      tag_name = "未知板块"
    end
    return tag_name
  end

  def get_username(user_id)
    return CommunityUser.get_username(user_id)
  end

  def get_question_num(user_id)
    return CommunityUser.get_question_num(user_id)
  end

  def get_answer_num(user_id)
    return CommunityUser.get_answer_num(user_id)
  end

  def get_user_id(username)
    return CommunityUser.get_user_id(username)
  end

  def get_user_point(user_id)
    return CommunityUser.get_point(user_id)
  end

  def set_user_point(user_id, score)
    return CommunityUser.set_point(user_id, score)
  end

  def is_expert(user_id)
    return CommunityUser.is_expert(user_id)
  end

  def to_natural_number(num)
    num = num.to_i
    num = 0 if num < 0
    return num
  end

  def iconv(str)
    if ENV['RAILS_ENV'] == "development"
      return iconv_utf8(str)
    else
      return iconv_gb2312(str)
    end
  end
  def r_iconv(str)
    if ENV['RAILS_ENV'] == "development"
      return iconv_gb2312(str)
    else
      return iconv_utf8(str)
    end
  end

  #数据库相关
  def dosql(str)
    return ActiveRecord::Base.connection.execute(str)
  end

  #字符串相关
  def strip(str)
    return str.to_s.lstrip.rstrip
  end
  def trim(str)
    return str.to_s.lstrip.rstrip
  end
  def left(str, length)
    if pp(str)
      return str[0, length]
    else
      return ""
    end
  end
  def right(str, length)
    if pp(str)
      if str.length > length
        return str[str.length - length, length]
      else
        return str
      end
    else
      return ""
    end
  end
  def replace(str, str1, str2)
    return str.gsub(str1, str2) if str
  end
  def pp(param) #判断一个变量是否存在字符串参数
    r = false
    unless param.nil?
      unless trim(param.to_s)==""
        r = true
      end
    end
    return r
  end
  def filter_first_letter(str, letter) #当字符串的首字母是letter时，过滤字母。
    if left(str,1)==letter
      return right(str,str.length-1)
    else
      return str
    end
  end
  def iconv_gb18030(str)
    begin
      str ? Iconv.iconv("UTF-8", "gb18030", str).join("") : str;
    rescue
      str;
    end
  end

  def iconv_gb2312(str)
    begin
      str ? Iconv.iconv("UTF-8", "gb2312", str).join("") : str;
    rescue
      str;
    end
  end
  def iconv_utf8(str)
    begin
      str ? Iconv.iconv("gb18030", "UTF-8", str).join("") : str;
    rescue
      str;
    end
  end

  #客户端相关
  def alert(str, *p)
    return js("alert(\"#{str}\")")
  end
  def alert_error(str, *p)
    return js("alert(\"#{str}\")")
  end
  def js(str, *p)
    return "<script type=\"text/javascript\">#{str.to_s}</script>"
  end
  def top_load(url)
    if url == "self"
      return "if (top!=self){ if (top.location.href.indexOf('#')==-1) top.location.href=top.location.href; else top.location.href=top.location.href.substring(0, top.location.href.indexOf('#'));}"
    elsif url == "reload"
      return "top.location.reload();"
    elsif pp(url)
      url = "\"" + url + "\""
      return "top.location.href = #{url};"
    end
  end
  def myrender(rv, load_url)
    rv = alert(rv) if rv != ""
    rv += js(top_load(load_url)) if load_url != nil
    rv = "" if params[:no_render].to_i == 1
    render :text => rv
  end

  #其它功能
  def get_error(exception)
    exception.to_s
  end
  def show_notice(str) #显示布告
    render :text => "<div style='line-height:30px; padding:30px'><b>#{str}</b><br /><br />\
<a href=\"#\" onclick=\"history.back();\">点这里返回前一页</a>"
  end
  def datediff(time1, time2)
    return ((time2 - time1)/(60*60*24)).to_i
  end
  def dateadd(time1, days)
    return time1 + days * (60*60*24)
  end
  def getnow()
    return Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end

end