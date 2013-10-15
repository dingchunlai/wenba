class ListController < ApplicationController

  def default
    expire_fragment 'ming_xing_zhuan_jia' unless params[:no_cache].nil?
  end

  def user_question #某会员的提问列表
    @user_id = params[:user_id].to_i
    @username = params[:username]
    @username = HejiaUserBbs.find(@user_id,:select=>"USERNAME").USERNAME unless pp(@username)
    conditions = []
    conditions << "user_id = #{@user_id}"
    conditions << "is_delete = 0"
    @topics = paging_record options = {
      "model" => AskZhidaoTopic,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id, subject, best_post_id, post_counter, created_at",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
  end

  def user_answer #某会员的回答列表
    @user_id = params[:user_id].to_i
    @username = params[:username]
    @username = HejiaUserBbs.find(@user_id,:select=>"USERNAME").USERNAME unless pp(@username)
    topic_ids = []
    topics = AskZhidaoTopicPost.find(:all,:select=>"zhidao_topic_id",:conditions=>"user_id = #{@user_id} and is_delete = 0")
    for topic in topics
      topic_ids << topic.zhidao_topic_id
    end
    conditions = []
    if topic_ids.length == 0
      conditions << "false"
    else
      conditions << "id in (#{topic_ids.uniq.join(",")})"
      conditions << "is_delete = 0"
    end
    @topics = paging_record options = {
      "model" => AskZhidaoTopic,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id, subject, best_post_id, post_counter, created_at",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
  end

  def sort
#    if RAILS_ENV == 'development'
#      uuu = HejiaUserBbs.find(7213592)
#      login_user!(uuu)
#      login_staff!(HejiaStaff.find(:first))
#    end
    if params[:tp].nil?
      @tp = 4
    else
      @tp = params[:tp].to_i
    end
    @tag_id = params[:tag_id].to_i
    @wd = trim(params[:wd])
    @wd = nil if @wd == "请在这里输入您要搜索的关键字" || @wd.to_s.length < 2

    @tag_level = Tag.get_tag_level(@tag_id)
    if @tag_level <= 1
      @parent_tag_id = @tag_id
    else
      @parent_tag_id = get_parent_tag_id(@tag_id)
    end

    if @tag_id == 267
      @tp = 0
      @recordcount = 999
      @topics = get_topics(true)
    elsif params[:page].to_i < 2 && @wd.nil? #如果是第一页并且是非搜索页，尝试使用缓存
      kw_topics = get_mc_kw(KW_TOPICS_LIST, "tag_id", @tag_id, "tp", @tp)
      kw_topics_rc = "#{@tag_id}_#{@tp}_rc"
      AskZhidaoTopic
      @topics = CACHE.get(kw_topics)
      if @topics.nil? #如果不存在缓存
        @topics = get_topics
        CACHE.set(kw_topics, @topics, 30.minutes)
        CACHE.set(kw_topics_rc, @recordcount, 1.hour)
      else
        @curpage = 1;
        @pagesize = 10;
        @listsize = 10;
        @recordcount = CACHE.get(kw_topics_rc)
      end
    else  #如果是其它情况，不使用缓存
      @topics = get_topics
    end

    if @tag_id == 0
      @title = "全部问题-和家问吧"
    else
      @title = "#{get_tag_name_by_tag_id(@tag_id)}-全部问题-和家问吧"
    end

  end

  def get_topics(all=false)
    cd = ["is_delete=0"]
    order = " id desc"

    if all
      
    else
      sub_tag_ids = Tag.get_sub_tag_ids(@tag_id)
      case @tag_level
      when 0
        cd << "tag_id is not null and tag_id<>8"
      when 1
        cd << "tag_id <> 8"
        cd << "tag_id in (#{sub_tag_ids.join(",")})" if sub_tag_ids.length > 0
      when 3
        cd << "tag_id = #{@tag_id}"
      else
        cd << "tag_id in (#{sub_tag_ids.join(",")})" if sub_tag_ids.length > 0
      end

      cd << "subject like '%#{@wd}%'" unless @wd.blank?

      case @tp
      when 0  #全部问题
      when 1  #待解决
        cd << "post_counter = 0"
      when 2  #已解决
        cd << "post_counter > 0"
      when 3  #高分题
        order = " score desc"
      when 4  #点击排行
        order = " view_counter desc"
      end
    end

    h = Hash.new
    h["model"] = AskZhidaoTopic
    h["pagesize"] = 20 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, subject, user_id, tag_id, created_at, post_counter, view_counter, best_post_id, score, last_reply_time, tag_id"
    h["conditions"] = cd.join(" and ")
    h["order"] = order
    return paging_record(h)
  end

end
