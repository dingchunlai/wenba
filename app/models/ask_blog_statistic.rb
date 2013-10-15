class AskBlogStatistic < ActiveRecord::Base
  def self.save(user_id, source_url, visitor_id, visitor_ip)  #浏览计数
    abs = AskBlogStatistic.new
    abs.user_id = user_id
    abs.source_url = source_url
    abs.visitor_id = visitor_id
    abs.visitor_ip = visitor_ip
    abs.save
  end
end