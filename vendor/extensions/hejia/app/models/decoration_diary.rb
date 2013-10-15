class DecorationDiary < Hejia::Db::Hejia

  include Hejia::FixTimestampZone

  serialize :tags, Array
  belongs_to :user, :foreign_key => "user_id", :class_name => "HejiaUserBbs"
  has_many :remarks, :as => :resource
  has_one :remark , :class_name => 'Remark',:foreign_key => "other_id"
  has_many :pictures , :as => :item

  has_many :decoration_diary_posts, :order =>'updated_at desc', :dependent => :destroy

  #下面的这个日记posts用于显示在前台的审核过的posts
  has_many :verified_diary_posts, :class_name => "DecorationDiaryPost", :conditions => "state = 1", :foreign_key => "decoration_diary_id", :order =>'id DESC'
  #未审
  has_many :unverified_diary_posts, :class_name => "DecorationDiaryPost", :conditions => "state = 0", :foreign_key => "decoration_diary_id", :order =>'id DESC'
  has_many :res, :class_name => "re", :foreign_key => "reference_id"
  
  has_one :hejia_case
  belongs_to :deco_firm 
  validates_presence_of :title, :room, :price, :model, :style, :user_id, :deco_firm_id, :status

  after_destroy :destroy_after
  after_save :clean_cache
  after_save :update_tags
  before_create :set_default_value

  attr_accessor :need_update_tags

  [:title, :content].each do |attr|
    class_eval <<_CODE_
    def #{attr}=(value)
      self.need_update_tags = true
      write_attribute(#{attr.inspect}, value)
    end
_CODE_
  end

  # 发布状态的日记
  named_scope :published , :conditions => {:status => 1 }
  named_scope :verified, :conditions=>"is_verified = 1 and created_at >= '2010-5-29'"
  named_scope :is_good,  :conditions => {:is_good => 1 }
  named_scope :praised, :conditions => "praise > 0"


  def self.just_for_city_query(citynumber = 11910,pre = 'deco_firms')
    if [11910,11905,31959,11908,11887].include? citynumber.to_i
       "#{pre}.city = ?"
    else
       "#{pre}.district = ?"
    end
  end

  # 传入某个城市ID号的日记
  named_scope :city_num_is, lambda {|city_id| {
      :conditions => ["(#{just_for_city_query(city_id)})",city_id],
      :joins => "join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id",
      :order => "decoration_diaries.created_at desc"
    }}

  named_scope :city_num_for, lambda {|city_id| {
      :select =>'decoration_diaries.id,decoration_diaries.title,decoration_diaries.pv',
      :conditions => ["(#{just_for_city_query(city_id)} and decoration_diaries.is_verified = 1 and decoration_diaries.created_at >= '2010-5-29')", city_id],
      :joins => "join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id",
      :order => 'decoration_diaries.pv desc',
      :limit => 10
    }}

  named_scope :keywords_include, lambda{|keyword|
    return {} if keyword.blank?
    sql = "select distinct(b.entity_id) as entity_id from 51hejia_index.hejia_index_keywords a join 51hejia_index.relations b on a.id = b.keyword_id where b.from_type = 7 and a.name like '%#{keyword}%'"
    ids = Relation.find_by_sql(sql).map(&:entity_id)
    { :conditions => ["decoration_diaries.id in (?)",ids] }
  }

  #达人争霸赛榜单
  named_scope :daren, lambda{ |is_shanghai|
    #改为统计所有城市
    # is_shanghai = true if  is_shanghai.blank?
    #city_conditions = is_shanghai ? "deco_firms.city = 11910" : "deco_firms.city != 11910"
    #20111014改为去掉统计上海的
    is_shanghai ? (city_conditions = nil) : city_conditions = 'deco_firms.city != 11910'
    {
      :select => "decoration_diaries.id, decoration_diaries.user_id, decoration_diaries.title, decoration_diaries.votes_current_month, decoration_diaries.order_time",
      :joins => "join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id",
      :conditions => city_conditions,
      :order => "decoration_diaries.votes_current_month desc",
      :limit => 10
    }
  }

  named_scope :room_is, lambda{|room|
    return {} if room.blank?
    { :conditions => ["decoration_diaries.ROOM = ?",room] }
  }

  named_scope :price_is, lambda{|price_id|
    return {} if price_id.blank?
    { :conditions => ["decoration_diaries.PRICE = ?",price_id]}
  }

  named_scope :style_is, lambda{|style|
    return {} if style.blank?
    { :conditions => ["decoration_diaries.STYLE = ?",style] }
  }

  named_scope :verified_is,lambda{|verified|
    return {} if verified.blank?
    { :conditions => ["decoration_diaries.is_verified = ?",verified] }
  }

  named_scope :keyword_is,lambda{|keyword|
    return {} if keyword.blank?
    { :conditions => ["decoration_diaries.title like '%?%'", keyword] }
  }
  #日记列表排序
  named_scope :diaries_list,lambda{|city_code|
    {
      :select => "decoration_diaries.*",
      :joins => "join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id",
      :conditions => ["(#{just_for_city_query(city_code)}) and decoration_diaries.status = 1",city_code],
      :order => "decoration_diaries.order_time desc"
    }
  }

  named_scope :yesterday_remark_count_for, lambda{ |city_code, limit|{
      :joins => "join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id",
      :conditions => ["(#{just_for_city_query(city_code)}) and decoration_diaries.yesterday_remarks > 0",city_code],
      :order => "decoration_diaries.yesterday_remarks desc",
      :limit => limit
    }}

  named_scope :get_diaries_by_time,lambda { |starttime,endtime|
    conditions = []
    conditions << "updated_at >= '#{starttime.to_time.to_s(:db)}'" unless starttime.blank?
    conditions << "updated_at <= '#{endtime.to_time.tomorrow.to_s(:db)}'" unless endtime.blank?
    if conditions.size == 1
      {:conditions =>conditions}
    elsif conditions.size > 1
      {:conditions =>[conditions.join(' and ')]}
    else
      {:conditions =>nil}
    end
  }


  # ------------------ named_scope 全部定义到此上 ----------------------

  # 2010-11改版后，日记自己没有内容了，但是有的view没有改过来，造成了显示的问题。这里提供一个兼容的方法。
  def content
    first_post = decoration_diary_posts.find(:first)
    first_post && first_post.body || ''
  end

  # 获得日记前台的URL ,preview
  def url(preview=false)
    DecorationDiary
    k = preview == :preview ? "/generate/decoration_diaries/diary_url/#{id}" : "/generate/decoration_diaries/diary_url/#{id}/preview"
    Hejia[:cache].fetch(k, RAILS_ENV != 'production' ? 1 : 1.month) do
      preview_param = "?preview=true" if preview == :preview
      begin
        diary = DecorationDiary.find_by_id id
        firm = diary.deco_firm
        "http://z.#{firm.city_pinyin}.51hejia.com/stories/#{diary.id}#{preview_param}"
        #"http://z.#{firm.city_pinyin}.51hejia.com/gs-#{firm.id}/zhuangxiugushi/#{diary.id}#{preview_param}"
      rescue
        "http://z.51hejia.com"
      end
    end
  end

  #从brands的模型复制而来
  def self.latest_ten_diaries_for_brand(brand)
    if (brand_items = API_PROMOTION_MAPPING['品牌'][brand.permalink]) &&
        (api_id = brand_items['装修日记'])
      Hejia::Promotion.items api_id, :limit => 10
    else
      find :all,
        :select => 'decoration_diaries.id, decoration_diaries.deco_firm_id, decoration_diaries.title',
        :joins  => 'join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id',
        :conditions => 'decoration_diaries.status = 1 AND deco_firms.city = 11910',
        :order => 'decoration_diaries.created_at desc',
        :limit => 10
    end
  end


  def master_picture(size="")
    Picture
    Hejia[:cache].fetch "decoration_diaries:#{self.id}:master_picture", RAILS_ENV != 'production' ? 0 : 5.minutes do
      picture = Picture.find(:first, :conditions => "is_master=1 and item_type='DecorationDiaryPost' and item_id in (#{self.decoration_diary_posts.size > 0 ? self.decoration_diary_posts.map(&:id).join(',') : 'null'})")
      picture = Picture.find(:first, :conditions => "item_type='DecorationDiaryPost' and item_id in (#{self.decoration_diary_posts.size > 0 ? self.decoration_diary_posts.map(&:id).join(',') : 'null'})", :order=>"created_at desc") if picture.nil?
      picture.nil? ? Picture.new(:image_url => "http://www.51hejia.com/api/images/none.gif") : picture
    end
  end



  def attach_pictures
    attach_pictures = Picture.find(:all, :conditions => "is_master=0 and item_type='DecorationDiaryPost' and item_id in ('#{self.decoration_diary_posts.map(&:id).join(',')}')")
  end


  def clean_cache
    Hejia[:cache].delete("decoration_diaries/#{self.id}")
  end
  private :clean_cache

  def update_tags
    self.title = self.title
    if need_update_tags
      Decoration::MigrationDecorationDiary.run! self.id
    end
  end
  private :update_tags

  def destroy_after
    Hejia[:cache].delete("decoration_diaries/#{self.id}")
    Decoration::MigrationDecorationDiary.delete_diary self.id
  end

  # 是否已经认证
  def verified?
    is_verified == 1
  end

  def self.getNote(id)
    id.strip! if id.respond_to?(:strip!)
    Hejia[:cache].fetch("decoration_diary/#{id}", RAILS_ENV == 'production' ? 1.hour : 1) do
      find_by_id id
    end
  end

  # 取得某城市下的6条不同装修公司的日记 各拿一篇
  # 具体拿出字段有 日记编号，公司编号，日记标题，公司名称，公司简称，写日记用户编号
  def self.firm_diaries(city, limit = 6)
    max_limit = 10
    fail "limit参数最大不能超过#{max_limit}" if limit > max_limit
    city = TAGURLS.index(city) if city.to_i == 0
    diaries = Hejia[:cache].fetch("diaries/top6_20100611/#{city}/#{max_limit}", 1.hour) do
      sql = "SELECT diary.id as diary_id, user.USERNAME as username, diary.title as diary_title, diary.user_id as diary_user_id, firm.id as firm_id, firm.name_zh as firm_name_zh, firm.name_abbr as firm_name_abbr, firm.star as firm_star FROM decoration_diaries as diary "
      sql.concat "JOIN deco_firms as firm ON firm.id = diary.deco_firm_id "
      sql.concat "JOIN HEJIA_USER_BBS as user ON diary.user_id = user.USERBBSID "
      if city.to_i == 0
        sql.concat "WHERE diary.status = 1 and diary.is_verified = 1 "
      elsif city.to_i == 11910
        sql.concat "WHERE (firm.city = #{city} and diary.status = 1 and diary.is_verified = 1) "
      elsif city.to_i == 11905
        sql.concat "WHERE (firm.city = #{city} and diary.status = 1 and diary.is_verified = 1) "
      elsif city.to_i == 31959
        sql.concat "WHERE (firm.city = #{city} and diary.status = 1 and diary.is_verified = 1) "
      elsif city.to_i == 11908
        sql.concat "WHERE (firm.city = #{city} and diary.status = 1 and diary.is_verified = 1) "
      elsif city.to_i == 11887
        sql.concat "WHERE (firm.city = #{city} and diary.status = 1 and diary.is_verified = 1) "
      else
        sql.concat "WHERE (firm.district = #{city} and diary.status = 1 and diary.is_verified = 1) "
      end
      sql.concat "GROUP BY diary.deco_firm_id "
      sql.concat "ORDER BY firm.is_cooperation desc, diary.created_at desc "
      sql.concat "LIMIT #{max_limit}"
      DecorationDiary.find_by_sql(sql)
    end
    diaries[0...limit]
  end

  def self.verified_from_now_on
    self.find(:all,:conditions=>"status = 1 and created_at <= '#{6.months.ago}'")
  end

  def pv_cache_key
    @pv_cache_key ||= "decoration_diaries/#{id}/pv"
  end
  private :pv_cache_key

  # 给日记缓存加PV
  def increase_pv!
    if defined?($redis)
      $redis.incr pv_cache_key
      self.week_pv += 1
      self.class.update_all({:week_pv => week_pv}, :ID => id)
    else
      self.pv += 1
      self.week_pv += 1
      self.class.update_all({:pv => pv, :week_pv => week_pv}, :id => id)
    end
  end

  #手动修改日记缓存
  def pv=(new_pv)
    if defined?($redis)
      $redis[pv_cache_key] = new_pv
    else
      write_attribute :pv, new_pv
    end
  end

  def pv
    if defined?($redis)
      _pv = $redis.get(pv_cache_key).to_i
      if _pv < 1
        _pv = read_attribute(:pv) || 0 if _pv < 1
        $redis.set pv_cache_key, _pv
      end
      _pv
    else
      read_attribute(:pv)
    end
  end

  def set_default_value
    self.status = 0
  end
  def id
    if read_attribute('id').nil?
      read_attribute('diary_id')
    else
      read_attribute('id')
    end
  end

  def title
    if read_attribute('title').nil?
      read_attribute('diary_title')
    else
      read_attribute('title')
    end
  end

  def user_name
    self.user ? self.user.USERNAME : '和家网友'
  end

  #得到日记留言 分页
  def self.remarks_page_paginate (diary_id,page)
    self.getNote(diary_id).remarks.paginate :page => page,
      :per_page => 5,
      :order => "created_at desc"
    #     end
  end

  #  缓存日记留言，：只缓存第一页的留言
  def self.remarks_paginate(diary_id,page)
    if page == 1
      Remark
      Hejia[:cache].fetch("remarks_paginate/remark/#{diary_id}",2.minutes) do
        self.remarks_page_paginate(diary_id,page)
      end
    else
      self.remarks_page_paginate(diary_id,page)
    end
  end

  def self.other_city_order_remarks_count(city,limit = 10)
    Hejia[:cache].fetch("diaries/other_city_order_remarks_count/#{city}/#{limit}", 1.hour) do
      sql = "SELECT diary.id as diary_id, diary.title as diary_title, firm.id as firm_id, diary.remarks_count as diary_remarks_count ,diary.deco_firm_id, diary.remarks_count ,diary.yesterday_remarks FROM decoration_diaries as diary "
      sql.concat "JOIN deco_firms as firm ON firm.id = diary.deco_firm_id "
      if city.to_i == 11910
        sql.concat "WHERE (firm.city = #{city} and diary.status = 1) "
      elsif city.to_i == 11905
        sql.concat "WHERE (firm.city = #{city} and diary.status = 1) "
      elsif city.to_i == 31959
        sql.concat "WHERE (firm.city = #{city} and diary.status = 1) "
      elsif city.to_i == 11908
        sql.concat "WHERE (firm.city = #{city} and diary.status = 1) "
      elsif city.to_i == 11887
        sql.concat "WHERE (firm.city = #{city} and diary.status = 1) "
      else
        sql.concat "WHERE (firm.district = #{city} and diary.status = 1) "
      end
      sql.concat "ORDER BY diary.remarks_count desc "
      sql.concat "LIMIT #{limit}"
      DecorationDiary.find_by_sql(sql)
    end
  end

  # 保存访问过这篇日记的ip
  # ip是放在一个set里面，所以不会重复。
  def add_ip!(ip)
    $redis.sadd ip_cache_key, ip unless ip.blank?
    ip
  rescue
    logger.error "[ERROR] Couldn't add ip to ip set for diary #{id} due to #$!"
  end

  # 访问这篇日记的ip数
  def ip_count
    $redis.scard ip_cache_key
  rescue
    logger.error "[ERROR] Couldn't get ip set size for diary #{id} due to #$!"
    0
  end

  def ip_cache_key
    @ip_cache_key ||= "decoration_diaries:#{id}:ip"
  end
  private :ip_cache_key


  # Get one DecorationDiary from cache or db.
  def self.cached_decoration_diaries(id)
    if id.is_a?(DecorationDiary)
      Hejia[:cache].set "decoration_diary/#{id.id}", id, 1.hour
    else
      Hejia[:cache].fetch("decoration_diary/#{id}", 1.hour) { find_by_id id }
    end
  end


  # 获得城市下的最近日记(缓存10分钟)
  def self.get_city_notes_top(city_id,limit_top)
    HejiaUserBbs
    Hejia[:cache].fetch("get/diray/new/top10/#{city_id}/#{limit_top}",10.minutes) do
      if city_id.to_i == 11910
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.city = 11910 AND deco_firms.id = decoration_diaries.deco_firm_id)"
      elsif city_id.to_i == 11905
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.city = 11905 AND deco_firms.id = decoration_diaries.deco_firm_id)"
      elsif city_id.to_i == 31959
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.city = 31959 AND deco_firms.id = decoration_diaries.deco_firm_id)"
      elsif city_id.to_i == 11908
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.city = 11908 AND deco_firms.id = decoration_diaries.deco_firm_id)"
      elsif city_id.to_i == 11887
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.city = 11887 AND deco_firms.id = decoration_diaries.deco_firm_id)"
      else
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.district= #{city_id} AND deco_firms.id = decoration_diaries.deco_firm_id)"
      end
      DecorationDiary.find(:all,
        :conditions => conditions,
        :order => 'created_at DESC',
        :limit => limit_top,
        :include => :hejia_user_bbs
      )
    end
  end

  #获得当前地区日记排行 榜     ---order pv
  def self.get_diaries_top(city)
    Hejia[:cache].fetch("get_diaries_top/PV/#{city}",5.minutes) do
      if city.to_i == 11910
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.city = 11910 AND deco_firms.id = decoration_diaries.deco_firm_id)"
      elsif city.to_i == 11905
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.city = 11905 AND deco_firms.id = decoration_diaries.deco_firm_id)"
      elsif city.to_i == 31959
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.city = 31959 AND deco_firms.id = decoration_diaries.deco_firm_id)"
      elsif city.to_i == 11908
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.city = 11908 AND deco_firms.id = decoration_diaries.deco_firm_id)"
      elsif city.to_i == 11887
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.city = 11887 AND deco_firms.id = decoration_diaries.deco_firm_id)"
      else
        conditions = "STATUS = 1  AND EXISTS (SELECT 1 FROM deco_firms WHERE deco_firms.district= #{city} AND deco_firms.id = decoration_diaries.deco_firm_id)"
      end
      DecorationDiary.find(
        :all,
        :conditions => conditions,
        :order => 'pv DESC',
        :limit => 10)
    end
  end

  ## 一周pv最高的10条合作公司日记
  def self.top_diaries(city, limit = 10)
    Hejia[:cache].fetch("decoration_diary/top_diaries/#{city}",24.hours) do
      DecorationDiary.find(
        :all,
        :conditions => ["decoration_diaries.STATUS = 1 AND EXISTS (SELECT 1 FROM deco_firms WHERE (#{just_for_city_query(city)}) AND deco_firms.id = decoration_diaries.deco_firm_id and deco_firms.is_cooperation = 1)", city],
        :order => 'week_pv_count DESC',
        :limit => limit)
    end
  end

  ## 合作公司日记Hot10 ：调用规则为一周 根据评论数排序,回复数排序,日记修改时间排序
  def self.hot_diaries(city, limit = 10)
    Hejia[:cache].fetch("decoration_diary/hot_diaries/#{city}",5.minutes) do
      DecorationDiary.find(
        :all,
        :select => "distinct decoration_diaries.*",
        :conditions => ["decoration_diaries.STATUS = 1 AND EXISTS (SELECT 1 FROM deco_firms WHERE (#{just_for_city_query(city)}) AND deco_firms.id = decoration_diaries.deco_firm_id and deco_firms.is_cooperation = 1)", city],
        :joins => "left join remarks on remarks.resource_id = decoration_diaries.id and remarks.resource_type = 'DecorationDiary' and remarks.created_at > '#{7.days.ago}' left join remarks as r on r.parent_id = remarks.id and r.created_at > '#{7.days.ago}'",
        :group => "decoration_diaries.id",
        :order => 'count(remarks.id) DESC,count(r.id) desc,decoration_diaries.updated_at desc',
        :limit => limit)
    end
  end

  # 精华日记排行榜，用于新版装修点评右侧公用模块  3月3号，增加条件合作公司下的
  def self.top_good_diaries city_id
    Hejia[:cache].fetch "top_good_diariess:#{city_id}", 5.minutes do
      tgd_sql = ([11910,11905,31959,11908,11887].include? city_id.to_i) ? "city = ?" : "district = ?"
      deco_firm_ids  = DecoFirm.find(:all,:conditions =>["#{tgd_sql} and is_cooperation = ?",city_id,1],:select => "id").map(&:id)
      self.verified.published.find(:all,:select => "id,title,pv",:conditions => ["deco_firm_id in (?)",deco_firm_ids], :order => "pv desc", :limit => 10)
    end
  end

  # 得到日记已审核的记录数
  def self.has_many_decoration_diaries_number
    Hejia[:cache].fetch("/has_many_decoration_diaries_number/", 5.minutes) do
      DecorationDiary.count(:all, :conditions => ["status = 1"])
    end
  end

  def self.verified_from_now_on
    self.find(:all,:conditions=>"status = 1 and created_at <= '#{3.months.ago}'")
  end

  #根据文章标签找日记
  def self.get_diaries_for_article_tags(city_code, article_tags,limit = 10)
    Hejia[:cache].fetch("get/diary_/ids/for/article/tags/#{article_tags.to_s}/#{city_code}/#{limit}", 5.minutes) do
      tag_ids = HejiaIndexKeyword.find(:all,:conditions => [ "name in (?)",article_tags]).map{|tag|tag.id}
      diary_ids = Relation.find(:all,:select => "distinct(entity_id)",:conditions => ["keyword_id in (?) and relation_type = 7 ", tag_ids]).map{|r|r.entity_id}
      if diary_ids.size > 0
        DecorationDiary.city_num_is(city_code).find(:all,:conditions => ["decoration_diaries.id in (?) ", diary_ids],:order => "decoration_diaries.is_verified desc",:limit => limit)
      else
        DecorationDiary.city_num_is(city_code).find(:all,:order => "decoration_diaries.is_verified desc",:limit => limit)
      end
    end
  end


  #得到某个公司的日记（限制条数）
  def self.get_firm_diaries(firm_id , limit)
    Hejia[:cache].fetch("get/firm/diary/limit/#{limit}", 5.minutes) do
      DecorationDiary.find(:all,
        :conditions => ["status = 1 and deco_firm_id = ?" , firm_id] ,
        :order=>"created_at desc",
        :limit => limit)
    end
  end

  #根据价格,城市查到公司日记
  def self.get_firm_diary_by_price(city,price,limit)
    find(:all,:joins =>'join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id',:conditions =>"#{city} and decoration_diaries.price = #{price} and decoration_diaries.status = 1",:order =>"decoration_diaries.updated_at desc",:limit =>limit)
  end

  class << self

    def zixun_riji_diaoyong_3_1(city)
      Hejia[:cache].fetch("zixun_riji_diaoyong_3_1_#{city}", RAILS_ENV == 'production' ? 1.hour : 1.seconds) do
        c_sql = ([11910,11905,31959,11908,11887].include? city.to_i) ? "f.city = #{city}" : "f.district = #{city}"
        self.find_by_sql("SELECT d.id,d.title FROM decoration_diaries d, deco_firms f where d.status=1 and d.deco_firm_id=f.id and f.is_cooperation=1 and (#{c_sql}) order by d.order_time desc limit 10")
      end
    end

  end

end
