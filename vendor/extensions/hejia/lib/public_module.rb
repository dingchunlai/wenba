module PublicModule

  #数据获取及处理
  def mc(keyword,value=nil,expire_hours=72)  #memorycache快捷存取方法
    keyword = keyword.to_s.gsub(" ","")
    if value.nil?
      return CACHE.get(keyword)
    else
      if expire_hours == 0
        CACHE.set(keyword, value)
      else
        CACHE.set(keyword, value, expire_hours * 60 * 60)
      end
    end
  end

  def get_mc(kw_mc, expire_hours=72, update_cache=$update_cache)   #尝试获取相应关键字的memcache信息
    update_cache = false if update_cache == 0 || update_cache.nil?
    update_cache = true if update_cache == 1
    kw_mc = kw_mc.gsub(" ","")
    rv = mc(kw_mc)
    if rv.nil? || update_cache
      rv = yield
      mc(kw_mc, rv, expire_hours)
    end
    return rv
  end

  def get_memcache_key_prefix(key_name)  #取得key_name相关缓存关键字前缀
    return "" if trim(key_name).length == 0
    rv = mc(key_name)
    if rv.nil?
      rv = "#{key_name}#{rand(5000)+1}"
      mc(key_name, rv)
    end
    return rv
  end

  def get_mc_kw(sort, *kws)   #获取memcache关键词
    return [get_memcache_key_prefix(sort)].concat(kws).join("_").gsub(" ","")
  end
  
  def get_rs_by_any_keywords(kws, limit)  #取得“通过多个关键字查询到的数据集合”，并返回其中指定记录数。
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

  def get_redirect_key_url(name)
    if @redirect_key.nil?
      @redirect_key = Hash.new
      @redirect_key["新闻"] = "http://www.51hejia.com/xinwen/"
      @redirect_key["行业"] = "http://www.51hejia.com/xinwen/"
      @redirect_key["资讯"] = "http://www.51hejia.com/xinwen/"
      @redirect_key["卖场"] = "http://www.51hejia.com/maichang/"
      @redirect_key["博客"] = "http://blog.51hejia.com/"
      @redirect_key["装修"] = "http://d.51hejia.com/"
      @redirect_key["地板"] = "http://www.51hejia.com/diban/"
      @redirect_key["涂料"] = "http://www.51hejia.com/youqituliao/"
      @redirect_key["油漆"] = "http://www.51hejia.com/youqituliao/"
      @redirect_key["瓷砖"] = "http://www.51hejia.com/cizhuan/"
      @redirect_key["布艺"] = "http://www.51hejia.com/buyi/"
      @redirect_key["家具"] = "http://www.51hejia.com/jiajuchanpin/"
      @redirect_key["家电"] = "http://www.51hejia.com/jiadian/"
      @redirect_key["灯具"] = "http://www.51hejia.com/zhaomingpindao/"
      @redirect_key["灯饰"] = "http://www.51hejia.com/zhaomingpindao/"
      @redirect_key["照明"] = "http://www.51hejia.com/zhaomingpindao/"
      @redirect_key["采暖"] = "http://www.51hejia.com/cainuan/"
      @redirect_key["厨房橱柜"] = "http://www.51hejia.com/chuguipindao/"
      @redirect_key["卫浴用品"] = "http://www.51hejia.com/weiyupindao/"
      @redirect_key["卫生间用品"] = "http://www.51hejia.com/weiyupindao/"
      @redirect_key["洗手间用品"] = "http://www.51hejia.com/weiyupindao/"
      @redirect_key["中央空调"] = "http://www.51hejia.com/kongtiao/"
      @redirect_key["水处理"] = "http://www.51hejia.com/shuichuli/"
      @redirect_key["装饰"] = "http://www.51hejia.com/jushang/"
      @redirect_key["时尚家居"] = "http://www.51hejia.com/jushang/"
      @redirect_key["厨房"] = "http://www.51hejia.com/chufang/"
      @redirect_key["卫浴"] = "http://www.51hejia.com/weiyu/"
      @redirect_key["卫生间"] = "http://www.51hejia.com/weiyu/"
      @redirect_key["洗手间"] = "http://www.51hejia.com/weiyu/"
      @redirect_key["客厅"] = "http://www.51hejia.com/keting/"
      @redirect_key["卧室"] = "http://www.51hejia.com/woshi/"
      @redirect_key["书房"] = "http://www.51hejia.com/shufang/"
      @redirect_key["花园"] = "http://www.51hejia.com/huayuanshenghuo/"
      @redirect_key["背景墙"] = "http://www.51hejia.com/beijingqiang/"
      @redirect_key["儿童房"] = "http://www.51hejia.com/ertongfang/"
      @redirect_key["小户型"] = "http://www.51hejia.com/xiaohuxing/"
      @redirect_key["二手房"] = "http://www.51hejia.com/ershoufang/"
      @redirect_key["主妇"] = "http://www.51hejia.com/chaojizhufu/"
      @redirect_key["别墅"] = "http://www.51hejia.com/bieshu/"
      @redirect_key["品牌"] = "http://b.51hejia.com/"
    end
    return @redirect_key[name]
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
  def get_webpm(keyword) #获取参数哈希表
    get_webpm_data if $webpm_data.nil?
    a = $webpm_data[keyword].split("\r")
    h = Hash.new
    0.step(a.size-2, 2) do |i|
      h[a[i+1].to_i] = a[i]
    end
    return h
  end
  def get_webpm_data #缓存参数数据
    webpms = Webpm.find :all, :select =>"id, keyword, value"
    h = Hash.new
    for webpm in webpms
      h[webpm.keyword] = "" if h[webpm.keyword].nil?
      h[webpm.keyword] += webpm.value + "\r" + webpm.id.to_s + "\r"
    end
    $webpm_data = h
  end

  #数据库相关
  def dosql(str)
    return ActiveRecord::Base.connection.execute(str)
  end
 
  #字符串相关
  def strip(str)
    return str.lstrip.rstrip if str
  end
  def trim(str)
    return str.to_s.lstrip.rstrip rescue ""
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
  def fp(v) #format_params 格式化参数
    if v.is_a?(Array)
      str = ""
      0.upto(v.size-1) do |i|
        str += iconv_gb2312(trim(v[i]))
        str += "," if i < v.size-1
      end
      return str
    else
      return iconv_gb2312(trim(v))
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
    return js("alert(\"#{str.gsub("\n"," ")}\")")
  end
  def alert_error(str, *p)
    return js("alert(\"#{str.gsub("\n"," ")}\")")
  end
  def js(str, *p)
    return "<script type=\"text/javascript\">#{str.to_s}</script>"
  end
  
  def top_reload
    return "if (top!=self){top.location.reload();}"
  end

  #其它功能
  def get_error(exception)
    if SHOW_ERROR
      return exception.to_s
    else
      return "程序出现了异常，您可以通过设置 SHOW_ERROR 参数为 true 来显示详细的异常信息。"
    end
  end
  def show_notice(str) #显示布告
    render :text => "<div style='line-height:30px; padding:30px'><b>#{str}</b><br /><br />\
<a href=\"#\" onclick=\"history.back();\">点这里返回前一页</a>"
  end
  def is_in_array(arr, v) #判断一个字符串值是否存在于一个数组中
    rv = false
    for a in arr
      rv = true if trim(a.to_s)==trim(v.to_s)
    end
    return rv
  end
  def getnow()
    return Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  def datediff(time1, time2)
    return ((time2 - time1)/(60*60*24)).to_i
  end
  def dateadd(time1, days)
    return time1 + days * (60*60*24)
  end
  def md5(v)
    return Digest::MD5.hexdigest(v)
  end
  
  def top_load(url)
    if url == "self"
      return "if (top!=self){ if (top.location.href.indexOf('#')==-1) top.location.href=top.location.href; else top.location.href=top.location.href.substring(0, top.location.href.indexOf('#'));}"
    elsif url == "reload"
      return "top.location.reload();"
    elsif !url.blank?
      url = '"' + url + '"'
      return "top.location.href = #{url};"
    end
  end

  def myrender(js_alert, forward)
    script = alert(js_alert) unless js_alert.blank?
    script << js(top_load(forward)) unless forward.blank?
    script = "" if script.nil?
    render :text => <<_HTML_, :content_type => Mime::HTML
