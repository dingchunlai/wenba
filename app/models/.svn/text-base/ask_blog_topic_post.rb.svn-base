class AskBlogTopicPost < ActiveRecord::Base
  def self.save(blog_topic_id, user_id, guest_email, ip, content)
    transaction() { 
      abtp = AskBlogTopicPost.new
      abtp.blog_topic_id = blog_topic_id
      abtp.user_id = user_id
      abtp.guest_email = guest_email
      abtp.ip = ip
      abtp.content = content
      abtp.save
      
      abt = AskBlogTopic.find(blog_topic_id)
      abt.post_counter = abt.post_counter + 1
      abt.save
    }
  end
  
  def self.delete(blog_topic_post_id)
    transaction() { 
      abtp = AskBlogTopicPost.find(:first, :select => "id, blog_topic_id",
        :conditions => ["id = ?", blog_topic_post_id])
      blog_topic_id = abtp.blog_topic_id
      abtp.destroy
      
      abt = AskBlogTopic.find(blog_topic_id)
      abt.post_counter = abt.post_counter - 1
      abt.save
    }
  end
  
end