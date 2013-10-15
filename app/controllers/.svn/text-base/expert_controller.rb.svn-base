class ExpertController < ApplicationController

  def index
    @expert_id = params[:expert_id].to_i
    @expert = HejiaUserBbs.find(@expert_id,:select=>"USERBBSID,HEADIMG,USERNAME,POINT,USERBBSREADME")  #:conditions=>"ask_expert>0"
    
    topic_ids = []
    topics = AskZhidaoTopicPost.find(:all,:select=>"zhidao_topic_id",:conditions=>"user_id = #{@expert_id} and is_delete = 0")
    for topic in topics
      topic_ids << topic.zhidao_topic_id
    end

    conditions = []
    conditions << "interrogee = #{@expert_id}"
    conditions << "is_delete = 0"
    @questions = AskZhidaoTopic.find(:all,
      :select => "id, subject, best_post_id, post_counter, created_at",
      :conditions => conditions.join(" and "),
      :order => "id desc",
      :limit => 7
    )



    conditions = []
    if topic_ids.length == 0
      conditions << "false"
    else
      conditions << "id in (#{topic_ids.uniq.join(",")})"
      conditions << "is_delete = 0"
    end
    @my_answers = AskZhidaoTopic.find(:all,
      :select => "id, subject, best_post_id, post_counter, created_at",
      :conditions => conditions.join(" and "),
      :order => "id desc",
      :limit => 7
    )

    conditions = []
    conditions << "user_id = #{@expert_id}"
    conditions << "is_delete = 0"
    @my_questions = AskZhidaoTopic.find(:all,
      :select => "id, subject, best_post_id, post_counter, created_at",
      :conditions => conditions.join(" and "),
      :order => "id desc",
      :limit => 7
    )
  end

end
