class Url < ActiveRecord::Base
  acts_as_readonlyable [:read_only_51hejia]
  self.table_name = "radmin_urls"

  def self.get_focus_topics(limit)
    kw = "focus_topics"
    rs = CACHE.fetch(kw, 1.hours) do
      Url.find(:all,:select=>"id,title,url",:conditions=>"sort_id=1",:order=>"updated_at desc",:limit=>9) rescue []
    end
    return rs[0..limit-1]
  end
end