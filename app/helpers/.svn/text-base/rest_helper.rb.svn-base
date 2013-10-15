module RestHelper
   #公司
  def get_link_of_tag_for_company(tag_id) 
    link_of_tag = "/visitor/browse/#{tag_id}.html"
  end
  
  def get_tag_name_by_tag_id(tag_id)
    tag_name = Tag.find(:first, :select => "name", :conditions => ["id = ?", tag_id]).name
    return tag_name
  end
end
