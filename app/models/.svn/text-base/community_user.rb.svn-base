class CommunityUser < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia]

  belongs_to :member, :class_name => "HejiaUserBbs", :foreign_key => "hejia_user_id"

  def self.init_user(user_id)  #创建并初始化社区用户记录
    user_id = user_id.to_i
    if user_id == 0
      rv = "参数不正确!"
    else
      member = HejiaUserBbs.find_by_USERBBSID(user_id)
      if member.nil?
        rv = "无此用户记录!"
        begin
          user = self.new
          user.user_id = user_id
          user.username = "和家历史用户"
          user.ask_expert = 0
          user.wenba_question_num = 0
          user.wenba_answer_num = 0
          user.is_init = 1
          user.save
          rv = user
        rescue Exception => e
          rv = e
        end
      else
        begin
          user = self.new
          user.user_id = user_id
          user.username = member.USERNAME
          user.ask_expert = member.ask_expert
          user.wenba_question_num = AskZhidaoTopic.count("id",:conditions=>"user_id = #{user_id} and is_delete = 0")
          user.wenba_answer_num = AskZhidaoTopicPost.count("id",:conditions=>"user_id = #{user_id} and is_delete = 0")
          user.is_init = 1
          user.save
          rv = user
        rescue Exception => e
          rv = e
        end
      end
    end
    
    return rv
    #user_id,username,bbs_topic_num,wenba_question_num,wenba_answer_num,wenba_best_answer_num,point
  end

  def self.get_question_num(user_id) #取得用户提问数
    user = self.find_by_user_id(user_id)
    if user.nil?
      user = self.init_user(user_id)
      if user.type != CommunityUser
        return 0
      end
    end
    return user.wenba_question_num
  end

  def self.get_answer_num(user_id) #取得用户答题数
    user = self.find_by_user_id(user_id)
    if user.nil?
      user = self.init_user(user_id)
      if user.type != CommunityUser
        return 0
      end
    end
    return user.wenba_answer_num
  end

  def self.set_question_num(user_id, num) #修改或重新统计用户提问数
    user = self.find_by_user_id(user_id)
    if user.nil?
      user = self.init_user(user_id)
      if user.type != CommunityUser
        return false
      end
    end
    num = num.to_i
    if num == 0
      user.wenba_question_num = AskZhidaoTopic.count("id",:conditions=>"user_id = #{user_id} and is_delete = 0")
    else
      user.wenba_question_num = (user.wenba_question_num + num)
    end
    user.save
    return true
  end

  def self.set_answer_num(user_id, num) #修改或重新统计用户答题数
    user = self.find_by_user_id(user_id)
    if user.nil?
      user = self.init_user(user_id)
      if user.type != CommunityUser
        return false
      end
    end
    num = num.to_i
    if num == 0
      user.wenba_answer_num = AskZhidaoTopicPost.count("id",:conditions=>"user_id = #{user_id} and is_delete = 0")
    else
      user.wenba_answer_num = (user.wenba_answer_num + num)
    end
    user.save
    return true
  end


  def self.get_username(user_id) #取得用户名
    user_id = user_id.to_i
    if user_id == 0
      return "匿名用户"
    else
      user = self.find_by_user_id(user_id,:select=>"id, username")
      if user.nil?
        user = self.init_user(user_id)
        if user.type != CommunityUser
          return "未知用户"
        end
      end
      return user.username
    end
  end

  def self.get_user_id(username) #取得用户ID
    user = self.find_by_username(username,:select=>"id,user_id")
    if user.nil?
      user_id = HejiaUserBbs.find_by_USERNAME(username,:select=>"USERBBSID").USERBBSID rescue 0
      user = self.init_user(user_id) if user_id != 0
    end
    return user.user_id.to_i rescue 0
  end

  def self.get_point(user_id) #取得用户积分
    CACHE.fetch("wenbo_model_memkey_user_point_#{user_id}", 1.days) do
      user = self.find_by_user_id(user_id,:select=>"id, point")
      if user.nil?
        user = self.init_user(user_id)
        if user.type != CommunityUser
          return 0
        end
      end
      user.point
    end
  end
  
  def self.set_point(user_id, score) #设置用户积分
    user = self.find_by_user_id(user_id,:select=>"id, point")
    if user.nil?
      user = self.init_user(user_id)
      if user.type != CommunityUser
        return 0
      end
    end
    point = (user.point.to_i + score.to_i)
    point = 0 if point < 0
    user.point = point
    user.save
    CACHE.delete("wenba_model_memkey_user_point_#{user_id}")
    user.point
  end

  def self.is_expert(user_id) #判断用户是否是庄家
    user = self.find_by_user_id(user_id,:select=>"id, ask_expert")
    if user.nil?
      user = self.init_user(user_id)
      if user.type != CommunityUser
        return false
      end
    end
    if user.ask_expert.to_i > 0
      return true
    else
      return false
    end
  end



end
