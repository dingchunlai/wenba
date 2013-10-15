class AskZhidaoTopic < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia]

  def self.has_repeated_subject?(subject)
    return false if subject.blank?
    topics = AskZhidaoTopic.find(:all, :select => 'id, subject, created_at', :conditions => ['created_at > ? and subject = ?', 2.days.ago.to_s(:db), subject.strip])
    topics.length > 0
  end

  def self.memkey_new_topics
    "wenba_new_topics"
  end

  def self.is_allow_post_time
    rv = true
    rv = false if Time.now >= Time.mktime(2010,10,1) && Time.now <= Time.mktime(2010,10,8)
    rv = false if Time.now.hour <= 8
    return rv
  end

  #取得用户发帖频率
  def self.get_user_post_rate(user_id, duration)
    user_id = user_id.to_i
    return 0 if user_id == 0
    AskZhidaoTopic.count("id", :conditions=>["user_id = ? and created_at > ?", user_id, duration.ago.to_s(:db)])
  end

  #首页人气排行
  def self.get_hot_topics_by_parent_tag_id(parent_tag_id, limit=10, days=900)
    memkey = "hot_topics_#{parent_tag_id}_#{days}"
    rs = CACHE.fetch(memkey, 1.hour) do
      cd = []
      cd << "is_delete=0 and is_distribute = 1 and tag_id not in (8,265,266)"
      sub_tag_ids = Tag.get_sub_tag_ids(parent_tag_id)
      cd << "tag_id in (#{sub_tag_ids.join(',')})" if sub_tag_ids.length > 0
      cd << "created_at > adddate(now(),-#{days.to_i})" #只查询days天内的帖子
      AskZhidaoTopic.find(:all,:select=>"id,subject,post_counter,view_counter",:conditions=>cd.join(" and "),:order=>"post_counter desc, view_counter desc",:limit=>10)
    end
    return rs[0...limit]
  end

  def self.get_topic_info(topic_id)  #取得问题详细信息
    self.find(:first,
        :select => "id,subject,description,supply,tag_id,best_post_id,user_id,guest_name,is_distribute,guest_email,score,created_at",
        :conditions => "id = #{topic_id} and is_delete = 0")
  end

  def self.get_hot_topics(limit, days)
    kw = get_mc_kw(KW_HOT_TOPICS, "limit", limit, "days", days)
    topics = CACHE.fetch(kw, 1.day) do
      cd = []
      cd << "is_delete=0 and tag_id not in (8,265,266)"
      cd << "created_at > adddate(now(),-#{days.to_i})" #只查询days天内的帖子
      AskZhidaoTopic.find(:all,:select=>"id,subject,post_counter,view_counter",:conditions=>cd.join(" and "),:order=>"post_counter desc",:limit=>limit)
    end
    return topics[0...limit]
  end

  def self.save(user_id, tag_id, subject, description, user_tags, guest_name, guest_email, ip, area_id=1, method=3, topic_type_id=1)
    transaction() {
      azt = AskZhidaoTopic.new
      azt.user_id = user_id
      azt.tag_id = tag_id
      azt.subject = subject
      azt.description = description
      azt.guest_name = guest_name
      azt.guest_email = guest_email
      azt.ip = ip
      azt.area_id = area_id
      azt.method = method
      azt.save

      topic_id = AskZhidaoTopic.find(:first, :select => "id", 
        :conditions => ["subject = ? and area_id = ? and method = ?", subject, area_id, method]).id
      
      user_tags.split(" ").collect{ |s| 
        user_tag = s.gsub(" ", "")
        result = AskUserTag.count ["name = ?", user_tag]
        if result == 0
          aut = AskUserTag.new
          aut.name = user_tag
          aut.save
        end
        
        user_tag_id = AskUserTag.find(:first, :select => "id", 
          :conditions => ["name = ?", user_tag]).id
        
        atut = AskTopicUserTag.new
        atut.user_tag_id = user_tag_id
        atut.topic_id = topic_id
        atut.topic_type_id = topic_type_id
        atut.save
      }
    }
  end
  
  def self.save_company(user_id, tag_id, subject, description, user_tags, 
      guest_email, ip, company_id, area_id=1, method=3, topic_type_id=1)
    transaction() {
      azt = AskZhidaoTopic.new
      azt.user_id = user_id
      azt.tag_id = tag_id
      azt.subject = subject
      azt.description = description
      azt.guest_email = guest_email
      azt.ip = ip
      azt.company_id = company_id
      azt.area_id = area_id
      azt.method = method 
      azt.save
    }
  end
  
  def self.view(zhidao_topic_id)
    AskZhidaoTopic.update_all("view_counter = view_counter + 1", "id = #{zhidao_topic_id}")
  end
  
  def self.best_post(zhidao_topic_id, best_post_id)
    azt = AskZhidaoTopic.find(zhidao_topic_id)
    azt.best_post_id = best_post_id
    azt.save
  end
  
  def self.best_post_for_editor(zhidao_topic_id, best_post_id, editor_id)
    azt = AskZhidaoTopic.find(zhidao_topic_id)
    azt.best_post_id = best_post_id
    azt.editor_id = editor_id
    azt.save
  end
  
  def self.taggable(zhidao_topic_id, tag_id, editor_id)
    azt = AskZhidaoTopic.find(:first, :select => "id, tag_id, editor_id",
      :conditions => ["id = ?", zhidao_topic_id])
    azt.update_attribute("tag_id", tag_id)
    azt.update_attribute("editor_id", editor_id)
  end
  
  def self.delete(zhidao_topic_id, editor_id)
    azt = AskZhidaoTopic.find(zhidao_topic_id)
    azt.is_delete = 1
    azt.editor_id = editor_id
    azt.save
  end
  
  def self.update(user_id, editor_id)
    transaction() {
      azt = AskZhidaoTopic.find(:all, :select => "id, is_delete, editor_id",
        :conditions => ["user_id = ?", user_id])
      0.upto(azt.size-1) do |i| 
        azt[i].is_delete = 1
        azt[i].editor_id = editor_id
        azt[i].save
      end  
    }
  end
  
  def self.piliang_tag(zhidao_topic_id, tag_id, editor_id)
    transaction() {
      azt = AskZhidaoTopic.find(:all, :select => "id, tag_id, editor_id",
        :conditions => ["id = ?", zhidao_topic_id])
      0.upto(azt.size-1) do |i|  
        azt[i].update_attribute("tag_id", tag_id)
        azt[i].update_attribute("editor_id", editor_id)
      end
    }
  end
  
  def self.edit_wenzhang(zhidao_topic_id,subject,created_at,editor_id)
    azt = AskZhidaoTopic.find(:first, :select => "id,subject,created_at,editor_id",
      :conditions => ["id = ?", zhidao_topic_id])
    azt.update_attribute("subject", subject)
    azt.update_attribute("created_at", created_at)
    azt.update_attribute("editor_id", editor_id)
  end
  
  def self.update_is_distribute(zhidao_topic_id)
    topic = AskZhidaoTopic.find(zhidao_topic_id, :select => "id, is_distribute")
    topic.is_distribute = (topic.is_distribute == 0 ? 1 : 0)
    topic.save
    topic.is_distribute
  end

  def post_counter
    read_attribute('post_counter').to_i < 0 ? 0 : read_attribute('post_counter')
  end

end