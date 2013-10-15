class AskSearchKeyword < ActiveRecord::Base
  def self.save(keyword, user_id, ip, area_id=1, type_id=1)
    ask = AskSearchKeyword.new
    ask.keyword = keyword
    ask.user_id = user_id
    ask.ip = ip
    ask.area_id = area_id
    ask.type_id = type_id
    ask.save
  end
end