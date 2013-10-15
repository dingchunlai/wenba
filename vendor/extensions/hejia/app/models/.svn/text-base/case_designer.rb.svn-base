class CaseDesigner < Hejia::Db::Hejia
  # acts_as_readonlyable [:read_only_51hejia]
  self.table_name = "HEJIA_DESIGNERMODEL"
  self.primary_key = "ID"
  belongs_to :company,
    :class_name => "CaseCompany",
    :foreign_key => "COMPANY"
    
  belongs_to :deco_firm,:foreign_key => "COMPANY"
  has_many :deco_idea, :foreign_key => "designer_id"
    
  has_many :cs,
    :class_name=>"Case",
    :foreign_key => "DESIGNERID",
    :conditions =>["STATUS != '-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1' and ISCOMMEND='0'"],
    :order=>"ID DESC"
    
  has_many :cslist,
    :class_name=>"Case",
    :foreign_key => "DESIGNERID",
    :conditions =>["STATUS != '-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1' and ISCOMMEND='0'"],
    :limit=>3,
    :order=>"ID DESC"
   
  #设计费
  DESFEE_MAPPING = {
    "免费" => 1,
    "20-50元/平" => 2,
    "50-80元/平" => 3,
    "80-120元/平" => 4,
    "120-200元/平" => 5,
    "200元以上/平" => 6
  }    
  
  # 从业年限
  DESAGE_MAPPING = {
    "1年" => 1,
    "2-3年" => 2,
    "3-5年" => 3,
    "5-8年" => 4,
    "8年以上" => 5
  }
  # 设计费用
  def desfee_text
    DESFEE_MAPPING.invert[self.DESFEE.to_i]
  end
  

  # 从业年限
  def desage_text
    DESAGE_MAPPING.invert[self.DESAGE.to_i]
  end
  
  def style_text
    self.DESSTYLE.split(/,/).collect{|style| " " + (DecoFirm::STYLES[style.to_i] || style)} if self.DESSTYLE
  end
  
  def url
    if self.COMPANY == 7 || self.COMPANY.nil?
      "http://z.#{self.deco_firm.city_pinyin}.51hejia.com/"
    else
      "http://z.#{self.deco_firm.city_pinyin}.51hejia.com/designers/#{self.ID}"
    end
  end
  
  # 今天偷懒直接贴过来了
  # TODO 公司 和 设计师 应该是 has_many  through 的结构
  # get_firm_case_designer

  def self.firm_case_designer(firm_id,limit = 0,chule = 0)
    limit_text = limit > 0 ? "limit #{limit}"  : ""
    Hejia[:cache].fetch("/firms/firm_case_designer/#{firm_id}/#{limit}", 5.minutes) do

      designers_sql = "select designers.* from HEJIA_DESIGNERMODEL designers, HEJIA_CASE cases "
      designers_sql.concat "where designers.ID <> #{chule} and designers.COMPANY = #{firm_id} and cases.DESIGNERID = designers.ID  and cases.STATUS != '-100' and cases.ISNEWCASE = 1 and cases.ISZHUANGHUANG = '1' and cases.ISCOMMEND = '0' "
      designers_sql.concat "group by designers.ID order by designers.LIST_INDEX desc #{limit_text}"
      CaseDesigner.find_by_sql designers_sql
    end
  end



end


