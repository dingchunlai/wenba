class ApplicationController < ActionController::Base
  #before_filter :check_block
  
  helper :decoration_diary

  #根据cookies判断ADTV视频广告该用户8小时内是否显示过
  def get_adtv_is_view
    adtv_is_view  = cookies[:adtv_is_view_20100629].to_s
    if adtv_is_view.blank?
      cookies[:adtv_is_view_20100629] = {:value => "show", :expires => 8.hours.from_now}
    end
    return adtv_is_view
  end

  def current_page
    params[:page].to_i > 0 ? params[:page].to_i : 1
  end
  helper_method :current_page

  def expire_topic_info(topic_id) #清除某个问题详细信息的memcache缓存
    topic_id = topic_id.to_i
    if topic_id != 0
      kw = get_mc_kw(KW_TOPIC_INFO, "topic_id", topic_id)
      mc(kw, nil)
    end
  end
  helper_method :expire_topic_info

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
  helper_method :get_parent_tag_id

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
  helper_method :get_tag_name_by_tag_id

  def expire_sortlist(tag_id) #清除某个栏目列表页的memcache缓存
    tag_id = tag_id.to_i
    if tag_id != 0
      0.upto(4) do |i|
        kw_topics = get_mc_kw(KW_TOPICS_LIST, "tag_id", tag_id, "tp", i)
        CACHE.delete(kw_topics)
      end
      parent_tag_id = get_parent_tag_id(tag_id).to_i
      expire_sortlist(parent_tag_id) if parent_tag_id > 0
    end
  end

  def expire_posts(topic_id) #清除某个问题的回复信息的memcache缓存
    memkey = AskZhidaoTopicPost.memkey_wenba_post(topic_id, 1)
    CACHE.delete(memkey)
  end

  def is_askadmin
    user_id = get_user_id_by_cookie_name()
    askadmins = CACHE.get("askadmins")
    if askadmins.nil?
      askadmins = Array.new
      azs = AskZhidaoAdmin.find(:all, :select => "id, admin_id", :conditions => "is_delete = 0")
      for az in azs
        askadmins << az.admin_id.to_i
      end
      CACHE.set("askadmins", askadmins)
    end
    if askadmins.include?(user_id.to_i)
      return true
    else
      return false
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

  def get_rand(min, max)  #取得两个整数之间的随机数
    return rand(max.to_i - min.to_i + 1) + min.to_i
  end

  def strip(str)
    if str
      return str.lstrip.rstrip
    end
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

  def escape_invalid_characters(initial_str)
    final_str = initial_str.gsub(".js", "").gsub(".JS", "").gsub(".Js", "").gsub(".jS", "")
    final_str = final_str.gsub("<script", "").gsub("</script>", "")
    return final_str
  end
  
  private
  def is_user
    user_id = get_user_id_by_cookie_name()
    if user_id > 0
      #
    else
      redirect_to "/"
    end
  end
  
  def is_editor
    user_id = get_user_id_by_cookie_name()
    if user_id > 0
      ohurs = HejiaUserRole.find(:all, :select => "role_id",
        :conditions => ["user_id = ?", user_id])
      if ohurs.size > 0
        is_editor = 0
        for ohur in ohurs
          role_id = ohur.role_id
          role_name = HejiaRole.find(:first, :select => "name",
            :conditions => ["id = ?", role_id]).name
          if iconv_gb2312(role_name) == "编辑"
            #            if role_id.to_i == 3
            is_editor = 1
            break
          end
        end
        if is_editor == 1
          #
        else  #非编辑登录
          redirect_to "/"
        end
      else  #非编辑登录
        redirect_to "/"
      end
    else  #未登录
      redirect_to "/"
    end
  end
  
  def is_blog_user  
    if !params[:uid].nil?
      user_id = params[:uid]||= get_user_id_by_cookie_name()
    else
      user_id = get_user_id_by_cookie_name()
    end
    
    if user_id.to_i == 0
      redirect_to BASEURL
    end
    
  end
  
  def is_admin
    user_id = get_user_id_by_cookie_name()
    if user_id > 0
      ohurs = HejiaUserRole.find(:all, :select => "role_id",
        :conditions => ["user_id = ?", user_id])
      if ohurs.size > 0
        is_admin = 0
        for ohur in ohurs
          role_id = ohur.role_id
          role_name = HejiaRole.find(:first, :select => "name",
            :conditions => ["id = ?", role_id]).name
          if iconv_gb2312(role_name) == "编辑"
            #            if role_id.to_i == 3
            is_admin = 1
            break
          end
        end
        if is_admin == 1
          #
        else  #非编辑登录
          redirect_to "/"
        end
      else  #非编辑登录
        redirect_to "/"
      end
    else  #未登录
      redirect_to "/"
    end
  end
  
  # Check if the client IP is blocked
  def check_block
    if AskBlockedIp.blocked?(request.remote_ip)
      render :text => "blocked", :status => 403
      return false
    end
    if strip(request.remote_ip)[0, 5] == "59.50"
      render :text => "blocked", :status => 403
      return false
    end
    if strip(request.remote_ip)[0, 5] == "59.49"
      render :text => "blocked", :status => 403
      return false
    end
  end

  #根据原文件名，结合单前系统时间生成新的文件名
  def generate_filename(old_name)
    old_name = old_name.split(".")
    suffix = old_name[old_name.length-1]  #取得原文件名后缀
    new_name = Time.now.strftime("%Y%m%d_%H%M_#{('a'..'z').to_a[rand(26)]}%S")
    return new_name + "." + suffix
  end

  #取得上传的文件并保存，返回已保存的文件名。
  def get_file(file, save_path, maxsize) 
    return nil if file.type==String || file.type==Array || file==nil
    if file.original_filename.empty?
      return nil
    else
      if file.size/1024 > maxsize.to_i && maxsize != 0
        return maxsize.to_i
      else
        filename = generate_filename(file.original_filename)
        filepath = "#{RAILS_ROOT}/public#{save_path}#{filename}"
        File.open(filepath, "wb") do |f|
          f.write(file.read)
        end
        return save_path + filename
      end
    end
  end

  def paging_record(h) #生成分页记录集函数，反馈参数 params[:page] 和 params[:recordcount]
    if h["primary_key"].nil?
      primary_key = "id"
    else
      primary_key = h["primary_key"]
    end
    if h["conditions"].nil? || h["conditions"] == ""
      conditions = nil
    else
      conditions = h["conditions"]
    end
    if h["pagesize"].nil?
      @pagesize = 10
    else
      @pagesize = h["pagesize"].to_i
    end
    if h["listsize"].nil?
      @listsize = 10
    else
      @listsize = h["listsize"].to_i
    end
    if params[:page].nil?
      @curpage = 1
    else
      @curpage = params[:page].to_i
    end
    if @recordcount.nil?
      if params[:recordcount].nil?
        @recordcount = h["model"].count(primary_key, :conditions => conditions)
      else
        @recordcount = params[:recordcount].to_i
      end
    end
    @pagecount = (1.0 * @recordcount / @pagesize).ceil
    return h["model"].find :all,
      :select => h["select"],
      :conditions => conditions,
      :order => h["order"],
      :group => h["group"],
      :offset => @pagesize * (@curpage - 1),
      :limit => @pagesize
  end
  
end