class VisitorController < ApplicationController
  def index
    session[:seo_page] = "index"
      
    unsolved
    solved
    wiki_tag
    toptoday
    #    hottopics
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("visitor", "index", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'visitor_index'
  end
  
  def wiki_tag
    @wikis = AskWikiContent.find(:all)
    #@wikis = WikiContent.find_by_sql("select * from wiki_contents where id in (select max(id) from wiki_contents where wiki_del = 0 group by name)")
  end
  
  #  首页--待解决问题
  def unsolved
    tmin = 7.days.ago(Time.now).strftime("%Y-%m-%d 00:00:00")
    tmax = Time.now.strftime("%Y-%m-%d 23:59:59")
    @topics0 = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id, view_counter, post_counter", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id is null and created_at >= ? and created_at <= ?", 1, 0, tmin, tmax], 
      :order => 'created_at DESC', 
      :limit => 10)
  end
  
 #  首页--已解决问题
  def solved
    @topics1 = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id, view_counter, post_counter", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id > 0", 1, 0], 
      :order => 'created_at DESC', 
      :limit => 10)
  end
  
  #  首页--今日头条
  def toptoday    
    @topic2  = AskEditorChoice.find(:first, :select=>'id,url,title,topic_id', :conditions =>["is_valid = ? and type_id = ?",1, 0],
      :order => 'order_number DESC')
    topic = AskEditorChoice.find(:first, :select=>'id,url,title,topic_id', :conditions =>["is_valid = ? and type_id = ?",1, 0],
      :order => 'order_number DESC')
    if !topic.nil?
      hot_left_id = topic.id
    end
    @topic3 = AskEditorChoice.find(:all, :select=>'id,url,title,topic_id', :conditions=>["is_valid = ? and type_id = ? and id != ?",1,0,hot_left_id],
      :order => 'order_number DESC',
      :limit => 3)
    
    #    tmin = 3.days.ago(Time.now).strftime("%Y-%m-%d 00:00:00")
    #    tmax = Time.now.strftime("%Y-%m-%d 23:59:59")
    #    top_today_topic_id = 98662
    #
    #    @topic2 = AskZhidaoTopic.find(:first, :select => "id, subject, description, view_counter, post_counter",
    #      #      :conditions => ["area_id = ? and user_id > 0 and tag_id > 0 and is_delete = ? and created_at >= ? and created_at <= ?",
    #      #        1, 0, tmin, tmax],
    #      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and id = ?",
    #        1, 0, top_today_topic_id],
    #      :order => 'view_counter DESC')
    #    if @topic2.nil?
    #      @topic2 = AskZhidaoTopic.find(:first, :select => "id, subject, description, view_counter, post_counter",
    #        :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and created_at >= ? and created_at <= ?",
    #          1, 0, tmin, tmax],
    #        :order => 'view_counter DESC')

   
    #    toptoday_others    
    #    @topics2 = AskZhidaoTopic.find(:all, :select => "id, subject, description, view_counter, post_counter",
    #      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and created_at >= ? and created_at <= ? and id != ?",
    #        1, 0, tmin, tmax, top_today_topic_id],
    #      :order => 'view_counter DESC',
    #      :limit => '1, 3')
    #    if @topics2.size < 3
    #      @topics2 = AskZhidaoTopic.find(:all, :select => "id, subject, description, view_counter, post_counter",
    #        :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and created_at >= ? and created_at <= ? and id != ?",
    #          1, 0, tmin2, tmax, top_today_topic_id],
    #        :order => 'view_counter DESC',
    #        :limit => '1, 3')
    #    end
  end

  #  首页--排行榜
  def hottopics
    tmax = Time.now.strftime("%Y-%m-%d 23:59:59")
    tmin2 = 7.days.ago(Time.now).strftime("%Y-%m-%d 00:00:00")
    @topics3 = AskZhidaoTopic.find(:all, :select => "id, subject, description, view_counter, post_counter, view_counter+post_counter as counter, user_id, tag_id", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and created_at >= ? and created_at <= ?",
        1, 0, tmin2, tmax], 
      :order => 'counter DESC',
      :limit => '10')
  end
  
  #  首页--装修问答分类
  def tags
    @tags_level1 = Tag.find(:all, :select => "id, name",
      :conditions => "parent_id is null",
      :order => "id DESC")
  end
  
  def d_tags  #标签--讨论
    @tags = AskTaolunTag.find(:all, :select => "id, name", 
      :order => "id DESC")
  end
  
  def top #置顶--讨论
    @top_topics = AskTaolunTopic.find(:all, :select => "id,is_top,subject,created_at,view_counter,tag_id, post_counter",
      :conditions => ["is_top > 0 and area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ?", 1, 0],
      :order => "is_top DESC",
      :limit => 8)
  end
  
  def gonggao #置顶--讨论
    @bugaos = AskEditorChoice.find(:all, :select => "id,title,created_at,url,order_number",
      :conditions => ["area_id =1 and topic_type_id=3 and is_valid=1 "],
      :order => "order_number DESC",
      :limit => 8)
  end
  
  #  问题列表
  #  tp:
  #  全部问题--0
  #  已解决--1
  #  待解决--2
  #  零回答--3
  #  tid:
  def list  #知道
   
    redirect_to "/list/s/1.html"
    
