class RestController < ApplicationController
  def list
    #    建材
    #    家居
    #    装潢
    visitor_id = get_user_id_by_cookie_name()
    if params[:type].to_i == 1
      tag_id = get_tag_id_by_tag_name("建材")
      self_and_children_ids = get_self_and_children_ids_by_tag_id(tag_id)
      @topics = AskZhidaoTopic.find(:all, :select => "id, subject, best_post_id, tag_id", 
        :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id in (#{self_and_children_ids})", 1, 0], 
        :order => 'id DESC', 
        :limit => 7)
      #访问记录--
      AskStatistic.save("rest", "list", request.request_uri, visitor_id, request.remote_ip)
      #--访问记录
    end
    if params[:type].to_i == 2
      tag_id = get_tag_id_by_tag_name("家居")
      self_and_children_ids = get_self_and_children_ids_by_tag_id(tag_id)
      @topics = AskZhidaoTopic.find(:all, :select => "id, subject, best_post_id, tag_id", 
        :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id in (#{self_and_children_ids})", 1, 0], 
        :order => 'id DESC', 
        :limit => 13)
      #访问记录--
      AskStatistic.save("rest", "list", request.request_uri, visitor_id, request.remote_ip)
      #--访问记录
    end
    if params[:type].to_i == 3
      tag_id = get_tag_id_by_tag_name("装潢")
      self_and_children_ids = get_self_and_children_ids_by_tag_id(tag_id)
      @topics = AskZhidaoTopic.find(:all, :select => "id, subject, best_post_id, tag_id", 
        :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id in (#{self_and_children_ids})", 1, 0], 
        :order => 'id DESC', 
        :limit => 9)
      #访问记录--
      AskStatistic.save("rest", "list", request.request_uri, visitor_id, request.remote_ip)
      #--访问记录
    end
  end
  
  def list2  #首页排行榜
    tmax = Time.now.strftime("%Y-%m-%d 23:59:59")
    tmin2 = 7.days.ago(Time.now).strftime("%Y-%m-%d 00:00:00")
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject, description, view_counter, post_counter, view_counter+post_counter as counter, user_id, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and created_at >= ? and created_at <= ?",
        1, 0, tmin2, tmax], 
      :order => 'counter DESC',
      :limit => '10')
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list2", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end
  
  def list3  #首页已解决、待解决问题
    #已解决
    @topics1 = AskZhidaoTopic.find(:all, :select => "id, subject, best_post_id, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id > 0 and best_post_id > 0", 1, 0], 
      :order => 'id DESC', 
      :limit => 10)
    #待解决
    @topics0 = AskZhidaoTopic.find(:all, :select => "id, subject, best_post_id, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id > 0 and best_post_id is null", 1, 0], 
      :order => 'id DESC', 
      :limit => 10)
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list3", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end
  
  def list_xiaoqu
    @zid = params[:zid].to_i
    @topics = AskTaolunTopic.find(:all, :select => "id, subject, created_at", 
      :conditions => ["area_id = ?  and tag_id = ? and is_delete = ? ",
        1, @zid,0], 
      :order => 'created_at DESC',
      :limit => '10')
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list_xiaoqu", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end
  
  #公司
  def list_company  
    session[:aid] = strip(params[:aid].to_s)
    session[:cid] = strip(params[:cid].to_s)
    
    @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, tag_id, user_id, view_counter, description",
      :conditions => ["area_id =? and user_id >=0 and is_delete = ? and tag_id > 0 and company_id= ?", 1, 0, session[:cid]],
      :order => 'id DESC',
      :per_page => 1)
    
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list_company", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'rest_list_company'
  end
  
  def save_company
    user_id = get_user_id_by_cookie_name()
    #tags表中数据,写死
    tag_id = 258
    subject = strip(params[:co_subject].to_s)
    description = strip(params[:co_desc].to_s)
    guest_email = strip(params[:co_guest_email].to_s)
    area_id = session[:aid]
    company_id = session[:cid]
    method = 4
    
    AskZhidaoTopic.save_company(user_id, tag_id, subject, description, '',
      guest_email, request.remote_ip, company_id, area_id, method)
    #AskZhidaoTopic.save(user_id, tag_id, subject, description, user_tags, guest_email, ip, company_id, area_id, method, topic_type_id)
    redirect_to "/visitor/list?tp=2"
  end
  
  def list_cizhuan  #瓷砖问吧
    keyword = "瓷砖" 
    #已解决
    @topics1 = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id > 0 and subject like ?",
        1, 0, '%'+keyword+'%'], 
      :order => 'id DESC',
      :limit => 3)
    #未解决
    @topics0 = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id is null and subject like ?",
        1, 0, '%'+keyword+'%'], 
      :order => 'id DESC',
      :limit => 3)
    
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list_cizhuan", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'rest_list_cizhuan'
  end
  
  def list_tuliao  #涂料问吧
    keyword = "涂料" 
    #已解决
    @topics1 = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id > 0 and subject like ?",
        1, 0, '%'+keyword+'%'], 
      :order => 'id DESC',
      :limit => 7)
    #未解决
    @topics0 = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id is null and subject like ?",
        1, 0, '%'+keyword+'%'], 
      :order => 'id DESC',
      :limit => 7)
    
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list_tuliao", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'rest_list_tuliao'
  end
  
  def list_jiadian  #家电问吧
    tag_id = get_tag_id_by_tag_name("生活家电")
    self_and_children_ids = get_self_and_children_ids_by_tag_id(tag_id) 
    #已解决
    @topics0 = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id in (#{self_and_children_ids}) and is_delete = ? and best_post_id > 0",
        1, 0], 
      :order => 'id DESC',
      :limit => 7)
    #未解决
    @topics1 = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id in (#{self_and_children_ids}) and is_delete = ? and best_post_id is null",
        1, 0], 
      :order => 'id DESC',
      :limit => 7)
    
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list_jiadian", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'rest_list_jiadian'
  end
  
  def list_jiangtang  #讲堂
    tag_id = params[:tid].to_i
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id = ? and is_delete = ? and best_post_id is null",
        1, tag_id, 0], 
      :order => 'id DESC',
      :limit => 6)
    
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list_jiangtang", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'rest_list_jiangtang'
  end
  
  def list_tiezi  #某个用户回复过的帖子主题
    user_id = params[:uid].to_i
    aztp = AskZhidaoTopicPost.find(:all, :select => "DISTINCT zhidao_topic_id",
      :conditions => ["user_id = ? and is_delete = 0", user_id],
      :order => "id DESC",
      :limit => 10)
    zhidao_topic_ids = aztp.collect{|c| c.zhidao_topic_id}.join(',')

    @topics = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id", 
      :conditions => ["area_id = ? and is_delete = ? and id in (#{zhidao_topic_ids}) and tag_id > 0 and user_id >= 0", 1, 0], 
      :order => 'id DESC', 
      :limit => 6)
    
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list_tiezi", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'rest_list_tiezi'
  end
  
  def reply  #回复
    @area_id = strip(params[:aid]).to_i
    @type_id = strip(params[:tid]).to_i
    @entity_id = strip(params[:eid]).to_i
    if you = current_user
      @user_id = you.USERBBSID.to_i
      @username = you.USERNAME
      @email = you.USERBBSEMAIL
    else
      @user_id = 0
    end

    if params[:tp].to_s == "all"
      @replies = Reply.replies(@area_id, @type_id, @entity_id, nil)
    else
      @ids = [680062,680063,680093,671877,680072,680074,679806,677949,633977,679902,680084,680010,675501,679978,680076,678223,679689,679939,679856,679994,679988,679872,679695,679947,679804,680071,680075,678514,679945,677006,680055,679534,680064,679900,679948,679987,679683,679922,679954,680057,679938,616356,680025,676164,679907,680058,679592,680066,679887,679619,679985,679893,679966,621872,673049,679851]
      if @ids.include?(@entity_id)
        @reply_lists = Reply::LIST.sort_by{rand}.slice(0...(3+rand(3)))
      else
        memkey = "replies_cache_#{@entity_id}"
        Reply
        @replies = CACHE.fetch(memkey, 3.days) do
          Reply.replies(@area_id, @type_id, @entity_id, 10)
        end
      end
    end
    
    # @reply_count = Reply.count(:conditions => ["area_id = ? and type_id = ? and entity_id = ? and is_delete = 0", area_id, type_id, entity_id])
 
    
    #访问记录--
    # visitor_id = get_user_id_by_cookie_name()
    # AskStatistic.save("rest", "reply", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'rest_reply'
  end
  
  def add_reply
    content = params[:content].to_s.strip
    area_id, type_id, entity_id = params[:area_id].to_i, params[:type_id].to_i, params[:entity_id].to_i
    unless content.blank?
      user_id, email = params[:user_id].to_i, params[:email].to_s.strip
      Reply.save(area_id, type_id, entity_id, user_id, email, request.remote_ip, content)
      memkey = "replies_cache_#{entity_id}"
      CACHE.delete(memkey)
    end
    redirect_to "/rest/reply?aid=#{area_id}&tid=#{type_id}&eid=#{entity_id}&tp=#{params[:tp]}"
  end

  def list_tuijian  #推荐问答——论坛
    keyword = strip(params[:keyword])
    keyword = iconv_gb2312(keyword)
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ? or description like ?", 1, 0, '%'+keyword+'%', '%'+keyword+'%'], 
      :order => "post_counter DESC, view_counter DESC, id DESC",
      :limit => 10)
    if @topics.size < 10
      keyword = "装修"
      @topics = AskZhidaoTopic.find(:all, :select => "id, subject",
        :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ? or description like ?", 1, 0, '%'+keyword+'%', '%'+keyword+'%'],
        :order => "post_counter DESC, view_counter DESC, id DESC",
        :limit => 10)
    end
    render :layout => 'rest_list_tuijian'
  end

  def list_paihangbang  #排行榜
    tmin = 7.days.ago(Time.now).strftime("%Y-%m-%d 00:00:00")
    tmax = Time.now.strftime("%Y-%m-%d 23:59:59")
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject, view_counter+post_counter as counter, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and created_at >= ? and created_at <= ?",
        1, 0, tmin, tmax], 
      :order => 'counter DESC',
      :limit => 6)
    render :layout => 'rest_list_paihangbang'
  end

  def list_xiaohuxing  #小户型
    keyword = "小户型"
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
      :order => 'id DESC',
      :limit => 9)
    render :layout => 'rest_list_xiaohuxing'
  end
  
  def list_kitchen  #厨房
    keyword = "厨房"
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
      :order => 'id DESC',
      :limit => 15)
    render :layout => 'rest_list_kitchen'
  end
  
  def list_furniture  #家具
    keyword = "家具"
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
      :order => 'id DESC',
      :limit => 9)
    render :layout => 'rest_list_furniture'
  end
  
  def list_bathroom  #卫浴
    keyword = "卫浴"
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
      :order => 'id DESC',
      :limit => 15)
    render :layout => 'rest_list_bathroom'
  end
  
  def list_floor #地板
    keyword = "地板"
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
      :order => 'id DESC',
      :limit => 4)
    render :layout => 'rest_list_floor'
  end
  
  def list_dope #涂料
    keyword = "涂料"
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
      :order => 'id DESC',
      :limit => 4)
    render :layout => 'rest_list_dope'
  end
  
  def list_tile
    keyword = "瓷砖"
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
      :order => 'id DESC',
      :limit => 4)
    render :layout => 'rest_list_tile'
  end

  def list_decoration
    keyword = "装饰"
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
      :order => 'id DESC',
      :limit => 12)
    render :layout => 'rest_list_decoration'
  end
  
  def list_dope_ask
    keyword = "涂料"
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
      :order => 'id DESC',
      :limit => 14)
    render :layout => 'rest_list_dope_ask'
  end
  
  def list_zhuangxiu
    tag_id = get_tag_id_by_tag_name("装潢")
    self_and_children_ids = get_self_and_children_ids_by_tag_id(tag_id)
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject, best_post_id, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id in (#{self_and_children_ids})", 1, 0], 
      :order => 'id DESC', 
      :limit => 5)
   
    tag_id1 = get_tag_id_by_tag_name_for_forum("装修设计")
    self_and_children_id1s = get_self_and_children_ids_by_tag_id(tag_id1)
    @bbss = AskForumTopic.find(:all, :select => "id, subject, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id in (#{self_and_children_id1s}) and is_good = 1", 1, 0], 
      :order => 'id DESC', 
      :limit => 5)
    render :layout => 'rest_list_zhuangxiu'
  end
  
  def central_air  #中央空调
    keyword = "中央空调"
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
      :order => 'id DESC',
      :limit => 10)
    render :layout => 'rest_central_air'
  end

  def bj_wen  #按点击率
    @topics = AskZhidaoTopic.find(:all,
      :conditions => ["area_id = 1 and user_id >= 0 and tag_id >0 and is_delete = 0"],
      :order =>'view_counter DESC',
      :limit => 6)
    render :layout => 'rest_bj_wen'
  end
  
  def sh_wen  #按点击率
    @topics = AskZhidaoTopic.find(:all,
      :conditions => ["area_id = 1 and user_id >= 0 and tag_id >0 and is_delete = 0"],
      :order =>'view_counter DESC',
      :limit => 6)
    render :layout => 'rest_sh_wen'
  end

  def list2_1  #首页排行榜
    tmax = Time.now.strftime("%Y-%m-%d 23:59:59")
    tmin2 = 7.days.ago(Time.now).strftime("%Y-%m-%d 00:00:00")
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject, description, view_counter, post_counter, view_counter+post_counter as counter, user_id, tag_id",
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and created_at >= ? and created_at <= ?",
        1, 0, tmin2, tmax],
      :order => 'counter DESC',
      :limit => '10')
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list2_1", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end

  def list3_1  #首页已解决、待解决问题
    #已解决
    @topics1 = AskZhidaoTopic.find(:all, :select => "id, subject, best_post_id, tag_id",
      :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id > 0 and best_post_id > 0", 1, 0],
      :order => 'id DESC',
      :limit => 10)
    #待解决
    @topics0 = AskZhidaoTopic.find(:all, :select => "id, subject, best_post_id, tag_id",
      :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id > 0 and best_post_id is null", 1, 0],
      :order => 'id DESC',
      :limit => 10)
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list3_1", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end

  def list4  #俱乐部
    #已解决
    @topics = AskZhidaoTopic.find(:all, :select => "id, subject, best_post_id, tag_id",
      :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id > 0 and best_post_id > 0", 1, 0],
      :order => 'id DESC',
      :limit => 3)
    #排行榜
    tmin = 7.days.ago(Time.now).strftime("%Y-%m-%d 00:00:00")
    tmax = Time.now.strftime("%Y-%m-%d 23:59:59")
    @topics2 = AskZhidaoTopic.find(:all, :select => "id, subject, view_counter+post_counter as counter, tag_id",
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and created_at >= ? and created_at <= ?", 1, 0, tmin, tmax],
      :order => 'counter DESC',
      :limit => 3)
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("rest", "list4", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'rest_list4'
  end
  
  private
  def get_self_and_children_ids_by_tag_id(tag_id)
    children_ids = Tag.find(:all, :select => "id",
      :conditions => ["parent_id = ?", tag_id])
    if children_ids.size > 0  #有子节点的情况
      #二级目录
      children_ids0 = children_ids.collect{|c| c.id}.join(',')
      for child_id in children_ids
        children_children_ids = Tag.find(:all, :select => "id",
          :conditions => ["parent_id = ?", child_id.id])
        if children_children_ids.size > 0  #三级目录
          children_ids0 = children_ids0 + "," + children_children_ids.collect{|c| c.id}.join(',')
        end
      end
      self_and_children_ids = tag_id.to_s + "," + children_ids0
    else  #无子节点的情况
      self_and_children_ids = tag_id
    end
    return self_and_children_ids
  end
  
  def get_tag_id_by_tag_name(tag_name)
    tag_id = Tag.find(:first, :select => "id",
      :conditions => ["name =?", tag_name]).id
    return tag_id
  end
  
  def get_tag_id_by_tag_name_for_forum(tag_name)
    tag_id = AskForumTag.find(:first, :select => "id",
      :conditions => ["name =?", tag_name]).id
    return tag_id
  end
  
end