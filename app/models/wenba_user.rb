class WenbaUser < ActiveRecord::Base
  STATE = [["正常访问","0"],["禁止发言","1"],["禁止访问","2"]]

  belongs_to :user, :class_name => "HejiaUserBbs", :foreign_key => "user_id"

  belongs_to :radmin_user, :class_name => "HejiaStaff", :foreign_key => "radmin_user_id"
end
