class AskWikiCatalog < ActiveRecord::Base
  def self.save(content_id,catalog_name,editor_id,is_delete=0)
    awc = AskWikiCatalog.new
    awc.content_id = content_id
    awc.catalog_name = catalog_name
    awc.editor_id = editor_id
    awc.is_delete = is_delete
    awc.save
  end

  def self.modify(catalog_id,catalog_name)
    awc = AskWikiCatalog.find(:first,:conditions=>["id = ? and is_delete = 0",catalog_id])
    awc.catalog_name = catalog_name
    awc.save
  end
end
