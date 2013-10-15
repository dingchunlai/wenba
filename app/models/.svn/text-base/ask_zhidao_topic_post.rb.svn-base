class AskZhidaoTopicPost < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia]

  PER_PAGE = 50

  def self.memkey_wenba_post(topic_id, page=1)
    "wenba_post_#{topic_id}_#{page}"
  end

  def self.get_posts(topic_id=40853, page=1)  #取得回复列表信息
    posts = lambda do
      cd = "is_delete=0 and zhidao_topic_id = #{topic_id}"
      order = " is_best_post desc, expert desc, id asc"
      AskZhidaoTopicPost.paginate(:all,
        :select=>"id, zhidao_topic_id, user_id, content, created_at,guest_email,ip,guest_name,expert",
        :conditions=>cd,:order=>order,
        :page => page, :per_page => PER_PAGE)
    end
    posts.call
=begin
if page == 1
      memkey = AskZhidaoTopicPost.memkey_wenba_post(topic_id, page)
      CACHE.fetch(memkey, 3.days, &posts)
    else
      posts.call
    end
=end
  end

  def self.save(zhidao_topic_id, user_id, content, guest_name, guest_email, ip, method=3)
    transaction() { 
      aztp = AskZhidaoTopicPost.new
      aztp.zhidao_topic_id = zhidao_topic_id
      aztp.user_id = user_id
      if CommunityUser.is_expert(user_id)
        aztp.expert = 1
      else
        aztp.expert = 0
      end
      aztp.content = content      
      aztp.guest_name = guest_name
      aztp.guest_email = guest_email
      aztp.ip = ip
      aztp.is_delete = -1
      aztp.method = method
      aztp.created_at = Time.now.to_s(:db)
      aztp.save
      
      azt = AskZhidaoTopic.find(zhidao_topic_id)
      azt.post_counter = azt.post_counter + 1
      azt.last_reply_time = Time.now.to_s(:db)
      azt.save
    }
  end
  
  def self.del_post(user_id, editor_id)
    transaction() { 
      aztp = AskZhidaoTopicPost.find(:all, :select => "id, is_delete, editor_id, zhidao_topic_id",
        :conditions => ["user_id = ?", user_id])
      0.upto(aztp.size-1) do |i| 
        aztp[i].is_delete = 1
        aztp[i].editor_id = editor_id
        reduce_post_counter(aztp[i].zhidao_topic_id)
        aztp[i].save
      end
    }
  end
  
  def self.delete_post(zhidao_post_id, editor_id)
    transaction() { 
      aztp = AskZhidaoTopicPost.find(:all,:select =>"id, is_delete, editor_id, zhidao_topic_id",
        :conditions => ["id = ?", zhidao_post_id])
      0.upto(aztp.size-1) do |i|
        aztp[i].is_delete = 1
        aztp[i].editor_id = editor_id
        reduce_post_counter(aztp[i].zhidao_topic_id)
        aztp[i].save        
      end
    }
  end
  
  def self.save1(zhidao_topic_id, user_id, content, guest_email, ip, method=3)
    transaction() { 
      aztp = AskZhidaoTopicPost.new
      aztp.zhidao_topic_id = zhidao_topic_id
      aztp.user_id = user_id
      aztp.content = content
      aztp.guest_email = guest_email
      aztp.ip = ip
      aztp.method = method
      aztp.save
    }
  end
  
  private
  def self.reduce_post_counter(zhidao_topic_id)
    aztp = AskZhidaoTopic.find(:first, :select =>"id, post_counter",
      :conditions => ["id = ?", zhidao_topic_id])
    if aztp.post_counter.to_i > 0
      aztp.post_counter = aztp.post_counter - 1
      aztp.save
    end
  end
  
end