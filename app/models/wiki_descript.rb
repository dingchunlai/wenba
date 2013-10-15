class WikiDescript < ActiveRecord::Base
  def self.save(content_id,title,descript,is_del = 0)
    transaction() {
      wd = WikiDescript.new
      wd.content_id = content_id
      wd.title = title
      wd.description = descript
      wd.is_del = is_del
      wd.save
    }
  end
  def self.modify_wiki_descript(wd_id,title,descript)
    transaction(){
      wd = WikiDescript.find(:first, :conditions => ["id = ? and is_del = 0",wd_id])
      wd.title = title
      wd.description = descript
      wd.save
    }
  end
  def self.del_wiki_descript(wd_id,is_del = 1)
    transaction(){
      wd = WikiDescript.find(:first, :conditions => ["id = ? and is_del = 0",wd_id])
      wd.is_del = is_del
      wd.save
    }
  end
end
