class DecoEvent < Hejia::Db::Hejia
  #  acts_as_readonlyable [:read_only_51hejia]
  #include GeoKit::Geocoders
  #acts_as_mappable :auto_geocode => true
  
  has_attached_file :banner,
    :path => ":rails_root/public/decos/:class/:attachment/:id/:basename_:style.:extension",
    :url => "http://image.51hejia.com/decos/:class/:attachment/:id/:basename_:style.:extension",
    :default_url => "/images/missing.gif"
  
  has_and_belongs_to_many :firms, :class_name => "DecoFirm",
    :join_table => "deco_events_firms",
    :foreign_key => "event_id",
    :association_foreign_key => "firm_id"
  has_many :registers, :class_name => "DecoRegister", :foreign_key => "event_id"
  has_many :remarks, :as => :resource, :order => "id DESC"
  has_many :show_remarks, :class_name => "Remark", :foreign_key => "resource_id", :order => "created_at desc",:conditions => "status=1"
  
  def countdown
    if ends_at
      ends_at - Date.today
    else
      "-"
    end
  end
  
  #列表页
  named_scope :coupon_lists,lambda{|city_code, params|
    conditions = []
    condition_params = []
    city_condition = "select id from deco_firms where (city = #{city_code} or district = #{city_code})"
    unless params[:firm_name].blank?
      city_condition << "and deco_firms.name_abbr like ?"
      condition_params << "%#{params[:firm_name]}%"
    end
     unless params[:firm_id_not_in].blank?
        city_condition << "and deco_firms.id not in (?)"
        condition_params << "%#{params[:firm_id_not_in]}%"
      end
    conditions << "deco_events_firms.firm_id in (#{city_condition})"
    unless params[:coupon_title].blank?
      conditions << "deco_events.title like ?"
      condition_params << "%#{params[:coupon_title]}%"
    end
    unless params[:date].blank?
      conditions << "deco_events.created_at > ?"
      case params[:date].to_i
      when 1 #前三天
        condition_params << 3.days.ago.to_s(:db)
      when 2 #前一周
        condition_params << 1.weeks.ago.to_s(:db)
      when 3 #前一个月
        condition_params << 1.month.ago.to_s(:db)
      when 4 #前三个月
        condition_params << 3.month.ago.to_s(:db)
      end
    end
    conditions << "deco_events.ends_at > '#{Time.now.strftime('%Y-%m-%d')}'"
    {
      :select => "deco_events.*",
      :joins => "deco_events join deco_events_firms on deco_events.id = deco_events_firms.event_id",
      :conditions => [conditions.join(' and ')] + condition_params,
      :order => 'deco_events.created_at desc'
    }
  }

  #合作公司优惠券列表

  named_scope :cooperation_coupon_lists, lambda { |city_code,n|
    city_condition = DecoFirm.find(:all,:conditions =>"is_cooperation = 1 and (city = #{city_code} or district = #{city_code})")
    cityids = city_condition.map(&:id)
    {
      :select => "deco_events.*",
      :joins => "deco_events join deco_events_firms on deco_events.id = deco_events_firms.event_id",
      :conditions => ["deco_events.ends_at > '#{Time.now.strftime('%Y-%m-%d')}' and deco_events_firms.firm_id in (?)",cityids],
      :order => 'deco_events.created_at desc',
      :limit =>n
    }
  }
  
  # get now city events_and_firm_info
  def self.promoted_events(city)
    Hejia[:cache].fetch("deco_event/firm_events/praise/#{city}",1.hours) do
      DecoEvent.find(
        :all,
        :select => 'firm.id as firm_id,firm.praise as praise, deco_events.title as title , deco_events.id as event_id, firm.name_abbr as firm_name', 
        :conditions => [
          ([11910,11905,31959,11908,11887].include? city.to_i) ? "deco_events.ends_at > ? and firm.city = ?" : "deco_events.ends_at > ? and firm.district = ?",
          Time.now, city
        ], 
        :joins => "join deco_events_firms as event_firm on deco_events.id = event_firm.event_id join deco_firms as firm on firm.id = event_firm.firm_id",
        :group => "firm.id",
        :order => "firm.is_cooperation desc, deco_events.updated_at desc",
        :limit => 10
      )
    end
  end
  
  def self.getseoevents
    key = "zhaozhuangxiu_seo_events_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result =  find(:all,:select => "title,id,starts_at",:order => "id desc",:limit=>10)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result    
  end
  
  def self.getnewevents(firmid)
    key = "zhaozhuangxiu_seo_events_#{Time.now.strftime('%Y%m%d%H')}_#{firmid}"
    if Hejia[:cache].get(key).nil?
      result = DecoEvent.find_by_sql("select d.*  from deco_events as d,deco_events_firms as l where l.firm_id=#{firmid} and d.id=l.event_id order by d.id desc limit 1")
      Hejia[:cache].set(key,result)
    else
      result = Hejia[:cache].get(key)
    end
    return result
  end
  
  def self.get_index_events
    DecoEvent
    Hejia[:cache].fetch "zhaozhuangxiu_index_events", 5.minutes do
      DecoEvent.find(:all,:order => "id desc",:limit=>6)
    end
  end
  
  def self.latest_events city_id
    firm_ids = DecoFirm.find(:all,:conditions =>["city = ? or district = ?",city_id,city_id],:select => "id").map(&:id)
    self.find(:all,
      :joins => "deco_events join deco_events_firms on deco_events.id = deco_events_firms.event_id",
      :conditions => ["deco_events_firms.firm_id in (?)",firm_ids ],
      :order => 'deco_events.created_at desc',
      :limit => 10
    )
  end
  
  def url
    "http://z.#{self.firms.first.city_pinyin}.51hejia.com/coupons/#{self.id}"
    #"http://z.#{self.firms.first.city_pinyin}.51hejia.com/gs-#{self.firms.first.id}/y-#{self.id}"
  end
  
end
