class AskZhishiTopic < ActiveRecord::Base
  def self.save(user_id, tag_id, subject, description, user_tags, reference, guest_email, ip, area_id=1, method=3, topic_type_id=2)
    transaction() {
      azt = AskZhishiTopic.new
      azt.user_id = user_id
      azt.tag_id = tag_id
      azt.subject = subject
      azt.description = description
      azt.reference = reference
      azt.guest_email = guest_email
      azt.ip = ip
      azt.area_id = area_id
      azt.method = method
      azt.save

      topic_id = AskZhishiTopic.find(:first, :select => "id", 
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
  
  def self.view(zhishi_topic_id)
    azt = AskZhishiTopic.find(zhishi_topic_id)
    azt.view_counter = azt.view_counter + 1
    azt.save
  end
  
end
