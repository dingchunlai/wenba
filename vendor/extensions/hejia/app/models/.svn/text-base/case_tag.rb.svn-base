class CaseTag < Hejia::Db::Hejia
  #acts_as_readonlyable [:read_only_51hejia]
  self.table_name = "HEJIA_TAG"
  self.primary_key = "TAGID"
    
  has_and_belongs_to_many :decos,
    :class_name => "CaseDeco",
    :join_table => "HEJIA_TAG_ENTITY_LINK",
    :foreign_key => "TAGID",
    :association_foreign_key => "ENTITYID",
    :conditions =>["LINKTYPE = 'decoimg'"]
=begin
    
    has_and_belongs_to_many :cases,
        :class_name => "HejiaCase",
        :join_table => "HEJIA_TAG_ENTITY_LINK",
        :foreign_key => "TAGID",
        :association_foreign_key => "ENTITYID",
        :conditions =>["LINKTYPE = 'case'"]
=end
    
  # 案例和案例标签多对多
  has_and_belongs_to_many :cases, 
     :class_name => "HejiaCase",
     :join_table => "HEJIA_TAG_ENTITY_LINK",
     :select => "HEJIA_CASE.ID as id",
     :foreign_key => "TAGID",
     :association_foreign_key => "ENTITYID",
     :conditions =>["LINKTYPE = 'case'"],
     :order=>"HEJIA_CASE.CREATEDATE desc",
     :conditions => " HEJIA_CASE.STATUS != '-100'",
     :limit => 10
 

end
