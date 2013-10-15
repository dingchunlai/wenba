class HejiaTag < Hejia::Db::Hejia
 # self.table_name = "HEJIA_TAG"
  set_table_name "HEJIA_TAG"
  self.primary_key = "TAGID"
#  acts_as_readonlyable [:read_only_51hejia]
  named_scope :published, :conditions => "TAGESTATE >= 0"
  has_many :facyories, :class_name => "CaseFactoryCompany"
  
 
  
  
  def self.search(tag_name)
    results = HejiaTag.find(:first,
      :conditions => ["TAGNAME = ? and TAGFATHERID = 14025 and TAGTYPE = 'newsClass'", tag_name])
    return results
  end
  
  def self.urban_areas father_id
     find(:all, :select => "TAGID, TAGNAME", :conditions => ["TAGFATHERID = ? and TAGESTATE != ?", father_id, -1])
  end
  
  def self.find_name tagid
    tag = find(:first, :select => " TAGNAME", :conditions => ["TAGID = ? ", tagid])
    tag.nil? ? "" : tag.TAGNAME
  end
end
