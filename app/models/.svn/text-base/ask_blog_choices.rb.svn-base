class AskBlogChoices < ActiveRecord::Base
  def self.save(sort_id, user_id, topic_id, title, url, image_title, image_url, order_number, editor_id,is_valid=1, topic_type_id=4)
    abc = AskBlogChoices.new
    abc.sort_id = sort_id
    abc.user_id = user_id
    abc.topic_id = topic_id
    abc.title = title
    abc.url = url
    abc.image_title = image_title
    abc.image_url = image_url
    abc.order_number = order_number
    abc.editor_id = editor_id
    abc.is_valid = is_valid
    abc.topic_type_id = topic_type_id  
    abc.save
  end
  
  def self.modify(cid,image_title,image_url,order_number,editor_id,is_valid=2)
    abc = AskBlogChoices.find(cid)
    abc.image_title = image_title
    abc.image_url = image_url
    abc.order_number = order_number
    abc.editor_id = editor_id
    abc.is_valid = is_valid
    abc.save
  end
  
end
