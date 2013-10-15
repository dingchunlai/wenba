require 'seo_template'
require 'jcode'
include PublicModule

module ApplicationHelper

  def user_link(user_id)
    "<a href='http://wb.51hejia.com/expert_index/#{user_id}.html' 
      target='_blank' title='点击查看会员详细信息'>
      #{HejiaUserBbs.username(user_id)}</a>"
  end

  def render_ad(id, remark="", type="afp")
    remark = "#{type}广告代码　" + remark + "　"
    if type=="afp"
      <<START

      <!-- #{remark + "START　" + "="*30} -->
      <script type="text/javascript">//<![CDATA[
      ac_as_id = #{id};
      ac_format = 0;
      ac_mode = 1;
      ac_group_id = 1;
      ac_server_base_url = "afp.csbew.com/";
      //]]></script>
      <script type="text/javascript" src="http://static.csbew.com/k.js"></script>
      <!-- #{remark + "END　" + "="*32} -->
START
    elsif type=="openx"
      <<START

      <!-- #{remark + "START　" + "="*30} -->
      <script type='text/javascript'><!--//<![CDATA[
      var m3_u = (location.protocol=='https:'?'https://a.51hejia.com/www/delivery/ajs.php':'http://a.51hejia.com/www/delivery/ajs.php');
      var m3_r = Math.floor(Math.random()*99999999999);
      if (!document.MAX_used) document.MAX_used = ',';
      document.write ("<scr"+"ipt type='text/javascript' src='"+m3_u);
      document.write ("?zoneid=#{id}");
      document.write ('&amp;cb=' + m3_r);
      if (document.MAX_used != ',') document.write ("&amp;exclude=" + document.MAX_used);
      document.write (document.charset ? '&amp;charset='+document.charset : (document.characterSet ? '&amp;charset='+document.characterSet : ''));
      document.write ("&amp;loc=" + escape(window.location));
      if (document.referrer) document.write ("&amp;referer=" + escape(document.referrer));
      if (document.context) document.write ("&context=" + escape(document.context));
      if (document.mmm_fo) document.write ("&amp;mmm_fo=1");
      document.write ("'><\/scr"+"ipt>");
      //]]>--></script>
      <!-- #{remark + "END　" + "="*32} -->
