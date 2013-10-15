class AskUserMessage < ActiveRecord::Base
  def self.save(send_user_id, receive_user_id, content, parent_id)
    aum = AskUserMessage.new
    aum.send_user_id = send_user_id
    aum.receive_user_id = receive_user_id
    aum.content = content
    aum.parent_id = parent_id
    aum.state = 1
    aum.save
  end
  
  def self.save_without_parent_id(send_user_id, receive_user_id, content)
    aum = AskUserMessage.new
    aum.send_user_id = send_user_id
    aum.receive_user_id = receive_user_id
    aum.content = content
    aum.state = 1
    aum.save
  end
  
  def self.read(user_message_id, receive_user_id)
    aum = AskUserMessage.find(:first, :select => "id, is_read",
      :conditions => ["id = ? and receive_user_id = ?", user_message_id, receive_user_id])
    if aum.is_read.to_i == 0
      aum.is_read = 1
      aum.save
    else
      #
    end
  end
  
  def self.set_state(type_id, user_message_id, receive_user_id)  #消息状态
    aum = AskUserMessage.find(:first, :select => "id, state",
      :conditions => ["id = ? and receive_user_id = ?", user_message_id, receive_user_id])
    aum.state = 0 if type_id == 0  #0为收件箱
    aum.state = 1 if type_id == 1  #1为发件箱
    aum.state = 2 if type_id == 2  #2为收藏箱
    aum.state = 3 if type_id == 3  #3为垃圾箱
    aum.save
  end
  
end