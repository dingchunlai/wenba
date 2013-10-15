# encoding: utf-8
class HejiaCase < Hejia::Db::Hejia
  self.table_name = "HEJIA_CASE"
  self.primary_key = "ID"
  # 发布状态的日记
  
  acts_as_list :column => 'LIST_INDEX'
  
  belongs_to :userbbs,
    :class_name => "HejiaUserBbs",
    :foreign_key => "REPORTERID"
  
  belongs_to :ruser,
    :class_name => "User",
    :foreign_key => "REPORTERID"
  
  
  belongs_to :deco_firm, :class_name => "DecoFirm", :foreign_key => "COMPANYID"
  # 兼容radmin
  belongs_to :firm, :class_name => "DecoFirm", :foreign_key => "COMPANYID"
  
  belongs_to :decoration_diary
  
  belongs_to :designer,
    :class_name => "CaseDesigner",
    :foreign_key => "DESIGNERID"
  
  
  has_one :case_detail

  has_and_belongs_to_many :tags, 
    :class_name => "CaseTag",
    :join_table => "HEJIA_TAG_ENTITY_LINK",
    :foreign_key => "ENTITYID",
    :association_foreign_key => "TAGID",
    :conditions =>["LINKTYPE = 'case'"],
    :group =>"HEJIA_TAG.TAGFATHERID"

  has_many :photos, :class_name => "PhotoPhoto", :foreign_key => "case_id", :conditions => "type_id in (3,5)"
  #has_many :photo_tags, :class_name => "PhotoPhotosTag", :foreign_key => "photo_id"


  has_many :remarks, :as => :resource, :order => "created_at desc"
  has_many :show_remarks, :class_name => "Remark", :conditions => "resource_type in ('HejiaCase','Case') and status=1", :foreign_key => "resource_id", :order => "created_at desc"

  # 旧评论
  has_many :comments, :class_name => "Comment",   :foreign_key => "theme_id"
  has_many :deco,   :class_name=>"PhotoPhoto",   :foreign_key => "case_id"
  has_many :material,   :class_name=>"CaseMaterial",   :foreign_key => "CASEID"
  has_many :house,    :class_name=>"CaseHousemodel",    :foreign_key => "CASEID"
  has_many :deco_houses, :foreign_key => "CASEID"
  belongs_to :com,   :class_name=>"CaseCompany",   :foreign_key=>"COMPANYID"
  
 
  def self.housecount(id)
    DecoHouse.count(:id,:conditions=>"CASEID =#{id}")
  end
  
  named_scope :published , :conditions =>"COMPANYID is not null and STATUS <> '-100' and STATUS <> '-50'"
  
  # 传入某个城市ID号的日记
  named_scope :city_num_is, lambda {|city_id| { 
      :conditions => ["(deco_firms.city = ? or deco_firms.district = ?)",city_id,city_id],
      :joins => "join deco_firms on HEJIA_CASE.COMPANYID = deco_firms.id",
      :order => "HEJIA_CASE.CREATEDATE desc"
    }}

  # 这个玩意是啥....
  def self.getCaseIdByBBSID(bbsid)
    case_entity= HejiaCase.find(:first,:select=>"id",:conditions=>[" DESIGNERID=? ",bbsid],:order=>" id desc ")
    unless case_entity.nil?
      case_entity.id
    else
      '#'
    end
  end

  # 从radmin的模型复制过来，看起来不像是个聪明的方法
  def self.get_url(case_id, companyid=0, iszhuanghuang=nil)
    if iszhuanghuang.nil? || companyid == 0
      kw_mc = "hejia_case_url_2_#{case_id}"
      companyid, iszhuanghuang = get_mc(kw_mc) do
        hc = HejiaCase.find(case_id, :select=>"COMPANYID, ISZHUANGHUANG") rescue {}
        [hc["COMPANYID"], hc["ISZHUANGHUANG"]]
      end
    end
    if iszhuanghuang.to_i == 1
      # return "http://z.51hejia.com/gs-#{companyid}/cases-#{case_id}"
      return "http://z.51hejia.com/cases/#{case_id}"
    else
      return "http://tuku.51hejia.com/zhuangxiu/tuku-#{case_id}"
    end
  end
  
  def similar_cases
    cases = Array.new
    cases.concate self.style.cases.find(:all,:select => "HEJIA_CASE.ID as ID,HEJIA_CASE.NAME AS NAME,COMPANYID",:conditions => {:COMPANYID=>self.COMPANYID}) if self.style
    if cases.size == 0
      cases.concat self.deco_firm.cases.find(:all, :limit => 10)
    elsif cases.size > 0 && cases.size < 5
      cases.concat self.deco_firm.cases.find(:all,:conditions => ["ID not in (?)", cases.map(&:ID)],:limit => 10)
    end
  end

  def similar_cases
    cases = Array.new
    cases.concat self.tags.find_by_TAGFATHERID(4348).cases.find(:all,:select => "HEJIA_CASE.ID as ID,HEJIA_CASE.NAME AS NAME,COMPANYID",:conditions => {:COMPANYID=>self.COMPANYID}) if self.tags && self.tags.find_by_TAGFATHERID(4348)
    if cases.size == 0
      cases.concat self.deco_firm.cases.find(:all, :limit => 10)
    elsif cases.size > 0 && cases.size < 5
      cases.concat self.deco_firm.cases.find(:all,:conditions => ["ID not in (?)", cases.map(&:ID)],:limit => 10)
    end
    cases
  end

  #从radmin的模型复制过来
  def self.get_case id
    HejiaCase.find(:first, :conditions =>["ID = ? and STATUS != ?", id, -100])
  end



  # 直接更新数据库肯定不对，写个rake放到redis里面去
  def self.update_view_count(id)
    hejia_case = HejiaCase.find(:first, :conditions => ["ID = ?", id])
    HejiaCase.update_all(" VIEWCOUNT = #{hejia_case.VIEWCOUNT+1} ", :ID => id)
  end

  # 当前案例的终端页地址
  def url
    if self.COMPANYID == 7 || self.COMPANYID.nil?
      "http://tuku.51hejia.com/zhuangxiu/tuku-#{read_attribute('ID')}"
    else
      "http://z.#{self.deco_firm.city_pinyin}.51hejia.com/cases/#{self.ID}"
      #  "http://z.#{self.deco_firm.city_pinyin}.51hejia.com/gs-#{self.COMPANYID}/cases-#{self.ID}"
    end
  end

  # 当前案例的主图
  def master_picture_url
    "http://image.51hejia.com/files/hekea/case_img/tn/#{self.ID}.jpg"
  end


  #和谐 ****** 
  def NAME
    self[:NAME].gsub %r/#{BadWord.all(DECO_CASE_NAME_BAD_WORDS_KEY).map! { |w| Regexp.escape w }.join('|')}/, ''
  end

  def self.gettopnewcase
    key = "zhaozhuangxiu_top_new_case_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = find(:all,:conditions => "STATUS!='-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1'",:order => "ID desc",:limit => 15)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  def self.get_photo_photo(id)
    key = "zhaozhuangxiu_get_photo_photo_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    if CACHE.get(key).nil?
      result = PhotoPhoto.find(:all,:conditions =>"case_id=#{id}")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  def self.get_case_by_id(id)
    key = "key_case_show_casecase_id2_#{Time.now.strftime('%Y%m%d%H')}_#{id}_#{id}"
    if CACHE.get(key).nil?
      result = Case.find(id)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end

  # firm_case 这个是啥。。。。
  
  def self.firm_case firm_id
    CACHE.fetch("/fimrs/firm_case/#{firm_id}", 1.hour) do
      case_sql = "select * from HEJIA_CASE as cases "
      case_sql.concat "where cases.STATUS != '-100' and cases.ISNEWCASE = 1 and cases.ISZHUANGHUANG = '1' and ISCOMMEND = '0' and cases.COMPANYID = #{firm_id} and cases.id = (select case_id from photo_photos as photos where photos.case_id = cases.id limit 1 ) "
      case_sql.concat " order by cases.LIST_INDEX desc"
      Case.find_by_sql case_sql
    end
  end

  #留言分页
  def self.case_remarks_paginator(case_id,page)
    self.get_case_by_id(case_id).remarks.paginate :page => page ,
      :per_page => 5,
      :order => "created_at desc"
  end
  
  def style
    self.tags.find_by_TAGFATHERID(4348)
  end

  def pv_cache_key
    @pv_cache_key ||= "deco_cases/#{id}/viewcount"
  end
  private :pv_cache_key

  def increase_pv!
    if defined?($redis)
      $redis.incr pv_cache_key
      self.week_pv += 1
      self.class.update_all({:week_pv => week_pv}, :ID => id)
    else
      self.VIEWCOUNT += 1
      self.week_pv += 1
      self.class.update_all({:VIEWCOUNT => VIEWCOUNT, :week_pv => week_pv}, :ID => id)
    end
  end

  #手动修改PV
  def pv=(new_pv)
    if defined?($redis)
      $redis[pv_cache_key] = new_pv
    else
      write_attribute :VIEWCOUNT, new_pv
    end
  end

  def pv
    if defined?($redis)
      _pv = $redis.get(pv_cache_key).to_i
      if _pv < 1
        _pv = read_attribute(:VIEWCOUNT) || 0 if _pv < 1
        $redis.set pv_cache_key, _pv
      end
      _pv
    else
      read_attribute(:VIEWCOUNT)
    end
  end

  ## 装修案例Top10：调用规则为一周点击量最高的案例
  def self.top_cases(city, limit = 10)
    Hejia[:cache].fetch("hejia_case/top_cases/#{city}",3.hours) do
    self.published.find(
      :all,
      :joins => "inner join deco_firms as df on df.id = HEJIA_CASE.COMPANYID",
      :conditions => ["df.is_cooperation = 1 and (df.city = ? or df.district = ?)", city, city],
      :order => 'week_pv_count DESC',
      :limit => limit
    )
    end
  end
  
end
