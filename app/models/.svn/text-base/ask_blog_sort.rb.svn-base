class AskBlogSort < ActiveRecord::Base
  def self.save(sort_name, sort_description)
    abs = AskBlogSort.new
    abs.sort_name = sort_name
    abs.sort_description = sort_description
    abs.save
  end
  
  def self.modify(sort_id, sort_name, sort_description)
    abs = AskBlogSort.find(:first, :conditions =>["id = ?", sort_id])
    abs.sort_name = sort_name
    abs.sort_description = sort_description
    abs.save
  end 
end
