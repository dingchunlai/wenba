class AskBlogTopic < ActiveRecord::Base
  def self.save(user_id, ip, category_id, subject, description, area_id=1, is_draft=0, is_top=0)
    abt = AskBlogTopic.new
    abt.user_id = user_id
    abt.ip = ip
    abt.category_id = category_id
    abt.subject = subject
    abt.description = description
    abt.area_id = area_id
    abt.is_draft = is_draft
    abt.is_top = is_top
    abt.save
  end
  
  def self.modify(blog_topic_id, user_id, ip, category_id, subject, description, area_id=1, is_draft=0, is_top=0)
    abt = AskBlogTopic.find(:first, :select => "id, ip, category_id, subject, description, area_id, is_draft, is_top",
      :conditions => ["id = ? and user_id = ?", blog_topic_id, user_id])
    abt.ip = ip
    abt.category_id = category_id
    abt.subject = subject
    abt.description = description
    abt.area_id = area_id
    abt.is_draft = is_draft
    abt.is_top = is_top
    abt.save
  end
  
  def self.delete(blog_topic_id, user_id)
    transaction() { 
      abt = AskBlogTopic.find(:first, :select => "id", :conditions => ["id = ? and user_id = ?", blog_topic_id, user_id])
      abt.destroy
      
      abtps = AskBlogTopicPost.find(:all, :select => "id", :conditions => ["blog_topic_id = ? and user_id = ?", blog_topic_id, user_id])
      abtps.each do |abtp|
        abtp.destroy
      end
    }
  end
  
  def self.set_top(type_id, blog_topic_id, user_id)  #取消置/固顶|置顶|固顶
    abt = AskBlogTopic.find(:first, :select => "id, is_top",
      :conditions => ["id = ? and user_id = ?", blog_topic_id, user_id])
    abt.is_top = 0 if type_id == 0  #取消置/固顶
    abt.is_top = 1 if type_id == 1  #置顶
    abt.is_top = 2 if type_id == 2  #固顶
    abt.save
  end

  def self.publish(blog_topic_id, user_id)  #发布草稿
    abt = AskBlogTopic.find(:first, :select => "id, is_draft",
      :conditions => ["id = ? and user_id = ?", blog_topic_id, user_id])
    abt.is_draft = 0
    abt.save
  end
  
  def self.view(blog_topic_id)  #浏览计数
    abt = AskBlogTopic.find(blog_topic_id)
    abt.view_counter = abt.view_counter + 1
    abt.save
  end

end