# encoding: urf-8
# 为了兼容RADMIN，被和谐成这样了
# 因为Radmin里面已经定义过HejiaUserBbs了。


model_defined = false

user_model_file = File.join(RAILS_ROOT, 'app/models/hejia_user_bbs.rb')
if File.exists?(user_model_file)
  require_or_load user_model_file
  model_defined = true
end

unless model_defined
  class HejiaUserBbs < Hejia::Db::Hejia
    set_table_name 'HEJIA_USER_BBS'
    set_primary_key 'USERBBSID'
  end
end
