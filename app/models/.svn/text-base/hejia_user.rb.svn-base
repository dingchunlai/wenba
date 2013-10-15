class HejiaUser < ActiveRecord::Base

  class << self

    def get_user_by_id(user_id)
      user_id = user_id.to_i
      if user_id > 0
        memkey = "hejia_user_user_by_id_#{user_id}"
        CACHE.fetch(memkey, 20.days) do
          user = HejiaUser.find(:first,:select=>"id,topic_total,topic_last_issue",:conditions=>["user_id = ?", user_id])
          if user.nil?
            ts = BbsTopic.count("id",:conditions => ["user_id = ? and is_delete = 0", user_id])
            ps = AskForumTopicPost.count("id",:conditions => ["user_id = ? and is_delete = 0", user_id])
            user = HejiaUser.create(:user_id => user_id, :topic_total =>ts + ps)
          end
          user
        end
      else
        nil
      end
    end


    def get_a_rand_user_id
      user = HejiaUser.find(:first,:order=>'rand()')
      if user.nil?
        0
      else
        user.user_id
      end
    end

    def get_a_rand_ip
      if RAILS_ENV == 'development'
        min_id = 243000
      else
        min_id = 816200
      end
      post = AskForumTopicPost.find(:first,:select=>'distinct ip',:conditions=>"id>#{min_id} and ip <> '58.246.26.58'",:order=>'rand()')
      if post.nil?
        ''
      else
        post.ip
      end
    end

  end

end
