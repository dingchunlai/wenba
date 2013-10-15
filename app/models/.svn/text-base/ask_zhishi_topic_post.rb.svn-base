class AskZhishiTopicPost < ActiveRecord::Base
  def self.save(zhishi_topic_id, user_id, content, guest_email, ip, method=3)
    transaction() { 
      aztp = AskZhishiTopicPost.new
      aztp.zhishi_topic_id = zhishi_topic_id
      aztp.user_id = user_id
      aztp.content = content
      aztp.guest_email = guest_email
      aztp.ip = ip
      aztp.method = method
      aztp.save
      
      azt = AskZhishiTopic.find(zhishi_topic_id)
      azt.post_counter = azt.post_counter + 1
      azt.save
    }
  end
  
end
