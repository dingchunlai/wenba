# == Schema Information
#
# Table name: HEJIA_TAG_ENTITY_LINK
#
#  ID              :integer(19)     not null, primary key
#  CREATEDATE      :datetime
#  ENTITYID        :integer(19)     not null
#  PRICE           :decimal(20, 5)
#  PRIORITY        :string(510)
#  TAGID           :integer(19)     not null
#  STATUS          :integer(10)     default(1)
#  LINKTYPE        :string(255)
#  STATE           :integer(11)
#  FOREORDAINPRICE :decimal(19, 2)
#

class HejiaTagEntityLink < Hejia::Db::Hejia
  self.table_name = "HEJIA_TAG_ENTITY_LINK"
  self.primary_key = "ID"
  #  acts_as_readonlyable [:read_only_51hejia]

  def self.query(tag_ids)
    tag_ids_string = tag_ids.join(",")
    count_num = tag_ids.size
    sql = "select * from HEJIA_TAG_ENTITY_LINK where" +
      " TAGID in (#{tag_ids_string}) group by ENTITYID having count(ID) >= #{count_num}"
    results = HejiaTagEntityLink.find_by_sql(sql)
    entity_ids = []
    results.each do |result|
      entity_ids << result.ENTITYID
    end
    return entity_ids
  end

  def self.query_entity_id_by_tag_id_linktype(tag_id, linktype)
    links = HejiaTagEntityLink.find(:all,
      :select => "distinct ENTITYID",
      :conditions => {"TAGID" => tag_id, "LINKTYPE" => linktype})
    entity_ids = []
    links.each do |result|
      entity_ids << result.ENTITYID
    end
    return entity_ids
  end
  def self.query_entity_id_by_tag_id_linktype_last_5(tag_id, linktype)
    links = HejiaTagEntityLink.find(:all, :select => "distinct ENTITYID",
      :conditions => {"TAGID" => tag_id, "LINKTYPE" => linktype},
      :order => "ENTITYID DESC", :limit => 5)
    entity_ids = []
    links.each do |result|
      entity_ids << result.ENTITYID
    end
    return entity_ids
  end
end
