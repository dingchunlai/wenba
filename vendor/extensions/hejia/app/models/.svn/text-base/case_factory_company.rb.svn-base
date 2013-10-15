class CaseFactoryCompany < Hejia::Db::Hejia
  #acts_as_readonlyable [:read_only_51hejia]
  self.table_name = "HEJIA_FACTORY_COMPANY"
  self.primary_key = "ID"
  
  belongs_to :deco_firm,:class_name => "DecoFirm",:foreign_key => "COMPANYID"
  
  belongs_to :tagc,
    :class_name => "HejiaTag",
    :foreign_key => "PROVINCE2"
  
  named_scope :published , :conditions => ["ENDENABLE>? or STARTENABLE>?", Time.now, Time.now]
  named_scope :with_city, lambda {|city| 
    {
      :joins => 'join deco_firms on HEJIA_FACTORY_COMPANY.COMPANYID = deco_firms.id',
      :select => "HEJIA_FACTORY_COMPANY.*",
      :conditions => ["(HEJIA_FACTORY_COMPANY.ENDENABLE>? or HEJIA_FACTORY_COMPANY.STARTENABLE>?) and (deco_firms.city=? or deco_firms.district=?) and deco_firms.is_cooperation = 1", Time.now, Time.now, city, city],
      :order => "HEJIA_FACTORY_COMPANY.ID DESC"
    }
  }
  
  
  
  def self.getseoworksites
    key = "zhaozhuangxiu_worksites_index_seo_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result = find(:all,:conditions => "ENDENABLE > #{Time.now.strftime('%Y-%m-%d')}",:group => "COMPANYID", :limit => 10, :order => "id desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end  
  
  def self.get_company_worksites(id)
    key = "zhaozhuangxiu_worksites_company_detail_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    if CACHE.get(key).nil?
      result = find(:all,:conditions => "COMPANYID = #{id}",:limit => 5,:order => 'id desc',:include => 'tagc')
      if !result || result.size ==0
        result = []
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  def self.latest_factories city_id,limit = 10
    deco_firm_ids  = DecoFirm.find(:all,:conditions =>["city = ? or district = ?",city_id,city_id],:select => "id").map(&:id)
    self.published.find(:all,:order =>"STARTENABLE desc",:limit => limit,:group=>"COMPANYID",:conditions => ["COMPANYID in (?)",deco_firm_ids])
    
    
  end
  
end
