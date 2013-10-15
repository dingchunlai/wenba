class AskWikiContent < ActiveRecord::Base
  def self.save(content_name,tag,editor_id,is_delete=0)
    awc = AskWikiContent.new
    awc.content_name = content_name
    awc.tag = tag
    awc.editor_id = editor_id
    awc.is_delete = is_delete
    awc.save
  end

  def self.modify(content_id,content_name,tag)
    awc = AskWikiContent.find(:first,:conditions=>["is_delete = 0 and id = ?",content_id])
    awc.content_name = content_name
    awc.tag = tag
    awc.save
  end
end
