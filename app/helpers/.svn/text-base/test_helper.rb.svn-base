module TestHelper
  def get_tag_name_by_tag_id(tag_id)
    #    tag_name = Tag.find(:first, :select => "name", :conditions => ["id = ?", tag_id]).name
    tag_name = Tag.get_cache(tag_id).name
    return tag_name
  end
end
