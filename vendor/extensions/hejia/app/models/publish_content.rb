class PublishContent < Hejia::Db::Hejia
  belongs_to :column, :class_name => "PublishColumn", :foreign_key => "publish_column_id"
  has_many :publish_content_keywords
#  acts_as_readonlyable [:read_only_51hejia]
  
  #专题，专访推广
  named_scope :search_theme, lambda{ |column_id|
     {
       :select => "title,url,created_at,publish_column_id",
       :conditions => ["publish_column_id in (?) and is_del = 0",column_id],
       :order => "created_at desc"
     }
  }
  
  def self.modify(id,title,url,description,resume,publish_time,expire_time,order_id,text_style_id,entity_created_at,price_ago,price_now)
    pc = PublishContent.find(:first, :conditions => ["id = ? and is_valid != ?", id, 3])
    if title == ""
      #标题为空
    else
      pc.title = title
      pc.url = url
      pc.description = description
      pc.resume = resume
      pc.publish_time = publish_time
      pc.expire_time = expire_time
      pc.order_id = order_id
      pc.text_style_id = text_style_id
      pc.entity_created_at = entity_created_at
      pc.entity_updated_at = Time.now
      pc.price_ago = price_ago
      pc.price_now = price_now
      pc.save
    end
  end

  def self.delete(id)
    pc = PublishContent.find(:first, :conditions => ["id = ? and is_valid != ?", id, 3])
    pc.is_valid = 3
    pc.save
  end

  def self.publish_index(publish_column_id, index_id, entity_type_id, entity_id,
      title, description, resume, url, image_url, entity_created_at, 
      entity_updated_at, media_type_id, order_id)
    if title == ""
      #标题为空
    else
      pc = PublishContent.new
      pc.publish_column_id = publish_column_id
      pc.index_id = index_id
      pc.entity_type_id = entity_type_id
      pc.entity_id = entity_id
      pc.title = title
      pc.description = description
      pc.resume = resume
      pc.url = url
      pc.image_url = image_url
      pc.publish_time = Time.now
      pc.order_id = order_id
      pc.entity_created_at = entity_created_at
      pc.entity_updated_at = entity_updated_at
      pc.media_type_id = media_type_id
      pc.entity_expired_at = nil
      pc.is_valid = 1
      pc.save
    end
  end

  def self.search_publish_article(keyword, column_id, is_valid)
    results = PublishContent.find(:all,
      :conditions => ["publish_column_id = ? and is_valid = ? and title like '%#{keyword}%'", column_id, is_valid])
    return results
  end
  
end
