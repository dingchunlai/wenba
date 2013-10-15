class DetailController < ApplicationController
  
  include IpHelper

  def new_posts
    limit = 30
    limit = params[:id].to_i if params[:id].to_i > 0
    @posts = AskZhidaoTopicPost.find(:all,
      :select=>"id, zhidao_topic_id, user_id, content, created_at,guest_email,ip,guest_name,expert",
      :conditions => "is_delete = 0",
      :order => "id desc",
      :limit => limit
    )
  end

  def do_expire_topic_info
    topic_id = params[:topic_id].to_i
    return false if topic_id < 1
    kw = get_mc_kw(KW_TOPIC_INFO, "topic_id", topic_id)
    CACHE.delete(kw)
    render :text => "topic_id: #{topic_id} 缓存已清除！"
  end

  def format_expert
    user_id = params[:user_id].to_i
    if user_id == 0
      render :text => "用户不存在！"
    else
      CommunityUser.set_question_num(user_id, 0) #修改或重新统计用户提问数
      CommunityUser.set_answer_num(user_id, 0)
      user = CommunityUser.find_by_user_id(user_id,:select=>"id,point,wenba_answer_num")
      user.point = user.wenba_answer_num.to_i * 7
      user.save
      render :text => "处理成功!"
    end
  end

  def accept_post(rv = "", is_reload = false)
    topic_id = params[:topic_id].to_i
    post_id = params[:post_id].to_i
    topic = AskZhidaoTopic.find(topic_id,:select=>"id,subject,description,tag_id,best_post_id,user_id,guest_name,guest_email,score,created_at")
    rv = "帖子不存在！" if topic_id==0 || post_id==0 || topic.nil?
    rv = "您不是该贴的主人，无法执行该操作！" if topic.user_id != current_user.id.to_i
    if rv == ""
      begin
        topic.best_post_id = post_id
        topic.save
        best_post = AskZhidaoTopicPost.find(post_id,:select=>"id, is_best_post")
        best_post.is_best_post = 1
        best_post.save
        i = 1
        posts = AskZhidaoTopicPost.find(:all,:select=>"id, zhidao_topic_id, user_id, content, created_at,guest_email,ip,guest_name,expert",:conditions=>["zhidao_topic_id=? and user_id>0 and is_delete=0", topic.id],:order=>"id asc")
        for post in posts
          if i == 1
            #第一个回复用户            
            if CommunityUser.is_expert(post.user_id)
              CommunityUser.set_point(post.user_id, 10)
            else
              CommunityUser.set_point(post.user_id, 3)
            end
          else
            #第二个及以后回复用户            
            if CommunityUser.is_expert(post.user_id)
              CommunityUser.set_point(post.user_id, 3)
            else
              CommunityUser.set_point(post.user_id, 1)
            end
          end
          CommunityUser.set_point(post.user_id, topic.score.to_i) if post_id == post.id  #给最佳回复贴加悬赏分
          i += 1
        end
        rv = "操作成功：该问题已结贴，谢谢您的参与！"
        is_reload = true
        expire_posts(topic_id) #清除某个问题的回复信息的memcache缓存
      rescue Exception => e
        rv ="操作失败：#{e}"
      end
    end
    rv = alert(rv)
    rv += js(top_load("self")) if is_reload
    render :text => rv
  end

  

  def view
    expires_now
    @adtv_is_view  = get_adtv_is_view()
    @user_id = 0
    if current_user
      @user_id = current_user.id
      @username = current_user.USERNAME
      @password = "keep_old"
    end
    session[:validate_reply] = rand(9000) + 1000

    @topic_id = params[:id].to_i
    @topic = AskZhidaoTopic.get_topic_info(@topic_id)  #取得问题详细信息
    if @topic.nil?
      redirect_to "/"
      return false
    end
    @subject = @topic.subject
    @description = @topic.description
    @best_post_id = @topic.best_post_id.to_i
    @tag_id = @topic.tag_id.to_i
    @tag_level = Tag.get_tag_level(@tag_id)
    if @tag_level <= 1
      @parent_tag_id = @tag_id
    else
      @parent_tag_id = get_parent_tag_id(@tag_id)
    end

    @posts = AskZhidaoTopicPost.get_posts(@topic.id, current_page)

    kw_this_tops = "this_tops_#{@tag_id}"
    @this_tops = CACHE.fetch(kw_this_tops, 1.day) do
      conditions = ['is_delete = 0']
      conditions << 'tag_id <> 8'
      sub_tag_ids = Tag.get_sub_tag_ids(@tag_id)
      conditions << "tag_id in (#{sub_tag_ids.join(',')})" if sub_tag_ids.length > 0
      AskZhidaoTopic.find(:all,:select => "id,subject,post_counter,view_counter",
        :conditions => conditions.join(' and '),
        :order => "view_counter desc",:limit=>10)
    end
    
    AskZhidaoTopic.view(@topic_id)
    tui_api = {
      '上海' => {'日记' =>55241,'案例' =>55242},
      '杭州' => {'日记' =>55157,'案例' =>55159},
      '宁波' => {'日记' =>55071,'案例' =>55243},
      '苏州' => {'日记' =>55188,'案例' =>55160},
      '无锡' => {'日记' =>55218,'案例' =>55217},
      '武汉' => {'日记' =>54580,'案例' =>54581},
      '南京' => {'日记' =>54588,'案例' =>54582},
      '青岛' => {'日记' =>55141,'案例' =>55396}
    }
    @city_name = remote_city[:name]
    
    city_id = CITIES.invert[@city_name] #得到城市ID
    city_id ? city_id : city_id = 11910
    @city_pinyin = TAGURLS[city_id]
    tui_api.keys.include?(@city_name) ? @city_name : @city_name = '上海'

    DecorationDiary
    Picture
    HejiaCase
    @diary_api = hejia_promotion_items(tui_api[@city_name]['日记'], :select =>'title,url,image_url', :limit =>2)

    @diaries = CACHE.fetch "wenba:decoration_diaries:#{city_id}:#{@topic_id}",5.minutes do
      if [11910,11905,11887,11908].include? city_id.to_i
        city_sql = "deco_firms.city = #{city_id}"
      else
        city_sql = "deco_firms.district = #{city_id}"
      end
      DecorationDiary.find(:all,:select =>'decoration_diaries.id,decoration_diaries.title',:joins =>"join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id",:conditions =>"#{city_sql} and decoration_diaries.is_verified = 1",:order =>'decoration_diaries.updated_at desc',:limit =>5)
    end

    HejiaCase
    @cases = CACHE.fetch "wenba:cases:#{city_id}:#{@topic_id}",5.minutes do
      #HejiaCase.published.city_num_is(city_id).find(:all,:limit=>4)
      hejia_promotion_items(tui_api[@city_name]['案例'], :select =>'title,url,image_url', :limit =>7)
    end
  end

  def reply_save(rv = "",load_url = nil) #回答问题保存
    return render :text => alert(TimeMechanism::can_write) unless TimeMechanism::can_write.blank?
    #return render :text => alert("验证码不能为空，请填写验证码！") if params[:image_code].blank?
    #return render :text => alert("验证码错误，请重新填写！") if params[:image_code].to_s.strip != session[:image_code]
    return false unless AskZhidaoTopic.is_allow_post_time
    guest_name = ""
    guest_email = ""
    topic_id = params[:topic_id].to_i
    content = trim(params[:content])
    utf8_length = content.split(//u).length
    if params[:post_type].to_i == 1
      #匿名回复
      return false #暂停匿名回复功能
      user_id = 0
      rv = "操作失败：验证码不正确！" if params[:validate_code].to_i != session[:validate_reply]
    else
      #用户回复
      username = trim(params[:username].to_s)
      password = trim(params[:password].to_s)
      if password == "keep_old" && username == current_user.USERNAME && pp(username)
        #使用已登录的用户信息发帖
        user_id = current_user.id
      else
        #使用当前输入的用户信息发帖
        user_id = HejiaUserBbs.check_user(username,password)
      end
      rv = "提交失败：用户名不存在！" if user_id == 0
      rv = "提交失败：用户名密码不正确！" if user_id == -1
      if user_id > 0
        @wenba_user = WenbaUser.find_by_user_id(user_id)
        if @wenba_user and @wenba_user.state == "1" and @wenba_user.freeze_time > Time.now
          rv = "提交失败：该用户因为 #{@wenba_user.reason} 被禁止回复！"
        end
      end
    end

    rv = "提交失败：回复内容必须长于5个字符！" if utf8_length < 5
    rv = "提交失败：您的回复内容必须包含中文！" if (content.length - utf8_length) < 4
    if rv == ""
      begin
        ip = request.remote_ip
        #特殊处理：如果回帖用户是hejiabbs(即id是7326663)，则调用随机用户和随机IP
        if user_id.to_i == 7326663
          user_id = HejiaUser.get_a_rand_user_id
          ip = HejiaUser.get_a_rand_ip
        end
        AskZhidaoTopicPost.save(topic_id, user_id, content, guest_name, guest_email, ip)
        if user_id != 0
          CommunityUser.set_answer_num(user_id, 1)
          session[:ind_id] = nil
        end
        expire_posts(topic_id) #清除某个问题的回复信息的memcache缓存
        rv = "操作成功：回复已保存！"
        load_url = "self"
        flash[:is_reply] = 1
        session[:validate_reply] = nil
      rescue Exception => e
        rv ="操作失败：#{e}"
      end
    end
    rv = alert(rv.to_s)
    rv += js(top_load(load_url)) unless load_url.nil?
    render :text => rv
  end

  def new_topic #创建新问题
    unless AskZhidaoTopic.is_allow_post_time
      redirect_to "/wenziyu.html"
      return false
    end
    if current_user
      @username = current_user.USERNAME
      @password = "keep_old"
    end
    # session[:validate_newtopic] = rand(9000) + 1000
  end
      
  def new_topic_save(rv = "",load_url = nil)  #新问题保存
    #return false
    return render :text => alert(TimeMechanism::can_write) unless TimeMechanism::can_write.blank?
    #return render :text => alert("验证码不能为空，请填写验证码！") if params[:image_code].blank?
    #return render :text => alert("验证码错误，请重新填写！") if params[:image_code].to_s.strip != session[:image_code]
    return false unless AskZhidaoTopic.is_allow_post_time
    user_ip = request.remote_ip.to_s
    subject = trim(params[:subject].to_s)
    description = trim(params[:description].to_s)
    username = trim(params[:username].to_s)
    password = trim(params[:password].to_s)
    if pp(params[:ClassLevel3])
      tag_id = params[:ClassLevel3].to_i
    else
      tag_id = params[:ClassLevel2].to_i
    end
    score = params[:score].to_i
    if false  #params[:post_type].to_i == 1
      #匿名提问功能暂时取消
      user_id = 0
      rv = "操作失败：验证码不正确！" if params[:validate_code].to_i != session[:validate_newtopic]
    elsif password == "keep_old" && username == current_user.USERNAME && pp(username)
      #使用已登录的用户信息发帖
      user_id = current_user.id.to_i
    else
      #使用当前输入的用户信息发帖
      user_id = HejiaUserBbs.check_user(username,password)
    end

    #特殊处理：如果回帖用户是hejiabbs(即id是7326663)，则调用随机用户和随机IP
    if user_id.to_i == 7326663
      user_id = HejiaUser.get_a_rand_user_id
      user_ip = HejiaUser.get_a_rand_ip
    end

    if user_id == 0
      rv = "提交失败：匿名用户无法提交问题！" #匿名提问功能暂时取消
      #      anonym_ips = mc("anonym_ips") #保存着匿名用户IP和最后发帖时间的哈希表
      #      anonym_ips = Hash.new if anonym_ips.nil?
      #      unless anonym_ips[user_ip].nil?
      #        rv = "操作失败：匿名用户不能在15分钟内重复发帖！" if Time.now - anonym_ips[user_ip] < 900 && !(current_staff && current_staff.wenba_editor?)
      #      end
      #      user_point = 0
    end
    if user_id > 0
      @wenba_user = WenbaUser.find_by_user_id(user_id)
      if @wenba_user and @wenba_user.state == "1" and @wenba_user.freeze_time > Time.now
        rv = "提交失败：该用户因为 #{@wenba_user.reason} 被禁止提问！"
      end
    end
    user_point = CommunityUser.get_point(user_id)
    rv = "提交失败：用户名密码不正确！" if user_id == -1
    rv = "提交失败：您输入的问题标题过短，请重新输入！" if subject.length < 9
    rv = "提交失败：您输入的问题描述过于简单，请重新输入！" if description.length < 15
    rv = "提交失败：请选择二级问题分类！" if tag_id == 0
    rv = "提交失败：您的积分不足，请重新设定悬赏分！" if score > user_point
    rv = "您不能发布相同的帖子！" if AskZhidaoTopic.has_repeated_subject?(subject)
    rv = "您发帖操作过于频繁，请稍候再尝试提交！" if AskZhidaoTopic.get_user_post_rate(user_id, 3.hours) >= 2  && !(current_staff && current_staff.wenba_editor?)
    if rv == ""
      begin
        subjects=FilterWord.word_filter(subject)
        descriptions=FilterWord.word_filter(description)
        if(subjects["ban"] || descriptions["ban"])
          sub=subjects["ban"];des=descriptions["ban"]
          rv = "提交失败";
          rv << "\\n标题有非法用词" if sub
          #rv << "\\n标题有【#{sub}】等非法用词" if sub
          rv << "\\n" if sub && des
          #rv << "详细描述问题有【#{des}】等非法用词" if des
          rv << "详细描述问题有非法用词" if des
          rv << "\\n请重新填写！！！"
        else
          nt = AskZhidaoTopic.new
          nt.subject = subjects["***"]
          nt.description = descriptions["***"]
          unless params[:interrogee].nil?
            interrogee_id = CommunityUser.get_user_id(params[:interrogee]).to_i
            nt.interrogee = interrogee_id if interrogee_id != 0
          end
          nt.user_id = user_id
          nt.ip = user_ip
          nt.area_id = 1
          nt.post_counter = 0
          nt.method = 2
          nt.tag_id = tag_id
          nt.score = score
          nt.is_delete = -1
          nt.created_at = Time.now.to_s(:db)
          nt.updated_at = Time.now.to_s(:db)
          nt.save
          CACHE.delete "haier_zhuanti_designer_#{nt.interrogee}_asks" if [7347809,7356049].include?(nt.interrogee)
          #发帖成功后相关处理 start =====================================
          expire_sortlist(tag_id) #清除某个栏目列表页的memcache缓存
          rv = "提交成功：您的问题已发表！等待网站管理员审核"
          load_url = "/list/sort/#{tag_id}.html?tp=0"
          if user_id == 0 #如果是匿名发帖
            anonym_ips[user_ip] = Time.now
            mc("anonym_ips", anonym_ips)
            session[:validate_newtopic] = nil
          else
            CommunityUser.set_point(user_id, -score) #扣除相应的悬赏分
            CommunityUser.set_question_num(user_id, 1)
            session[:ind_id] = nil
          end
        end
        #发帖成功后相关处理 end =====================================
      rescue Exception => e
        rv ="操作失败：#{e}"
      end
    end
    
   
    myrender(rv, load_url)
  end

  def supply_topic(rv = "",load_url = nil)    #补充问题
    topic_id = params[:topic_id].to_i
    user_id = current_user.id.to_i
    supply = params[:supply_content]
    rv = "参数不足!" if topic_id==0 || user_id==0
    rv = "您的补充描述过于简单!" if supply.length < 12
    if rv == ""
      topic = AskZhidaoTopic.find(topic_id,:select=>"id, user_id, subject, description, supply")
      if topic.nil?
        rv = "问题帖子不存在!"
      elsif topic.user_id.to_i != user_id
        rv = "您不是该问题的发表者!"
      else
        begin
          topic.supply = supply
          topic.save
          load_url = "self"
          expire_topic_info(topic_id)
        rescue Exception => e
          rv = "操作失败：#{e}"
        end
      end
    end
    myrender(rv, load_url)
  end

  def help
    @title = "问吧使用帮助指南_和家网问专家频道_全国最大的家居问答平台"
  end
  
end
