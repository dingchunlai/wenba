class WikiContent < ActiveRecord::Base
  def self.save(wiki_name,contents,tag,is_del = 0,wiki_del = 0)
    transaction() {
      for wiki_content in contents
        wc = WikiContent.new
        wc.name = wiki_name
        wc.wiki_content = wiki_content
        wc.tag = tag
        wc.is_del = is_del
        wc.wiki_del = wiki_del
       wc.save
      end
    }
  end
  def self.modify_wiki_name(old_wn,wiki_name)
    transaction(){
      contents = WikiContent.find(:all,:conditions => ["name = ? and is_del = 0",old_wn])
      for content in contents
        content.name = wiki_name
        content.save
      end
    }
  end
  def self.modify_wiki_content_tag(wc_id,content,tag)
    transaction(){
      wc = WikiContent.find(:first,:conditions => ["id = ? and is_del = 0",wc_id])
      wc.wiki_content = content
      wc.tag = tag
      wc.save
    }
  end
  def self.delete_wiki(wiki_name,wiki_del = 1)
    transaction(){
      contents = WikiContent.find(:all,:conditions => ["name = ? and wiki_del = 0",wiki_name])
      for content in contents
        content.wiki_del = wiki_del
        content.save
      end
    }
  end
  def self.modify_wiki_content(wc_id,content)
    transaction(){
      wc = WikiContent.find(:first,:conditions => ["id = ? and is_del = 0",wc_id])
      wc.wiki_content = content
      wc.save
    }
  end
  def self.delete_wiki_content(wc_id,is_del = 1)
    transaction(){
      content = WikiContent.find(:first,:conditions => ["id = ? and is_del = 0",wc_id])
      content.is_del = is_del
      content.save
    }
  end
end
