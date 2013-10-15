class AskWikiItem < ActiveRecord::Base
  def self.save(title,description,content_id,catalog_id,editor_id,is_delete=0)
    awi = AskWikiItem.new
    awi.title = title
    awi.description = description
    awi.content_id = content_id
    awi.catalog_id = catalog_id
    awi.editor_id = editor_id
    awi.is_delete = is_delete
    awi.save
  end

  def self.modify(item_id,title,description)
    awi = AskWikiItem.find(:first,:conditions=>["id = ? and is_delete = 0",item_id])
    awi.title = title
    awi.description = description
    awi.save
  end
end
