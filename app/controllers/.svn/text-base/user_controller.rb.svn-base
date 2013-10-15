class UserController < ApplicationController
  #  before_filter :is_user
  before_filter :is_admin, :only => [ :company, :preview_company, :save_company ]

  ## 汉字验证码
  def get_image_code
    validate_image = ValidateImage.new(5)
    session[:image_code] = validate_image.code
    send_data(validate_image.code_image, :type => 'image/jpeg')
  end

  #  预览
  def preview
    @user_id = get_user_id_by_cookie_name()
    @title = strip(params[:ti])
    @description = strip(params[:co].to_s)
    @user_tags = strip(params[:ut])
    @guest_name = strip(params[:gn])
    tag_id = params[:cid].to_i
    if tag_id != 0
      @tag = Tag.find(:first, :select => "name", :conditions => ["id = ?", tag_id]).name
    end
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("user", "preview", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end
  
  #  预览--分享
  def preview_share
    @user_id = get_user_id_by_cookie_name()
    @title = strip(params[:ti])
    @description = strip(params[:co].to_s)
    @user_tags = strip(params[:ut])
    @reference = strip(params[:co2].to_s.gsub("\n","<br>"))
    tag_id = params[:cid].to_i
    if tag_id != 0
      @tag = Tag.find(:first, :select => "name", :conditions => ["id = ?", tag_id]).name
    end
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("user", "preview_share", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end
  
  def company  #显示公司
    
  end
  
  # 预览--公司
  def preview_company
    @user_id = get_user_id_by_cookie_name()
    @cn_name = strip(params[:name])
    @description = strip(params[:description].to_s)
    @address = strip(params[:address])
    @tel = strip(params[:tel])
    @linkman = strip(params[:linkman]) 
    @web_stage = strip(params[:web_stage])
    @country = strip(params[:country])
    @area = strip(params[:area])
    @guild_id = strip(params[:guild_id])
  end
  
  #  发贴
  def save
    tag1 = params[:ClassLevel1]
    tag2 = params[:ClassLevel2]
    tag3 = params[:ClassLevel3]
    
    tag2 = 0 if params[:ClassLevel2] == ""
    tag3 = 0 if params[:ClassLevel3] == ""
    
    tag_id = tag1 if (tag2 == 0) and (tag3 == 0)
    tag_id = tag2 if (tag2 != 0) and (tag3 == 0)
    tag_id = tag3 if (tag2 != 0) and (tag3 != 0)
    
    user_id = get_user_id_by_cookie_name()
    tag_id = tag_id.to_i
    title = strip(escape_invalid_characters(params[:ti].to_s))
    description = strip(escape_invalid_characters(params[:co].to_s))
    user_tags = strip(escape_invalid_characters(params[:ut].to_s))
    guest_name = strip(params[:gn])
    guest_email = strip(params[:email].to_s)
    
    result = AskZhidaoTopic.count ["subject = ? and area_id = ? and method = ?", title, 1, 3]
    if result == 0
      if (tag_id == 0) or (title == "")
        #
      else
        AskZhidaoTopic.save(user_id, tag_id, title, description, user_tags, guest_name, guest_email, request.remote_ip)
      end
    else
      flash[:notice] = "该问答已存在"
    end
    redirect_to "/visitor/list?tp=2"
  end
  
  #  发贴--分享
  def save_share
    tag1 = params[:ClassLevel1]
    tag2 = params[:ClassLevel2]
    tag3 = params[:ClassLevel3]
    
    tag2 = 0 if params[:ClassLevel2] == ""
    tag3 = 0 if params[:ClassLevel3] == ""
    
    tag_id = tag1 if (tag2 == 0) and (tag3 == 0)
    tag_id = tag2 if (tag2 != 0) and (tag3 == 0)
    tag_id = tag3 if (tag2 != 0) and (tag3 != 0)
    
    user_id = get_user_id_by_cookie_name()
    tag_id = tag_id.to_i
    title = strip(escape_invalid_characters(params[:ti].to_s))
    description = strip(escape_invalid_characters(params[:co].to_s))
    user_tags = strip(escape_invalid_characters(params[:ut].to_s))
    reference = strip(escape_invalid_characters(params[:co2].to_s).gsub("\n","<br>"))
    guest_email = strip(params[:email].to_s)
    
    result = AskZhishiTopic.count ["subject = ? and area_id = ? and method = ?", title, 1, 3]
    if result == 0
      if (tag_id == 0) or (title == "")
        #
      else
        AskZhishiTopic.save(user_id, tag_id, title, description, user_tags, reference, guest_email, request.remote_ip)
      end
    else
      flash[:notice] = "该词条已存在"
    end
    redirect_to "/visitor/entrylist?tp=0"
  end
  
  # 发帖--公司
  def save_company
    
    user_id = get_user_id_by_cookie_name()
    cn_name = strip(params[:name].to_s)
    description = strip(params[:co_description].to_s)
    address = strip(params[:address].to_s)
    tel = strip(params[:tel].to_s)
    linkman = strip(params[:linkman].to_s) 
    web_stage = strip(params[:web_stage].to_s)
    country = strip(params[:country].to_s)
    area = strip(params[:area].to_s)
    guild_id = strip(params[:guild_id].to_s)
    
    AskHejiaCompany.save(user_id, cn_name, description, address, tel, linkman, web_stage, country, area, guild_id)
    
    redirect_to "/visitor/companylist"
  end
  
  #  回复--知道
  def reply
    rt = ""
    zhidao_topic_id = params[:tid].to_i
    user_id = get_user_id_by_cookie_name()
    content = strip(params[:ro].to_s)
    guest_email = strip(params[:email].to_s)
    guest_name = strip(params[:gn])
    unless user_id > 0
      if params[:validate_code].to_i != session[:validate_code001]
        rt = "操作失败：验证码不正确！"
      end
    end
    rt = "操作失败：请输入回复内容！" if content == ""
    if rt == ""
      AskZhidaoTopicPost.save(zhidao_topic_id, user_id, content, guest_name, guest_email, request.remote_ip)

      #--发送邮件
#      azt = AskZhidaoTopic.find(zhidao_topic_id)
#      if azt.guest_email.nil?
#        #
#      else
#        match = Regexp.compile('^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$').match(guest_email)
#        if match
#          @zhidao_topic_id = zhidao_topic_id
#          email = Notifications.create_reply_notification(@zhidao_topic_id)
#          email.set_content_type("text/html; charset=utf-8")
#          Notifications.deliver(email)
#        end
#      end
      #发送邮件--
      render :text => js(top_load("self"))
    else
      render :text => alert(rt)
    end
    #redirect_to "/visitor/question/#{zhidao_topic_id}.html#reply"
  end
  
  #  回复--知识（分享）
  def reply_entry
    zhishi_topic_id = params[:tid].to_i
    user_id = get_user_id_by_cookie_name()
    content = strip(params[:ro].to_s)
    guest_email = strip(params[:email].to_s)
    
    AskZhishiTopicPost.save(zhishi_topic_id, user_id, content, guest_email, request.remote_ip)
    redirect_to "/visitor/entry/#{zhishi_topic_id}.html#reply"
  end
  
  #  回复--涂料
  def reply_dope
    zhidao_topic_id = 0
    user_id = get_user_id_by_cookie_name()
    content = strip(params[:ro].to_s)
    guest_email = strip(params[:email].to_s)
    
    AskZhidaoTopicPost.save1(zhidao_topic_id, user_id, content, guest_email, request.remote_ip)
    redirect_to "/visitor/list_dope_wiki#reply"
  end
  
  # 回复--公司
  def reply_company
    hejia_company_id = params[:tid].to_i
    user_id = get_user_id_by_cookie_name()
    content = strip(params[:ro].to_s)
    guest_email = strip(params[:email].to_s)
    
    AskHejiaCompanyPost.save(hejia_company_id, user_id, content, guest_email, request.remote_ip)
    redirect_to "/visitor/company/#{hejia_company_id}.html#reply"
  end
  
  #  评为最佳
  def isbest
    zhidao_topic_id = params[:btid].to_i
    best_post_id = params[:bpid].to_i
    user_id = get_user_id_by_cookie_name()
    user_id0 = params[:tuid].to_i
    if user_id0 == user_id
      AskZhidaoTopic.best_post(zhidao_topic_id, best_post_id)
    end
    redirect_to "/visitor/question/#{zhidao_topic_id}.html"
  end
  
  #  我的提问、我的回答
  #  tp
  #  1  表示我的提问
  #  2  表示我的回答
  def qa
    if params[:tp]
      user_id = get_user_id_by_cookie_name()
      if params[:tp].to_i == 1  #我的提问
        @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject, post_counter", 
          :conditions => ["area_id = ? and user_id = ? and is_delete = ? and best_post_id is null and tag_id > 0", 1, user_id, 0], 
          :order => 'id DESC', 
          :per_page => 10)
        render :partial => 'myq'
      end
      if params[:tp].to_i == 2  #我的回答
        @post_pages, @posts = paginate(:ask_zhidao_topic_posts, :select => "id, zhidao_topic_id",
          :conditions => ["user_id = ? and is_delete = ?", user_id, 0],
          :order => 'id DESC',
          :per_page => 10)
        render :partial => 'mya'
      end
    end
  end
  
  def tiny_mce_upload
    render :layout => 'user_tiny_mce_upload'
  end
  
  def save_upload
    @upload = AskUserUpload.new(params[:ask_user_upload])
    if @upload.save
      user_id = get_user_id_by_cookie_name()
      base_url = BASEURL
      filename = @upload.public_filename()
      image_url = base_url + filename
      begin
        @upload.type_id = 1
        @upload.user_id = user_id
        @upload.ip = request.remote_ip
        @upload.path = filename
        @upload.flag = 1
        @upload.save
        flash[:notice] = "<script language=JavaScript defer>window.returnValue ='#{image_url}';window.close();</script>"
      rescue
        flash[:notice] = "<script language=JavaScript defer>alert('图片上传失败，请重新上传！');window.close();</script>"
      end
    else
      flash[:notice] = "<script language=JavaScript defer>alert('图片上传失败，请重新上传！');window.close();</script>"
    end
    render :layout => 'user_save_upload'
  end
  
  def preview_discussion #预览--讨论
    @user_id = get_user_id_by_cookie_name()
    @title = strip(params[:ti])
    @description = strip(params[:co].to_s)
    @user_tags = strip(params[:ut])
    @reference = strip(params[:co2].to_s.gsub("\n","<br>"))
    tag_id = params[:cid].to_i
    if tag_id != 0
      @tag = Tag.find(:first, :select => "name", :conditions => ["id = ?", tag_id]).name
    end
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("user", "preview_discussion", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end
  
  def ask
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("user", "ask", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end

  def share
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("user", "share", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end
  
  def discussion  #标签--讨论
    @tags = AskTaolunTag.find(:all, :select => "id, name", 
      :order => "id ")
    #访问记录--
    visitor_id = get_user_id_by_cookie_name()
    AskStatistic.save("user", "discussion", request.request_uri, visitor_id, request.remote_ip)
    #--访问记录
  end
   
  def save_discussion   #  发贴--讨论
    tag1 = params[:ClassLevel1]
    tag_id = tag1
    
    user_id = get_user_id_by_cookie_name()
    tag_id = tag_id.to_i
    title = strip(params[:ti].to_s)
    description = strip(params[:co].to_s)
    user_tags = strip(params[:ut].to_s)
    guest_email = strip(params[:email].to_s)
    
    result = AskTaolunTopic.count ["subject = ? and area_id = ? and method = ?", title, 1, 3]
    if result == 0
      AskTaolunTopic.save(user_id, tag_id, title, description, user_tags, guest_email, request.remote_ip)
    else
      flash[:notice] = "该词条已存在"
    end
    redirect_to "/visitor/discussionbrowse/#{tag_id}.html"
  end
  
  #  回复--讨论
  def reply_discussion
    taolun_topic_id = params[:tid].to_i
    user_id = get_user_id_by_cookie_name()
    content = strip(params[:ro].to_s)
    guest_email = strip(params[:email].to_s)
    
    AskTaolunTopicPost.save(taolun_topic_id, user_id, content, guest_email, request.remote_ip)
    redirect_to "/visitor/discussion/#{taolun_topic_id}.html#reply"
  end

  def delete_topic  #删除帖子——编辑
    topic_id = params[:tid].to_i
    admin_id = get_user_id_by_cookie_name()
    user_id = params[:uid].to_i
    tag_id = params[:tagid].to_i
    if (is_admin(user_id).nil?) or (admin_id != user_id)
      #
    else
      AskZhidaoTopic.delete(topic_id, admin_id)
    end
    redirect_to "/visitor/browse/#{tag_id}.html"
  end

  def delete_post  #删除回复——编辑
    post_id = params[:pid].to_i
    admin_id = get_user_id_by_cookie_name()
    user_id = params[:uid].to_i
    topic_id = strip(params[:tid])
    if (is_admin(user_id).nil?) or (admin_id != user_id)
      #
    else
      AskZhidaoTopicPost.delete_post(post_id, admin_id)
    end
    redirect_to "/visitor/question/#{topic_id}"
  end

  private
  def is_admin(admin_id)
    afa = AskZhidaoAdmin.find(:first, :select => "id",:conditions => ["is_delete = 0 and admin_id = ?",admin_id])
    return afa
  end
   
end