<!doctype html>
<html lang="zh">
  <head>
    <meta charset="UTF-8">
    <title>和家网</title>
  </head>
  <body>
    #{script}
  </body>
</html>
_HTML_
  end

  def action_render(alert_text=@alert_text, forward_url=@forward_url, render_text=@render_text)
    str = ""
    str += render_text  unless render_text.blank?
    str += alert(alert_text)  unless alert_text.blank?
    str += js(top_load(forward_url)) unless forward_url.blank?
    render :text => str unless str.blank?
  end
  
  def get_and_save_city(city,ip)
    result = 0
    if city
      result = city.to_i
      cookies[:user_city] = {:value => city.to_s, :domain=>".51hejia.com",:expires => 1.years.from_now}
    elsif @user_city_code
      result = @user_city_code
    else
      result = get_ip_city(ip).to_i
      cookies[:user_city] = {:value => result.to_s, :domain=>".51hejia.com",:expires => 1.years.from_now}
    end
    return result
  end

  def get_ip_city(ip)
    user_ip = 0
    user_ipa = ip.to_s.split(".") 
    
    0.upto(3) do |i|
      user_ip += (user_ipa[i].to_i * (256 ** (3-i)))
    end

    ip_address = IpAddresse.find(:first,:conditions => "ipstart <= #{user_ip} and ipend >= #{user_ip}");
    
    return 11910 if CITIESIP[ip_address.is_shanghai].to_i == 0
         
    return CITIESIP[ip_address.is_shanghai]
  end

  def get_and_save_city2(city, ip)
    city_code =
      if city 
      city
    elsif @user_city_code # 这个是在DecoController里面的city_validate的before_filter里面赋值的
      @user_city_code
    elsif !cookies[:user_city].blank?
      cookies[:user_city]
    else
      get_ip_city2(ip)
    end.to_i
    if city_code == 0
      cookies.delete :user_city
    else
      cookies[:user_city] = {:value => city_code.to_s, :domain=>".51hejia.com", :expires => 1.years.from_now}
    end
    city_code
  end

  def get_ip_city2(ip)
    user_ip = 0
    user_ipa = ip.to_s.split(".") 
    
    0.upto(3) do |i|
      user_ip += (user_ipa[i].to_i * (256 ** (3-i)))
    end

    ip_address = IpAddresse.find(:first, :conditions => "ipstart <= #{user_ip} and ipend >= #{user_ip}")
    
    CITIESIP[ip_address.is_shanghai].to_i == 0 ? 0 : CITIESIP[ip_address.is_shanghai]
  end
  
  #保存用户打分时间
  def add_remark_mark(user_id)
    $redis.setex("remark:mark:user:#{user_id}",6.months,1)
  end
  #判断6个月前是否评论过
  def remark_mark_verify(user_id)
    $redis.get("remark:mark:user:#{user_id}").nil? ? true : false
  end
  #判断验证码是否正确
  def mobile_code_verify(user_id ,code)
    get_code = $redis.get("mobile_code:#{user_id}")
    if get_code.nil?
      false
    else
      get_code.to_s == code.to_s ? true : false
    end
  end
  
  #留言星星
  def remark_star num
    case num.to_i
    when 2 || 3
      hanzi = "很不满意"
    when 4 || 5
      hanzi = "不满意"
    when 6 || 7
      hanzi = "一般"
    when 8 || 9
      hanzi = "满意"
    when 10
      hanzi = "非常满意"
    end
    width = num.to_i / 2 * 18 
    %(<div class="f_l">&nbsp;&nbsp;评价：</div><span style="width: #{width}px; margin-top: 2px;" class="gsr_integral02 f_l"></span><span style="color:red;margin-left:10px;" class="f_l">#{hanzi}</span>)
  end
  
  
end