#    if params[:tp].to_i == 1
#      session[:seo_page] = "list"
#    else
#      session[:seo_page] = "list1"
#    end
#
#    tags
#    if params[:tid]
#      #
#    else
#      if params[:tp].to_i == 1  #已解决
#        @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, tag_id, view_counter, post_counter",
#          :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id > 0", 1, 0],
#          :order => 'created_at DESC',
#          :per_page => 10)
#        @state = "已解决"
#      else  #待解决
#        @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, tag_id, view_counter, post_counter",
#          :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id is null", 1, 0],
#          :order => 'created_at DESC',
#          :per_page => 10)
#        @state = "待解决"
#      end
#    end
#    #访问记录--
#    visitor_id = get_user_id_by_cookie_name()
#    AskStatistic.save("visitor", "list", request.request_uri, visitor_id, request.remote_ip)
#    @is_askadmin = is_askadmin
#    #--访问记录
#    render :layout => 'visitor_list'
  end

  def del_topic
    ids = params[:ids]
    if pp(ids) && is_askadmin
      AskZhidaoTopic.update_all("is_delete=1", "id in (#{ids})")
      render :text => js(top_load("self"))
    else
      render :text => alert("操作失败：删除操作没有完成！")
    end
  end
  
  def companylist
    session[:seo_page] = "list"
    
    tags
    
    if params[:tid]
      #
    else
      
      @companies_pages, @companies = paginate(:ask_hejia_companies, :select => "id, cn_name, view_counter, post_counter",  
        :order => 'updated_at DESC', 
        :per_page => 10)
    end
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("visitor", "companylist", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'visitor_list'
  end
  
  def entrylist  #知识（分享）
    session[:seo_page] = "list"
    
    tags
    if params[:tid]
      #
    else
      if params[:tp].to_i == 0  #全部
        @topic_pages, @topics = paginate(:ask_zhishi_topics, :select => "id, subject, tag_id, view_counter, post_counter", 
          :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ?", 1, 0], 
          :order => 'updated_at DESC', 
          :per_page => 10)
        @state = "全部"
      end
    end
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("visitor", "entrylist", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'visitor_entrylist'
  end
  
  def question  #知道
    session[:seo_page] = "question"
    
    @user_id = get_user_id_by_cookie_name()
    #    帖子
    @topic_id = params[:id].to_i
    
    #    浏览计数
    AskZhidaoTopic.view(@topic_id)
    
    @topic = AskZhidaoTopic.find(:first, :select => "id, user_id, tag_id, subject, description, best_post_id, post_counter, view_counter, created_at, guest_name",
      :conditions => ["area_id = ? and is_delete = ? and id = ? and tag_id > 0", 1, 0, @topic_id])
    
    #    回复
    @posts = AskZhidaoTopicPost.find(:all, :select => "id, user_id, content, created_at, guest_name",
      :conditions => ["zhidao_topic_id = ? and is_delete = ?", @topic_id, 0],
      :order => "created_at ASC")
    
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("visitor", "question", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    session[:validate_code001] = get_rand(1000, 9999) #生成验证码
    render :layout => 'visitor_question'
  end
  
  #公司
  def company
    session[:seo_page] = "company"
    
    # 帖子
    @company_id = params[:id].to_i
    
    # 浏览数
    AskHejiaCompany.view(@company_id)
    
    @company = AskHejiaCompany.find(:first, :select => "id, user_id, cn_name, address, tel, linkman, web_stage, country, area, description, post_counter, view_counter, created_at",
      :conditions => ["area_id = ? and is_delete = ? and id = ?", 1, 0 , @company_id])
    
    #回复
    @company_posts = AskHejiaCompanyPost.find(:all, :select => "id, user_id, content, created_at",
      :conditions => ["hejia_company_id = ? and is_delete = ?", @company_id, 0],
      :order => "created_at ASC")
  
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("visitor", "company", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'visitor_question'
  end
  
  def entry  #知识（分享）
    session[:seo_page] = "question"
    
    #    帖子
    @topic_id = params[:id].to_i
    
    #    浏览计数
    AskZhishiTopic.view(@topic_id)
    
    @topic = AskZhishiTopic.find(:first, :select => "id, user_id, tag_id, subject, description, post_counter, view_counter, created_at, reference",
      :conditions => ["area_id = ? and is_delete = ? and id = ? and tag_id > 0", 1, 0, @topic_id])
    
    #    回复
    @posts = AskZhishiTopicPost.find(:all, :select => "id, user_id, content, created_at",
      :conditions => ["zhishi_topic_id = ? and is_delete = ?", @topic_id, 0],
      :order => "created_at ASC")
    
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("visitor", "entry", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'visitor_entry'
  end
  
  #  浏览分类--知道
  #  tp:
  #  全部问题--0
  #  已解决--1
  #  待解决--2
  #  零回答--3
  def browse
    redirect_to "/"
  end
  
  #  浏览分类--知识（分享）
  def entrybrowse
    session[:seo_page] = "level123"
    
    tags
    #    标签
    @tag_id = params[:id].to_i
    self_and_children_ids = get_self_and_children_ids_by_tag_id(@tag_id)
    if params[:ct]  #一级目录
      #      if params[:ct].to_i == 1
      #        @tags = Tag.find(:all, :select => "id",
      #          :conditions => ["parent_id = ?", @tag_id],
      #          :limit => 6)
      #        
      #        #  精彩回答
      #        @topics0 = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id, view_counter, post_counter, created_at", 
      #          :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and tag_id in (#{self_and_children_ids})", 1, 0], 
      #          :order => 'post_counter DESC', 
      #          :limit => 10)
      #        
      #        #  问题列表
      #        @topics1 = AskZhidaoTopic.find(:all, :select => "id, subject, tag_id, view_counter, post_counter, created_at, description, user_id", 
      #          :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and tag_id in (#{self_and_children_ids})", 1, 0], 
      #          :order => 'id DESC', 
      #          :limit => 10)
      #        
      #        render :partial => 'browselevel1', :layout => 'visitor_entrybrowse'
      #      end
    else
      if params[:tp]  #type
        if params[:tp].to_i == 0  #全部
          @topic_pages, @topics = paginate(:ask_zhishi_topics, :select => "id, subject, tag_id, view_counter, post_counter, user_id, description", 
            :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id in (#{self_and_children_ids})", 1, 0], 
            :order => 'id DESC', 
            :per_page => 10)
        end
      else
        @topic_pages, @topics = paginate(:ask_zhishi_topics, :select => "id, subject, tag_id, view_counter, post_counter, user_id, description", 
          :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id in (#{self_and_children_ids})", 1, 0], 
          :order => 'id DESC', 
          :per_page => 10)
      end
      #访问记录--
      visitor_id = get_user_id_by_cookie_name()
      AskStatistic.save("visitor", "entrybrowse", request.request_uri, visitor_id, request.remote_ip)
      #--访问记录
      render :partial => 'entrybrowselevel2', :layout => 'visitor_entrybrowse'
    end
  end
  
  #  搜索
  #  tp:
  #  已解决--1
  #  待解决--2
  def s
    session[:seo_page] = "search"
    
    tags
    if strip(params[:wd]) and strip(params[:wd])!= ""  #关键词非空
      session[:wd] = strip(params[:wd])
      
      user_id0 = get_user_id_by_cookie_name()
      AskSearchKeyword.save(session[:wd], user_id0, request.remote_ip)
      
      if params[:tp]
        if params[:tp].to_i == 1  #已解决
          @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, tag_id, view_counter, post_counter, best_post_id, user_id, description", 
            :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id > 0 and subject like ?",
              1, 0, '%'+strip(params[:wd])+'%'], 
            :order => 'id DESC', 
            :per_page => 10)
          @state = "已解决"
        end
        if params[:tp].to_i == 2  #待解决
          @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, tag_id, view_counter, post_counter, best_post_id, user_id, description", 
            :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id is null and subject like ?",
              1, 0, '%'+strip(params[:wd])+'%'], 
            :order => 'id DESC', 
            :per_page => 10)
          @state = "待解决"
        end
#        if params[:tp].to_i == 3 #涂料百科知识
#          @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, tag_id, view_counter, post_counter, best_post_id, user_id, description", 
#            :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?",
#              1, 0, '%'+strip(params[:wd])+'%'], 
#            :order => 'id DESC', 
#            :per_page => 10)
#        end 
      else  #默认为已解决
        @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, tag_id, view_counter, post_counter, best_post_id, user_id, description", 
          :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id > 0 and subject like ?",
            1, 0, '%'+strip(params[:wd])+'%'], 
          :order => 'id DESC', 
          :per_page => 10)
        @state = "已解决"
      end
      #访问记录--
      visitor_id = get_user_id_by_cookie_name()
      AskStatistic.save("visitor", "s", request.request_uri, visitor_id, request.remote_ip)
      #--访问记录
      render :partial => 'results', :layout => 'visitor_search'
    else  #关键词为空
      #
      redirect_to :action => "index"
    end
  end
  
  def u
    redirect_to "/"
  end
  
  #  tp:
  #  全部问题--0
  #  已解决--1
  #  待解决--2
  #  零回答--3
  def ut  #用户标签--知道

    redirect_to "/list/s/1.html"
    
#    session[:seo_page] = "usertag"
#
#    tags
#    @user_tag_id = params[:utid].to_i
#    topic_ids = AskTopicUserTag.find(:all, :select => "DISTINCT topic_id",
#      :conditions => ["topic_type_id = ? and user_tag_id = ?", 1, @user_tag_id]).collect{|t| t.topic_id}.join(',')
#    if topic_ids == ""
#      topic_ids = "null"
#    end
#    if params[:tp]  #type
#      if params[:tp].to_i == 1  #已解决
#        @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, tag_id, view_counter, post_counter, best_post_id, user_id, description",
#          :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id > 0 and id in (#{topic_ids})", 1, 0],
#          :order => 'id DESC',
#          :per_page => 10)
#      end
#      if params[:tp].to_i == 2  #待解决
#        @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, tag_id, view_counter, post_counter, best_post_id, user_id, description",
#          :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and best_post_id is null and id in (#{topic_ids})", 1, 0],
#          :order => 'id DESC',
#          :per_page => 10)
#      end
#    else  #默认为全部问题
#      @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, tag_id, view_counter, post_counter, best_post_id, user_id, description",
#        :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and id in (#{topic_ids})", 1, 0],
#        :order => 'id DESC',
#        :per_page => 10)
#    end
#    #访问记录--
#    visitor_id = get_user_id_by_cookie_name()
#    AskStatistic.save("visitor", "ut", request.request_uri, visitor_id, request.remote_ip)
#    #--访问记录
#    render :layout => 'visitor_usertag'
  end
  
  def entryut  #用户标签--知识（分享）
    session[:seo_page] = "usertag"
    
    tags
    @user_tag_id = params[:utid].to_i
    topic_ids = AskTopicUserTag.find(:all, :select => "DISTINCT topic_id",
      :conditions => ["topic_type_id = ? and user_tag_id = ?", 2, @user_tag_id]).collect{|t| t.topic_id}.join(',')
    if topic_ids == ""
      topic_ids = "null"
    end
    if params[:tp]  #type
      if params[:tp].to_i == 0  #全部
        @topic_pages, @topics = paginate(:ask_zhishi_topics, :select => "id, subject, tag_id, view_counter, post_counter, user_id, description", 
          :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and id in (#{topic_ids})", 1, 0], 
          :order => 'id DESC', 
          :per_page => 10)
      end
    else  #默认为全部
      @topic_pages, @topics = paginate(:ask_zhishi_topics, :select => "id, subject, tag_id, view_counter, post_counter, user_id, description", 
        :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and id in (#{topic_ids})", 1, 0], 
        :order => 'id DESC', 
        :per_page => 10)
    end
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("visitor", "entryut", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'visitor_entryusertag'
  end
  
  def userslogin
    render :partial => 'usersLogin'
  end
  
  def unknown_request
    redirect_to "#{BASEURL}"
  end
  
  def discussionlist  #讨论
    session[:seo_page] = "list"
    
    top
    gonggao
    if params[:tid]

    else
      if params[:tp].to_i == 0  #全部
        @tag_pages, @tags = paginate(:ask_taolun_tags, :select => "id, name", 
          :order => "id ",
          :per_page => 10)
        @state = "全部"
      end
    end
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("visitor", "discussionlist", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'visitor_discussionlist'
  end
  
  def discussion  #讨论
    session[:seo_page] = "question"
    
    #    帖子
    @topic_id = params[:id].to_i
    
    #    浏览计数
    AskTaolunTopic.view(@topic_id)
    
    @topic = AskTaolunTopic.find(:first, :select => "id, user_id, tag_id, subject, description, post_counter, view_counter, created_at, reference",
      :conditions => ["area_id = ? and is_delete = ? and id = ? and tag_id > 0", 1, 0, @topic_id])
    
    #    回复
    @posts = AskTaolunTopicPost.find(:all, :select => "id, user_id, content, created_at",
      :conditions => ["taolun_topic_id = ? and is_delete = ?", @topic_id, 0],
      :order => "created_at ASC")
    
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("visitor", "discussion", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'visitor_discussion'
  end
  
  def discussionbrowse
    session[:seo_page] = "level123"
    
    tags
    #    标签
    @tag_id = params[:id].to_i
    #    self_and_children_ids = get_self_and_children_ids_by_tag_id(@tag_id)
    if params[:ct]  
    else
      if params[:tp]  #type
        if params[:tp].to_i == 0  #全部
          @topic_pages, @topics = paginate(:ask_taolun_topics, :select => "id, subject, tag_id, view_counter, post_counter, user_id, description", 
            :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id = #{@tag_id}", 1, 0], 
            :order => 'id DESC', 
            :per_page => 10)
          @top_topics = AskTaolunTopic.find(:all, :select => "id,is_top,subject,created_at,view_counter, post_counter",
            :conditions => ["is_top > 0 and area_id = ? and user_id >= 0 and tag_id = #{@tag_id} and is_delete = ?", 1, 0],
            :order => "is_top DESC",
            :limit => 8)
        end
      else
        @topic_pages, @topics = paginate(:ask_taolun_topics, :select => "id, subject, tag_id, view_counter, post_counter, user_id, description", 
          :conditions => ["area_id = ? and user_id >= 0 and is_delete = ? and tag_id = #{@tag_id}", 1, 0], 
          :order => 'id DESC', 
          :per_page => 10)
        @top_topics = AskTaolunTopic.find(:all, :select => "id,is_top,subject,created_at,view_counter, post_counter",
          :conditions => ["is_top > 0 and area_id = ? and user_id >= 0 and tag_id = #{@tag_id} and is_delete = ?", 1, 0],
          :order => "is_top DESC",
          :limit => 8)
      end
      
      #访问记录--
      visitor_id = get_user_id_by_cookie_name()
      AskStatistic.save("visitor", "discussionbrowse", request.request_uri, visitor_id, request.remote_ip)
      #--访问记录
      render :partial => 'discussionbrowselevel2', :layout => 'visitor_discussionbrowse'
    end
  end
  
  def discussionut  #用户标签--讨论
    session[:seo_page] = "usertag"
    
    tags
    @user_tag_id = params[:utid].to_i
    topic_ids = AskTopicUserTag.find(:all, :select => "DISTINCT topic_id",
      :conditions => ["topic_type_id = ? and user_tag_id = ?", 2, @user_tag_id]).collect{|t| t.topic_id}.join(',')
    if topic_ids == ""
      topic_ids = "null"
    end
    if params[:tp]  #type
      if params[:tp].to_i == 0  #全部
        @topic_pages, @topics = paginate(:ask_taolun_topics, :select => "id, subject, tag_id, view_counter, post_counter, user_id, description", 
          :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and id in (#{topic_ids})", 1, 0], 
          :order => 'id DESC', 
          :per_page => 10)
      end
    else  #默认为全部
      @topic_pages, @topics = paginate(:ask_taolun_topics, :select => "id, subject, tag_id, view_counter, post_counter, user_id, description", 
        :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and id in (#{topic_ids})", 1, 0], 
        :order => 'id DESC', 
        :per_page => 10)
    end
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("visitor", "discussionut", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
    render :layout => 'visitor_discussionusertag'
  end

  def list_wiki
    wiki_id = params[:wid].to_i
    if wiki_id == 1
      redirect_to '/nipponpaint_wiki.html'
    else
      #todo
    end
  end

  def wiki
    wiki_id = params[:id].to_i
    catalog_id = params[:catalog].to_i
    item_id = params[:item_id].to_i
    if item_id.nil? || item_id == 0
      @wiki = AskWikiItem.find(:first,:conditions=>["content_id = ? and catalog_id = ? and is_delete = 0",wiki_id, catalog_id])
    else
      @wiki = AskWikiItem.find(:first,:conditions=>["id = ? and is_delete = 0",item_id])
    end
    item_id_new = @wiki.id
    @wiki_next = AskWikiItem.find(:first,:conditions=>[" id > ? and is_delete = 0 and catalog_id = ?", item_id_new,catalog_id])
    @wiki_pre =  AskWikiItem.find(:first,:conditions=>[" id < ? and is_delete = 0 and catalog_id = ?", item_id_new,catalog_id])

    render :layout => 'visitor_wiki'
  end


#  def list_wiki
#    @wiki_id = params[:id].to_i
#
#    @wiki = WikiContent.find(:first, :conditions => ["id = ? and is_del = 0",@wiki_id])
#    @wiki_lists = WikiContent.find(:all, :conditions => ["name = ? and is_del = 0",@wiki.name])
#    @tag = WikiContent.find(:first, :conditions => ["id = ? and is_del = 0",@wiki_id])
#     keyword = @wiki.name
#    @topics = AskZhidaoTopic.find(:all, :select => "id, subject",
#      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and subject like ?", 1, 0, '%'+keyword+'%'],
#      :order => 'id DESC',
#      :limit => 10)
#
#    @posts = AskZhidaoTopicPost.find(:all, :select =>"id, user_id, guest_email, content, created_at",
#      :conditions =>["zhidao_topic_id = ? and is_delete =?", 0 , 0],
#      :order => 'created_at DESC')
#
#    render :layout => 'rest_list_dope_wiki'
#  end
  
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
  
  def get_tag_name_by_tag_id(tag_id)
    tag_name = Tag.find(:first, :select => "name", :conditions => ["id = ?", tag_id]).name
    return tag_name
  end
  
end