START
    end
  end

  def get_all_topics_num
    kw = "all_topics_num_2"
    return CACHE.fetch(kw, 2.hours) do
      AskZhidaoTopic.count("id", :conditions=>"is_delete = 0").to_i rescue 0
    end
  end

  def get_resolved_topics_num
    kw = "resolved_topics_num_2"
    return CACHE.fetch(kw, 2.hours) do
      AskZhidaoTopic.count("id", :conditions=>"is_delete = 0 and post_counter > 0").to_i rescue 0
    end
  end

  def get_online_num  #返回在线人数
    online_num = CACHE.get("online_num")
    if online_num.nil? || online_num < 800 || online_num > 2800
      online_num = rand(800)+1000
    else
      if rand(2)==0
        online_num += 3
      else
        online_num -= 3
      end
    end
    CACHE.set("online_num", online_num)
    return online_num
  end

  def get_hot_tops(limit)
    kw_hot_tops = "hot_tops_01"
    hot_tops = mc(kw_hot_tops)
    if hot_tops.nil?
      hot_tops = AskZhidaoTopic.find(:all,:select=>"id,subject,post_counter,view_counter",:conditions=>"is_delete=0 and method <> 1 and tag_id not in (8,265,266) and post_counter > 3 and created_at > adddate(now(),-100)",:order=>"rand()",:limit=>limit)
      mc(kw_hot_tops, hot_tops)
    end
    return hot_tops
  end

  def get_hot_tops_2(limit)
    kw_hot_tops = "hot_tops_02"
    hot_tops = mc(kw_hot_tops)
    #hot_tops = nil #开发环境
    if hot_tops.nil?
      hot_tops = AskZhidaoTopic.find(:all,:select=>"id,subject,post_counter,view_counter",:conditions=>"is_delete=0 and method <> 1 and tag_id not in (8,265,266) and post_counter > 3 and created_at > adddate(now(),-100)",:order=>"rand()",:limit=>limit)
      mc(kw_hot_tops, hot_tops)
    end
    return hot_tops
  end

  def get_new_topics(limit)
    CACHE.fetch(AskZhidaoTopic.memkey_new_topics, 3.hours) do
      AskZhidaoTopic.find(:all,:select=>"id,subject,post_counter,view_counter",:conditions=>"is_delete=0 and is_distribute>0 and tag_id not in (8,265,266)",:order=>"created_at desc",:limit=>limit)
    end
  end

  def text_to_html(str)
    str = str.to_s
    unless str.blank?
      str = strip_tags(str)
      str = str.gsub(" ", "&nbsp;")
      str = str.gsub("\n", "<br />")
      str = str.gsub("[img]", "<img src='")
      str = str.gsub("[/img]", "' onload='if (this.width>690) this.width=690;' />")
    end
    return str
  end

  def parse_xml(xml, parameters, end_num = nil) #解析api对应栏目的xml输出
    require 'open-uri'
    require 'rexml/document'
    column_id = xml.to_s.gsub("http://api.51hejia.com/rest/build/xml/", "").gsub(".xml", "")
    key = "wenba_helper_key_publish_article_right_column_#{column_id}"
    if PUBLISH_CACHE.get(key).nil? || params[:no_cache]
      doc = REXML::Document.new(open(xml).read)
      start_num = 0
      results = Array.new
      doc.root.each_element do |elem|
        one = Hash.new
        elem.each_element do |node|
          for parameter in parameters
            if node.name == parameter
              if parameter == "image-url"
                unless node.text.blank?
                  if node.text.include?("http")
                    one[parameter] = node.text
                  else
                    one[parameter] = "http://js.51hejia.com/api"+node.text
                  end
                end
              else
                one[parameter] = node.text
              end
            end
          end
        end
        start_num += 1
        results << one
        break if start_num == end_num
      end
      PUBLISH_CACHE.set(key, results, 2.hours)
      return results
    else
      results = PUBLISH_CACHE.get(key)
      return results
    end
  end
  
  def utf8_left(str,length,replacer)
    a_str = str.split(//u)
    a_size = a_str.length
    if a_size > length
      str = a_str[0..(length-1)].join("") + replacer
    else
      return str
    end
  end
  
  def get_notices(limit) #取得公告信息
    kw = "wenba_noticles"
    Url
    rs = CACHE.fetch(kw, 3.hours) do
      Url.find(:all,:select=>"id,title,url",:conditions=>"sort_id=2",:order=>"updated_at desc",:limit=>15)
    end
    return rs[0..limit-1]
  end

  def get_point_top(limit, is_expert, order)
    kw = "wenba_helper_point_top_#{limit}_#{is_expert}_#{order}"
    CommunityUser
    rs = CACHE.fetch(kw, 2.hours) do
      if order == "answer"
        order = "wenba_answer_num"
      else
        order = "point"
      end
      conditions = []
      if is_expert
        conditions << "ask_expert > 0"
      else
        conditions << "ask_expert = 0"
      end
      CommunityUser.find(:all,
        :select=>"id,user_id,username,wenba_question_num,wenba_answer_num,wenba_best_answer_num,point",
        :conditions=>conditions.join(" and "),
        :limit=>10,
        :order=>"#{order} desc")
    end
    return rs[0..limit-1]
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
  
  def get_user_name_by_user_id(user_id)
    user_id = user_id.to_i
    if user_id > 0
      begin
        ohub = HejiaUserBbs.find(:first, :select => "username",
          :conditions => ["userbbsid = ?", user_id])
        if ohub.nil?
          user_name = "和家网友"
        else
          #        user_name = iconv_gb18030(ohub.username)
          user_name = iconv_gb2312(ohub.username)
        end
      rescue
        user_name = "和家网友"
      end
    else
      user_name ="和家网友"
    end
    return user_name
  end
  
  def get_user_icon_link_by_user_id(user_id)
    user_id = user_id.to_i
    if user_id > 0
      begin
        ohub = HejiaUserBbs.find(:first, :select => "headimg",
          :conditions => ["userbbsid = ?", user_id])
        if ohub.nil?
          user_icon_link = "http://www.51hejia.com/images/wenba/pic.gif"
        else
          imgname = ohub.headimg
          if imgname.nil?
            user_icon_link = "http://www.51hejia.com/images/wenba/pic.gif"
          else
            user_icon_link = "http://www.51hejia.com/files/hekea/user_img/" + imgname[3, 8] + "/" + imgname
          end
        end
      rescue
        user_icon_link = "http://www.51hejia.com/images/wenba/pic.gif"
      end
    else
      user_icon_link = "http://www.51hejia.com/images/wenba/pic.gif"
    end
    return user_icon_link
  end
  
  def get_user_email_by_user_id(user_id)
    user_id = user_id.to_i
    if user_id > 0
      begin
        ohub = HejiaUserBbs.find(:first, :select => "userbbsemail",
          :conditions => ["userbbsid = ?", user_id])
        if ohub.nil?
          user_email = "ask_user@51hejia.com"
        else
          user_email = ohub.userbbsemail
        end
      rescue
        user_email = "ask_user@51hejia.com"
      end
    else
      user_email = "ask_user@51hejia.com"
    end
    return user_email
  end
  
  def get_user_id_by_cookie_name(cookie_name="ind_id")
    cookie = cookies["#{cookie_name}"]
    if cookie.nil?
      user_id = 0
    else
      user_id = cookie.to_s
      user_id = user_id.gsub("#{cookie_name}=", "").gsub("; path=", "").to_i
    end
    return user_id    
  end
  
  #  def get_user_name_by_cookie_name(cookie_name="hejiausernamelogined")
  #    cookie = cookies["#{cookie_name}"]
  #    user_name = cookie.to_s
  #    user_name = user_name.gsub("#{cookie_name}=", "").gsub("; path=", "").to_s
  #    return user_name
  #  end
  
  def get_short_str(old_str, length)
    #        short_str = old_str.to_s.chars[0, length]
    short_str = old_str.each_char[0, length]
    return short_str
  end
  
  #SEO信息
  def get_seo_info(seo_element_name)
    #    首页
    if session[:seo_page] == "index"
      if seo_element_name == "title"
        seo_element_template = INDEX_SEO_META_TITLE
      end
      if seo_element_name == "keywords"
        seo_element_template = INDEX_SEO_META_KEYWORDS
      end
      if seo_element_name == "description"
        seo_element_template = INDEX_SEO_META_DESCRIPTION
      end
    end
    
    #    问题终端页面
    if session[:seo_page] == "question"
      title = @topic.subject
      tag_id = @topic.tag_id
      tag_name = get_tag_name_by_tag_id(tag_id)
      if seo_element_name == "title"
        seo_element_template = QUESTION_SEO_META_TITLE
        seo_element_template = seo_element_template.gsub("@seo_meta_title", title+"_#{tag_name}")
        seo_element_template = seo_element_template.gsub("@seo_meta_tag", tag_name)
      end
      if seo_element_name == "keywords"
        seo_element_template = QUESTION_SEO_META_KEYWORDS
        seo_element_template = seo_element_template.gsub("@seo_meta_keywords", tag_name)
      end
      if seo_element_name == "description"
        seo_element_template = QUESTION_SEO_META_DESCRIPTION
        seo_element_template = seo_element_template.gsub("@seo_meta_description", title)
      end
    end
    
    #    公司终端页面
    if session[:seo_page] == "company"
      title = @company.cn_name
      tag_name = "公司"
      if seo_element_name == "title"
        seo_element_template = COMPANY_SEO_META_TITLE
        seo_element_template = seo_element_template.gsub("@seo_meta_title", title+"_#{tag_name}")
      end
      if seo_element_name == "keywords"
        seo_element_template = COMPANY_SEO_META_KEYWORDS
        seo_element_template = seo_element_template.gsub("@seo_meta_keywords", tag_name)
      end
      if seo_element_name == "description"
        seo_element_template = COMPANY_SEO_META_DESCRIPTION
        seo_element_template = seo_element_template.gsub("@seo_meta_description", title)
      end
    end 
    
    #    一级分类
    #    二级分类
    #    三级分类
    if session[:seo_page] == "level123"
      tag_name = get_tag_name_by_tag_id(@tag_id)
      tag_info = get_tag_info_by_tag_id(@tag_id)
      if seo_element_name == "title"
        seo_element_template = LEVEL123_SEO_META_TITLE
        seo_element_template = seo_element_template.gsub("@seo_meta_title", tag_info[:title])
      end
      if seo_element_name == "keywords"
        seo_element_template = LEVEL123_SEO_META_KEYWORDS
        seo_element_template = seo_element_template.gsub("@seo_meta_keywords", tag_info[:keywords])
      end
      if seo_element_name == "description"
        seo_element_template = LEVEL123_SEO_META_DESCRIPTION
        seo_element_template = seo_element_template.gsub("@seo_meta_description", tag_name)
      end
    end
    #分类已解决问题
    if session[:seo_page] == "level1234"
      tag_name = get_tag_name_by_tag_id(@tag_id)
      tag_info = get_tag_info_by_tag_id(@tag_id)
      if seo_element_name == "title"
        seo_element_template = LEVEL1234_SEO_META_TITLE
        seo_element_template = seo_element_template.gsub("@seo_meta_title", tag_info[:title])
      end
      if seo_element_name == "keywords"
        seo_element_template = LEVEL1234_SEO_META_KEYWORDS
        seo_element_template = seo_element_template.gsub("@seo_meta_keywords", tag_info[:keywords])
      end
      if seo_element_name == "description"
        seo_element_template = LEVEL1234_SEO_META_DESCRIPTION
        seo_element_template = seo_element_template.gsub("@seo_meta_description", tag_name)
      end
    end

    #分类待解决问题
    if session[:seo_page] == "level1235"
      tag_name = get_tag_name_by_tag_id(@tag_id)
      tag_info = get_tag_info_by_tag_id(@tag_id)
      if seo_element_name == "title"
        seo_element_template = LEVEL1235_SEO_META_TITLE
        seo_element_template = seo_element_template.gsub("@seo_meta_title", tag_info[:title])
      end
      if seo_element_name == "keywords"
        seo_element_template = LEVEL1235_SEO_META_KEYWORDS
        seo_element_template = seo_element_template.gsub("@seo_meta_keywords", tag_info[:keywords])
      end
      if seo_element_name == "description"
        seo_element_template = LEVEL1235_SEO_META_DESCRIPTION
        seo_element_template = seo_element_template.gsub("@seo_meta_description", tag_name)
      end
    end

    #搜索页面
    if session[:seo_page] == "search"
      keyword = session[:wd]
      if seo_element_name == "title"
        seo_element_template = SEARCH_SEO_META_TITLE
        seo_element_template = seo_element_template.gsub("@seo_meta_title", keyword)
      end
      if seo_element_name == "keywords"
        seo_element_template = SEARCH_SEO_META_KEYWORDS
        seo_element_template = seo_element_template.gsub("@seo_meta_keywords", keyword)
      end
      if seo_element_name == "description"
        seo_element_template = SEARCH_SEO_META_DESCRIPTION
        seo_element_template = seo_element_template.gsub("@seo_meta_description", keyword)
      end
    end
    
    #列表页面
    if session[:seo_page] == "list"
      if seo_element_name == "title"
        seo_element_template = LIST_SEO_META_TITLE
      end
      if seo_element_name == "keywords"
        seo_element_template = LIST_SEO_META_KEYWORDS
      end
      if seo_element_name == "description"
        seo_element_template = LIST_SEO_META_DESCRIPTION
      end
    end

    #待解决列表页面
    if session[:seo_page] == "list1"
      if seo_element_name == "title"
        seo_element_template = LIST1_SEO_META_TITLE
      end
      if seo_element_name == "keywords"
        seo_element_template = LIST1_SEO_META_KEYWORDS
      end
      if seo_element_name == "description"
        seo_element_template = LIST1_SEO_META_DESCRIPTION
      end
    end
    
    #用户标签
    if session[:seo_page] == "usertag"
      usertag = get_user_tag_name_by_user_tag_id(@user_tag_id)
      if seo_element_name == "title"
        seo_element_template = USERTAG_SEO_META_TITLE
        seo_element_template = seo_element_template.gsub("@seo_meta_title", usertag)
      end
      if seo_element_name == "keywords"
        seo_element_template = USERTAG_SEO_META_KEYWORDS
        seo_element_template = seo_element_template.gsub("@seo_meta_keywords", usertag)
      end
      if seo_element_name == "description"
        seo_element_template = USERTAG_SEO_META_DESCRIPTION
        seo_element_template = seo_element_template.gsub("@seo_meta_description", usertag)
      end
    end
    
    return seo_element_template
  end
  
  def is_blog_admin(item_id, is_top)
    old_user_id = get_user_id_by_cookie_name()
    if(old_user_id == @user_id.to_i)
      url = "<a href='/modify/blog/#{item_id}'>编辑</a> " +
        "<a href='/delete/blog/#{item_id}' 
      onclick=\"if (confirm('确定删除博客？')) { var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;f.submit(); };return false;\">删除</a> "
      if(is_top == 1)
        top_and_fix_url =  "<a href='/cancel/top/#{item_id}'>取消置顶</a> " + "<a href='/set/fix/#{item_id}'>固顶</a>"
      end
      if(is_top == 2)
        top_and_fix_url = "<a href='/cancel/fix/#{item_id}'>取消固顶</a> "
      end
      if(is_top == 0)
        top_and_fix_url =  "<a href='/set/top/#{item_id}'>置顶</a> " +  "<a href='/set/fix/#{item_id}'>固顶</a>"
      end
      return url + top_and_fix_url
    end
  end
  
  def get_top_fix_name(is_top)
    if(is_top == 2)
      top_fix_name = "[固顶] "
    end
    if(is_top == 1)
      top_fix_name = "[置顶] "
    end
    return top_fix_name
  end
  
  def is_blog_admin_reply_post(reply_id)
    old_user_id = get_user_id_by_cookie_name()
    if(old_user_id == @user_id.to_i)
      url = "<input type='submit' value='删除评论' name='submit'/>"
    end
  end
  
  def get_user_link(user_id)
    if user_id == 0
      url = "游客"
    else
      url = "<a href='http://blog.51hejia.com/u/#{user_id}/' target='_blank'>" + get_user_name_by_user_id(user_id) + "</a>"
    end
  end

  TAGURLS = {
    0 => "",
    0 => "quanguo",
    11910 => "shanghai",
    12117 => "suzhou",
    12122 => "nanjing",
    12301 => "ningbo",
    12306 => "hangzhou",
    12118 => "wuxi"
  }
  IMAGE_URL = "http://img.51hejia.com"
  IMAGE_PREFIX_ARRAY=" http://assets1.image.51hejia.com,  http://assets2.image.51hejia.com,  http://assets3.image.51hejia.com"
  IS_PRODUCT = 1
  def get_domain(city_id)
  if IS_PRODUCT.to_i == 1
    if city_id.to_i == 11910
      return 'http://z.shanghai.51hejia.com'
    elsif city_id.to_i == 12117
      return 'http://z.suzhou.51hejia.com'
    elsif city_id.to_i == 12122
      return 'http://z.nanjing.51hejia.com'
    elsif city_id.to_i == 12301
      return 'http://z.ningbo.51hejia.com'
    elsif city_id.to_i == 12306
      return 'http://z.hangzhou.51hejia.com'
    elsif city_id.to_i == 12118
      return 'http://z.wuxi.51hejia.com'
    else
      return 'http://z.51hejia.com'
    end
  else
    return ''
  end
end

  def get_diary_master_picture(diary)
    Picture
    CACHE.fetch("get_master_picture/decoration_diary/#{diary.id}", RAILS_ENV != 'production' ? 0 : 1.hour) do
      diary.master_picture
    end
  end

  #生成图片地址。(兼容旧的)
  def decoration_diary_image(image_urls , size)
    image_path = ""
    if !image_urls.nil? && image_urls.include?("/files/hekea/article_img/sourceImage/")
      image = image_urls.split(".")
      if image.size>0
        image_path.concat IMAGE_URL
        if !size.blank? && size.split(/x/)[0].to_i <= 150
          image_path.concat image[0].to_s
          image_path.concat "_thumb."
          image_path.concat image[1].to_s
        else
          image_path.concat image_urls
        end
      end
    elsif !image_urls.nil? && image_urls.include?("/images/binary/")
      image_path.concat IMAGE_URL
      image_path.concat image_urls
    else
      image_path = image_urls
    end
    image_path
  end

  #生成图片地址
  def image_full_path(picture, size ="" ,index = 1)
    if picture.image_url
      decoration_diary_image(picture.image_url,size)
    else
      domain_index = index % 3
      image_domain = IMAGE_PREFIX_ARRAY.split(",")[domain_index]
      if size.blank?
        image_domain + "/" + picture.image_id + "-" + picture.image_md5 + "." + picture.image_ext
      else
        image_domain + "/" + picture.image_id + "-" + picture.image_md5 + "_"+ size + "." + picture.image_ext
      end
    end
  end
  #案例详细地址
  def gen_firm_city_case_detail(firm_id,case_id)
    return gen_firm_city_path(firm_id)+"cases-#{case_id}"
  end
  #生成公司地址
  def gen_firm_city_path(firm_id)
    #    return "/firms-#{firm_id}"

    key = "zhaozhuangxiu_firm_path_#{firm_id}_5_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      firm = getfirm(firm_id)
      if firm.city.to_i == 11910
        result = get_domain(11910)
      else
        result = get_domain(firm.district)
      end
      result = result + "/gs-#{firm.id}/"
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end

    return result
  end
  def getfirm id
    DecoFirm.getfirm id
  end

  def truncate_u(text, length = 30, truncate_string = "")
    l = 0
    char_array = text.unpack("U*")
    char_array.each_with_index do |c,i|
      l = l + (c<127 ? 0.5 : 1)
      if l >= length
        return char_array[0..i].pack("U*") + (i < char_array.length - 1 ? truncate_string : "")
      end
    end
    return text
  end
  
  private
  def get_tag_info_by_tag_id(tag_id)
    tag_info = Hash.new
    parent_id = Tag.find(:first, :select => "parent_id",
      :conditions => ["id = ?", tag_id]).parent_id
    if parent_id  #二级或三次目录的情况
      parent_parent_id = Tag.find(:first, :select => "parent_id",
        :conditions => ["id = ?", parent_id]).parent_id
      if parent_parent_id  #三级目录的情况
        parent_parent_tag_name = get_tag_name_by_tag_id(parent_parent_id)
        parent_tag_name = get_tag_name_by_tag_id(parent_id)
        tag_name = get_tag_name_by_tag_id(tag_id)
        tag_info[:title] = parent_parent_tag_name + "_" + parent_tag_name + "_" + tag_name
        tag_info[:keywords] = tag_name + "，" + parent_tag_name + "，" + parent_parent_tag_name
      else  #二级目录的情况
        parent_tag_name = get_tag_name_by_tag_id(parent_id)
        tag_name = get_tag_name_by_tag_id(tag_id)
        tag_info[:title] = parent_tag_name + "_" + tag_name
        tag_info[:keywords] = tag_name + "，" + parent_tag_name
      end
    else  #一级目录的情况
      tag_name = get_tag_name_by_tag_id(tag_id)
      tag_info[:title] = tag_name
      tag_info[:keywords] = tag_name
    end
    return tag_info
  end
  
  def get_user_tag_name_by_user_tag_id(user_tag_id)
    user_tag_name = AskUserTag.find(:first, :select => "name", :conditions => ["id = ?", user_tag_id]).name
    return user_tag_name
  end
  
  def get_admin_info_by_user_id(user_id)
    user_name = HejiaUserBbs.find(:first, :select => "username,qq,msn", :conditions => ["userbbsid = ?", user_id])
    if user_name.nil?
      return nil
    else
      return user_name
    end
  end
  
  def get_admin_by_user_id(user_id)
    admin = AskAuthorizedUser.find(:first, :conditions => ["user_id = ? and is_valid = 1", user_id])
  end

  #截取中文 跟英文保持一致
  def truncate_for_zh(str,str_count = 0)
    s = ''
    str_sp = str.split(//u)
    str_sp.inject(0) do |sum,obj|
      break if sum >= str_count
      (obj.size == 3) ? sum += 2 : sum += 1
      s << obj
      sum
    end
    s.blank? ? str : s
  end
  
end
