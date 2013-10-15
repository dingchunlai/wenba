class RuserChannel < ActiveRecord::Base

  def self.get_radmin_user_id_by_parent_tag_id(parent_tag_id)
    return RuserChannel.find(:first,:select=>"ruser_id",:conditions=>["channel_type = 3 and channel_id = ?", parent_tag_id]).ruser_id rescue 0
  end

end