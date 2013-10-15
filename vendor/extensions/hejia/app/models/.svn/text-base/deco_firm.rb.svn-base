class DecoFirm < Hejia::Db::Hejia
  
  attr_accessor :is_promoted   #判断是否为推荐位公司，默认为false

  # popedom 设置评论权限值 1 不审核 0 需要审核 －1 不许评论
  
  #  has_many :cases, :class_name => "HejiaCase", :foreign_key => "companyid", :order=>"CREATEDATE desc",
  #                   :conditions => " STATUS != '-100' and ISNEWCASE = 1 and ISZHUANGHUANG = '1' "
  has_many :cases, :class_name => "HejiaCase", :foreign_key => "companyid", :order=>"LIST_INDEX desc",
    :conditions => " STATUS != '-100' "
  
  #has_many :photos, :class_name => "DecoPhoto", :foreign_key => "firm_id"
  has_many :photos, :class_name => "DecoPhoto", :as => :entity, :order => "created_at desc"
  has_many :remarks, :as => :resource, :order => "created_at desc"
  has_many :show_remarks, :class_name => "Remark", :foreign_key => "resource_id", :order => "created_at desc",
    :conditions => "(other_id is null or ((select count(*) from decoration_diaries where status = 1 and id = remarks.other_id)>0 )) and status=1"
  has_many :decoration_diaries, :order => "order_time DESC"
  has_many :pictures , :as => :item
  has_many :store_photos
  has_many :glory_certificates #荣誉证书
  has_many :case_factory_company, :class_name => "CaseFactoryCompany", :foreign_key => "COMPANYID"
  #最公司下面最新的4个
  has_many :firm_newest_factories, :class_name => "CaseFactoryCompany", :conditions=> ["ENDENABLE>? or STARTENABLE>?", Time.now, Time.now], :foreign_key => "COMPANYID", :order => "STARTENABLE desc", :limit => 4
  has_many :deco_ideas, :order => "created_at desc"
  has_many :deco_services, :order => "created_at desc"
  has_many :designers, :class_name => "CaseDesigner", :conditions=> "status <> '-100'", :foreign_key => "COMPANY"
  has_many :deco_firms_contacts
  has_many :users, :class_name => "HejiaUserBbs", :foreign_key => "deco_id"
  has_many :applicant_contracts
  after_create  :add_deco_firm_impressions, :add_firm_contacts
  has_and_belongs_to_many :events, :class_name => "DecoEvent",
    :conditions => ["ends_at >= ?", Time.now.to_s(:db)],
    :join_table => "deco_events_firms",
    :foreign_key => "firm_id",
    :association_foreign_key => "event_id",
    :uniq => true,
    :order => "LIST_INDEX"
  
  has_and_belongs_to_many :all_events, :class_name => "DecoEvent",
    :join_table => "deco_events_firms",
    :foreign_key => "firm_id",
    :association_foreign_key => "event_id",
    :uniq => true,
    :order => "LIST_INDEX"

  
                          
  has_and_belongs_to_many :quotations, :class_name => "DecoQuotation",
    :join_table => "deco_firms_quotations",
    :foreign_key => "firm_id",
    :association_foreign_key => "quotation_id",
    :uniq => true
  #has_many :deco_registers, :through => :events, :source => :events
  has_many :branches, :class_name => "DecoFirmBranch"
  belongs_to :user, :class_name => "HejiaUserBbs", :foreign_key => "deco_id"
  belongs_to :sales_man
  has_many :quoted_prices,:order => :position
  has_many :applicants

  has_many :factories, :class_name => "CaseFactoryCompany", :conditions => ["ENDENABLE>? or STARTENABLE>?", Time.now, Time.now] , :foreign_key => "COMPANYID"
  named_scope :by_city,lambda{|city| 
    this_city = if [11910,11905,31959,11908,11887].include? city.to_i
      'city'
    else
      'district'
    end
    {
      :conditions => (city.blank? || city.to_i == 0) ? nil : ["#{this_city} = ?" , city]
    }
  }
  
  #公司按合作和分数排序,可去除某些特定的公司
  named_scope :firms_by_cooperation_praise_for, lambda{|firm_ids, limit|
    firm_ids = firm_ids.blank? ? '' : firm_ids
    {
      :conditions => ["id not in (?) and state <> '-100' and state <> '-99'",firm_ids],
      :order => "is_cooperation desc, praise desc, (select count(*) from  decoration_diaries where deco_firms.id = decoration_diaries.deco_firm_id and decoration_diaries.status = 1 and decoration_diaries.is_verified = 1) desc",
      :limit => limit
    }
  }
  
  named_scope :published, :conditions => "state <> '-100' and state <> '-99'"
  named_scope :is_cooperation, :conditions => "is_cooperation = 1"
  named_scope :is_not_cooperation, :conditions => "is_cooperation = 0"
  
  #公司列表页排序
  # 上海-》点击第一次进来是合作公司随机
  # 点击默认，设计，施工，服务都按口碑分排，合作优先，非合作跟后
  # 若有同分公司，则按认证日记数量高到低排
  
  named_scope :firm_list_order_for ,lambda{ |order, city_code| 
    order_conditions = []
    order_conditions << "is_cooperation desc"
    unless COMPANY_SORT_ORDERS[order.to_i].nil?
      order_conditions << "#{COMPANY_SORT_ORDERS[order.to_i][0]} desc"
    end
    order_conditions << "praise desc"
    order_conditions << "(select count(*) from  decoration_diaries where deco_firms.id = decoration_diaries.deco_firm_id and decoration_diaries.status = 1 and decoration_diaries.is_verified = 1) desc"
    {
      :order => order_conditions.join(' , ')
    }
  }
  
  named_scope :name_like, lambda {|name_zh|
    return {} if name_zh.blank?
    {
      :conditions => ["name_zh like ?","%#{name_zh}%"]
    }
    
  }
  
  #公司列表页
  named_scope :firms_list_for, lambda { |firm_ids,condition_district, city_code |
    conditions = []
    condition_params = []
    if condition_district.to_i == 0
      if city_code.to_i == 11910
        conditions << "city = 11910"
      elsif city_code.to_i == 11905
        conditions << "city = 11905"
      elsif city_code.to_i == 31959
        conditions << "city = 31959"
      elsif city_code.to_i == 11908
        conditions << "city = 11908"
      elsif city_code.to_i == 11887
        conditions << "city = 11887"
      else
        conditions << "district = ?"
        condition_params << city_code
      end
    else
      conditions << "district = ?"
      condition_params << condition_district
    end
    conditions << "id not in (?)"
    condition_params << firm_ids
    {
      :conditions => [conditions.join(' and ')] + condition_params
    }
  }

  named_scope :firms_by_prices_for,lambda{|prices|
    {
      :select => "id,name_abbr, praise, pv_count, remark_only_count",
      :conditions => ["price in (?) ", prices]
    }
  }
  
  #按关键字查询公司
  named_scope :firms_by_keyword_for, lambda{ |keyword| {:conditions => ["name_zh like ? or name_abbr like ?","%#{keyword}%","%#{keyword}%"]}}
  
  #按model或style或price查询公司
  named_scope :firms_by_assort_for, lambda{ |condition_model, condition_style,condition_price|
    conditions = []
    condition_params = []
    if condition_model.to_i != 0
      conditions = ["model = ?"]
      condition_params = [condition_model]
    elsif condition_style.to_i != 0
      conditions = ["style = ?"]
      condition_params = [condition_style]
    elsif condition_price.to_i != 0
      conditions = ["price = ?"]
      condition_params = [condition_price]
    end
    {
      :conditions => [conditions.join(' and ')] + condition_params,
    }
  }

  #合作装修公司数据统计页面
  named_scope :firms_cooperation_data_statistics,lambda { |firm_id,name,city|
    conditions = []

    conditions << "id =#{firm_id}" unless firm_id.blank?
    #conditions << "updated_at >= '#{begintime.to_time.to_s(:db)}'" unless begintime.blank?
    #conditions << "updated_at <= '#{endtime.to_time.to_s(:db)}'" unless endtime.blank?
    conditions << "name_zh like '%%#{name}%%' or name_abbr like '%%#{name}%%'" unless name.blank?
    unless city.blank?
      conditions << (([11910,11905,31959,11908,11887].include? city.to_i) ? "city=#{city}" : "district=#{city}")
    end
    if conditions.size > 1
      {:conditions => [conditions.join(' and ')]}
    elsif conditions.size == 1
      {:conditions =>conditions}
    else
      {:conditions =>nil}
    end
  }

  #地区查询

  def self.just_for_city_query(citynumber = 11910)
    if [11910,11905,31959,11908,11887].include? citynumber.to_i
       "city = ?"
    else
       "district = ?"
    end
  end

  
  # diaries 根据开始时间和结束时间查询数量
  def option_cases_time(start_time = nil, end_time = nil)
    conditions = []
    conditions << ["HEJIA_CASE.LASTMODIFYTIME >= '#{start_time.to_time.to_s(:db)}'"] unless start_time.blank?
    conditions << ["HEJIA_CASE.LASTMODIFYTIME <= '#{end_time.to_time.to_s(:db)}'"] unless end_time.blank?
    if conditions.size > 0
      decoration_diaries.count(:all, :select => "ID", :conditions => (conditions.size > 1 ? conditions.join(' and ') : conditions))
    else
      decoration_diaries.count(:all, :select => "ID")
    end
  end

  #上面  option_cases_time 重新写个
  def option_cases_by_querytime(start_time = nil, end_time = nil)
    conditions = []
    conditions << "HEJIA_CASE.CREATEDATE >= '#{start_time.to_time.to_s(:db)}'" unless start_time.blank?
    conditions << "HEJIA_CASE.LASTMODIFYTIME <= '#{end_time.to_time.tomorrow.to_s(:db)}'" unless end_time.blank?
    if conditions.size == 1
      query_case = conditions.join
    elsif conditions.size > 1
      query_case = [conditions.join(' and ')]
    else
      query_case = nil
    end
    cases.count(:all, :select => "ID", :conditions =>query_case)
  end

  def option_remarks_by_querytime(start_time = nil, end_time = nil)
    conditions = []
    conditions << "remarks.created_at >= '#{start_time.to_time.to_s(:db)}'" unless start_time.blank?
    conditions << "remarks.updated_at <= '#{end_time.to_time.tomorrow.to_s(:db)}'" unless end_time.blank?
    if conditions.size == 1
      query_case = conditions.join
    elsif conditions.size > 1
      query_case = [conditions.join(' and ')]
    else
      query_case = nil
    end
    remarks.count(:all, :select => "id", :conditions =>query_case)
  end

  # case 根据开始时间和结束时间查询数量
  def option_diaries_time(start_time = nil, end_time = nil)
    conditions = []
    conditions << ["decoration_diaries.updated_at >= '#{start_time.to_time.to_s(:db)}'"] unless start_time.blank?
    conditions << ["decoration_diaries.updated_at <= '#{end_time.to_time.to_s(:db)}'"] unless end_time.blank?
    if conditions.size > 0
      cases.count(:all, :select => "id", :conditions => (conditions.size > 1 ? conditions.join(' and ') : conditions))
    else
      cases.count(:all, :select => "id")
    end
  end

  # remark 根据开始时间和结束时间查询数量
  def option_remarks_time(start_time = nil, end_time = nil)
    conditions = []
    conditions << ["remarks.updated_at >= '#{start_time.to_time.to_s(:db)}'"] unless start_time.blank?
    conditions << ["remarks.updated_at <= '#{end_time.to_time.to_s(:db)}'"] unless end_time.blank?
    if conditions.size > 0
      remarks.count(:all, :select => "id", :conditions => (conditions.size > 1 ? conditions.join(' and ') : conditions))
    else
      remarks.count(:all, :select => "id")
    end
  end
 
  def readonly?
    defined?(@readonly) && @readonly == true
  end

  MODELS = {
    1 => '清包',
    2 => '半包',
    3 => '全包',
    4 => '设计工作室',
    5 => '装修监理'
  }

  STYLES = {
    1 => '现代简约',
    2 => '田园风格',
    3 => '欧美式',
    4 => '中式风格',
    5 => '地中海',
    6 => '混搭'
  }

  PRICE = {
    1 => '8万以下',
    2 => '8-15万',
    3 => '15-30万',
    4 => '30万-100万',
    5 => '100万以上'
  }
  
  NINBO_PRICE = {
    1 => '6万以下',
    2 => '6-10万',
    3 => '10-15万',
    4 => '15-30万',
    5 => '30万以上'
  }
  
  ROOM = {
    1 => '小户型',
    2 => '两房',
    3 => '三房',
    4 => '四房',
    5 => '复式',
    6 => '别墅'
  }
  
  PRICE_FOR_ROOM = {
    '小户型' => '8万以下', 
    '两房' => '8-15万' ,
    '三房' => '15-30万',
    '四房' => '15-30万',
    '复式' => '30万-100万'
  }
  
  PRICE_FOR_ROOM_NINBO = {
    '小户型' => '6万以下', 
    '两房' => '6-10万' ,
    '三房' => '10-15万',
    '四房' => '10-15万',
    '复式' => '15-30万'
  }
  
  STAGE = {
    9 => '装修准备',
    1 => '风格设计',
    2 => '隐蔽工程',
    8 => '建材选购',
    3 => '泥瓦工程',
    4 => '木工工程',
    5 => '油漆工程',
    6 => '安装收尾',
    7 => '装修完工'  
  }
  
  # 返回城市编号,因为上海和别的城市的那个字段不是同一个
  def city_number
    #city == 11910 ? city : district
    if [11910,11905,31959,11908,11887].include? city.to_i
      city
    else
      district
    end
  end
  
  # 返回所在城市 汉字
  def city_name
    CITIES[city_number]
  end
  
  #返回所在城市 拼音
  def city_pinyin
    TAGURLS[city_number]
  end
  
  #公司价位
  def price_text
    if [12301, 12117].include?(self.district)
      self.price.nil? ? "暂无" : NINBO_PRICE[self.price]
    else
      self.price.nil? ? "暂无" : PRICE[self.price]
    end
  end
  
  def model_text
    MODELS[self.model]
  end
  
  # 公司的预约数
  def valid_applicants_count
    self.applicants.confirmed.count
  end
  
  # 最近30日预约数
  def latest_30_days_valid_applicants_count
    self.applicants.confirmed.count(:conditions=>["confirm_at >= ?",1.month.ago])
  end
  
  # 用于显示的在线联系
  def qq_text
    if is_cooperation != 1
      city_id = if [11910,11905,31959,11908,11887].include? city.to_i
        city
      else
        district
      end
      case city_id.to_i
      when 12117 ; "QQ: 1466079700"
      when 12301 ; "QQ: 27327132"
      when 12306 ; "QQ: 1317145782"
      when 12118 ; "QQ: 67251543"
      when 11910 ; "QQ: 471953858，1293214783"
      when 12093 ; 'QQ: 2456662078'
      else
        "该商家未提供在线联系"
      end
    else
      if business_hours.blank?
        "该商家未提供在线联系"
      else
        business_hours.gsub(/<.*>/,'').gsub(/，|,/,'<br/>')
      end
    end
  end
  
  #用于显示的联系电话
  def tel_text
    if city == 11910 && is_cooperation != 1
      ["62676666-8030", "62676666-8047"]
    elsif district == 12301 && is_cooperation != 1
      "0574-27673566".to_a
    elsif district == 12118 && is_cooperation != 1
      "0510-82700070".to_a
    elsif district == 12306 && is_cooperation != 1
      "0571--88831082".to_a
    elsif district == 12117 && is_cooperation != 1
      "0512-68703960".to_a
    elsif district == 12093 && is_cooperation != 1
      '027-85515347/85714739'.to_a
    elsif telephone.blank?
      "该商家未提供客服电话".to_a
    else
      telephone.gsub(/<.*>/,'').gsub(/，|,/,'<br/>')
    end
  end
  
  
  def address_text
    self.address2.blank? ? '暂无信息' : self.address2.gsub(/<.*>/,'')
  end
  
  def business_hour_text
    self.business_hours.blank? ? '暂无信息' : self.business_hours.gsub(/<.*>/,'')
  end
  
  
  
  def increase_pv!
    if defined?($redis)
      $redis.incr pv_cache_key
    else
      self.pv_count += 1
      self.class.update_all({:pv_count => pv_count}, :id => id)
    end
  end

  def remarks_count
    read_attribute(:remarks_count).to_i <= 0 ? 0 : read_attribute(:remarks_count).to_i
  end

  def pv_count
    if defined?($redis)
      _pv_count = $redis.get(pv_cache_key).to_i
      if _pv_count < 1
        _pv_count = read_attribute(:pv_count) || 0 if _pv_count < 1
        $redis.set pv_cache_key, _pv_count
      end
      _pv_count
    else
      read_attribute(:pv_count)
    end
  end

  def pv_cache_key
    @pv_cache_key ||= "test_analytic_zhaozhuangxiu_company_about_key_d_#{id}"
  end
  private :pv_cache_key
  
  
  def self.has_many_deco_firm_number
    Hejia[:cache].fetch("deco_firm/has_many_deco_firm_number", 1.hour) do
      DecoFirm.count(:all, :conditions => ["state != -100 and state != -99"])
    end
  end

  
  def firm_list_diary_master_images(limit  = 4)
    decoration_diaries.find(:all,:select => "id,title",:conditions => "status = 1" ,:order => "created_at desc", :limit => limit)
  end

  ## 获得当前城市最新合作前10公司(按照合作时间来排序)
  def self.newten_firms(city,price, limit = 10)
    p_sql = (price.to_i == 0) ? nil : "and price = #{price.to_i}"
    Hejia[:cache].fetch("deco_firm/newten_firms/right/#{city}/price_#{price}",3.hours) do
      DecoFirm.find(
        :all,
        :select => "id,name_zh,name_abbr,star,remark_only_count,praise,price",
        :conditions => ["#{just_for_city_query(city)} and is_cooperation = ? #{p_sql}", city,true],
        :order => "cooperation_time desc",
        :limit => limit
      )
    end
  end

  ## 某日记公司相关日记（该公司其他最新日记）
  def related_diaries(ids, limit = 10)
    decoration_diaries.find(:all,:select => "id,title",:conditions => ["status = 1 and id not in (?)", ids] ,:order => "created_at desc", :limit => limit)
  end

  #点评首页公司top10
  #prices => 价位 (数组),limit=> 条数 ,promoted_for => 是否查推荐位公司,Boole型 ,city_code => 城市代码
  def self.price_top_ten(prices,city_code, promoted_for = false, limit = 10)
    promoted_firms = []
    if promoted_for
      promoteds = PromotedFirm.dianping_home_promoted(city_code, prices).first
      unless promoteds.nil?
        promoted_ids = promoteds.firms_id
        promoted_ids.each do |id| #这样写为了避免:conditions => ["id in (?)" , promoted_ids  ] 时造成的排序错误
          firm = self.find_by_id(id)
          unless firm.nil?
            firm.is_promoted = true
            promoted_firms << firm
          end
        end
      end
    end
    promoted_ids = promoted_ids.blank? ? '' : promoted_ids
    top_limit = limit - promoted_firms.size
    firms_top_ten = DecoFirm.firms_by_cooperation_praise_for(promoted_ids, top_limit).by_city(city_code).firms_by_prices_for(prices)
    promoted_firms + firms_top_ten
  end
  
  # 根据优先级排序
  def self.orderd_firms(firms)
    unorderd_firms = firms.select{|firm| !firm.priority.blank?}
    return firms if unorderd_firms.size <= 1
    show_firms = firms.dup
    orderd_firms = unorderd_firms.sort_by{|firm| firm.priority}
    unorderd_firms.each_with_index do |unorderd_firm,i|
      show_firms[firms.index(unorderd_firm)] = orderd_firms[i]
    end
    show_firms
  end

  def self.getfirm(id)
    Hejia[:cache].fetch("firms/id/#{id}", RAILS_ENV == 'production' ? 1.hour : 1) do
      find_by_id(id,:include=>:pictures)
    end
  end
  
  def self.get_a_cooperation_firm(article_id, city_id)
    cache_id = article_id % 20 + 1
    if city_id == 11910 || city_id == 0
      cond = "city = 11910"
    elsif city_id == 11905
      cond = "city = 11905"
    elsif city_id == 31959
      cond = "city = 31959"
    elsif city_id == 11908
      cond = "city = 11908"
    elsif city_id == 11887
      cond = "city = 11887"
    else
      cond = "district = #{city_id}"
    end
    Hejia[:cache].fetch("api_firm:likes_style_firm:article:#{cache_id}", 5.days) do
      DecoFirm.find(:first,:conditions=>["#{cond} and is_cooperation = 1"],:order=>"rand()",:limit=>1)
    end
  end

  def firm_name
    if self.name_abbr.blank?
      self.name_zh.mb_chars[0,4].to_s
    else
      self.name_abbr.mb_chars[0,6].to_s
    end
  end

  def firm_link
    # "http://z.51hejia.com/gs-#{self.id}"
    "http://z.51hejia.com/#{self.id}/"
  end
  
  def url
    if self.city.to_i == 11910
      # "http://z.shanghai.51hejia.com/gs-#{self.id}"
      "http://z.shanghai.51hejia.com/#{self.id}/"
    elsif self.city.to_i == 11905
      "http://z.beijing.51hejia.com/#{self.id}/"
    elsif self.city.to_i == 31959
      "http://z.guangzhou.51hejia.com/#{self.id}/"
    elsif self.city.to_i == 11908
      "http://z.chongqing.51hejia.com/#{self.id}/"
    elsif self.city.to_i == 11887
      "http://z.tianjin.51hejia.com/#{self.id}/"
    else
      # "http://z.#{TAGURLS[self.district.to_i]}.51hejia.com/gs-#{self.id}"
      "http://z.#{TAGURLS[self.district.to_i]}.51hejia.com/#{self.id}/"
    end
  end

  def add_deco_firm_impressions
    Array.new(FirmImpression.all(FIRM_IMPRESSIONS_KEY)).sort_by {rand} [0,10].each do |impression|
      impression = DecoImpression.new :title => impression, :deco_firm_id => self.id, :number => (1..10).to_a.sort_by {rand}[0]
      impression.save
    end
  end

  def add_firm_contacts
    unless self.telephone.nil? || self.telephone.size < 2
      contact = DecoFirmsContact.new :address => self.address2, :telephone => self.telephone, :is_master => 1, :deco_firm_id => self.id
      contact.save
    end
  end
  
end
