class AskEditorChoice < ActiveRecord::Base
  def self.save(title, url, order_number,editor_id, topic_id, area_id=1, is_valid=1, topic_type_id=3, type_id =0)
    transaction() {
      azt = AskEditorChoice.new
      azt.title = title
      azt.editor_id = editor_id
      azt.url = url
      azt.order_number = order_number
      azt.topic_id = topic_id
      azt.area_id = area_id
      azt.is_valid = is_valid
      azt.topic_type_id = topic_type_id
      azt.type_id = type_id
      azt.save
    }    
  end
  
  def self.edit(id,title,url,order_number)
    azt = AskEditorChoice.find(:first, :select => "id,title,url,order_number",
      :conditions => ["id = ?",id ])
    azt.update_attribute("id", id)
    azt.update_attribute("title", title)
    azt.update_attribute("url", url)
    azt.update_attribute("order_number", order_number)
  end
  
end