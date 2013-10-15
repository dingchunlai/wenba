# 用户对品牌的印象
class DecoImpression
  attr_accessor :title, :deco_firm_id, :number, :session_id

  # 最新印象列表中，保存多少条记录
  @@limit = 5
    
  class << self
    
    #计算品牌的印象的总得票数，
    def sum_count(deco_firm_id)
      deco_impress = $redis.zrange self.impression_set_for(deco_firm_id), 0, -1
      count = 0
      deco_impress.each do |key|
        count += $redis.zscore(self.impression_set_for(deco_firm_id), key).to_f
      end
      $redis.set self.counter_for(deco_firm_id),count
    end
    
    #印象排行榜
    def charts(deco_firm_id, limit = 8)
      count = DecoImpression.count(deco_firm_id).to_f
      cs = []
      limit = [limit,DecoImpression.count(deco_firm_id)].min
      is = DecoImpression.find deco_firm_id, :limit => limit, :with_count => true
      0.step(limit*2-1, 2) do |i|
        cs << {:name=>is[i],:score=>is[i+1],:percent=>format('%.1f', is[i+1].to_f*100/count)+'%'}
      end
      cs
    end

    # 创建一条印象记录
    # @param [Hash] attributes 印象的属性
    # @option attributes [Integer] :deco_firm_id TaggedBrand对象的id
    # @option attributes [String] :title 印象名称。
    # @option attributes [Integer] :number 印象数，可选，默认值是1。
    # @return [Boolean] true表示保存成功；false表示保存失败。
    def create(attributes)
      new(attributes).save
    end

    # 找出品牌印象。
    # @param [Integer] deco_firm_id TaggedBrand对象的id
    # @param [Hash] options 选项
    # @option options [Integer] :limit 返回多少条记录
    # @option options [Boolean] :with_count 是否返回每一个印象的对应的计数
    def find(deco_firm_id, options = nil)
     impressions = $redis.zrevrange impression_set_for(deco_firm_id),
        0, (options.try(:[], :limit) || 0) - 1,
        :with_scores => options.try(:[], :with_count)
     impressions.nil? ? [] : impressions
    end
    
    def rand(deco_firm_id)
      rand_impressions = 
      deco_impressions = find(deco_firm_id)
      deco_impressions.choice
    end

    # 返回品牌所有印象的总计数（就是有多少人参加过印象点评）。
    def count(deco_firm_id)
      # 如果redis有zscores之类的方法返回总分的话就方便了。
      $redis.get(counter_for(deco_firm_id)).to_i
    end
    
    def distinct_count(deco_firm_id)
      $redis.zcount(impression_set_for(deco_firm_id),0,10)
    end
        
    #返回最新得到印象的公司
    #limit返回几条  city_code为城市编号
    def firms_soft_latest_of(city_code, limit)
      firms_sort_key = self.firms_soft_latest_city_for(:city_code => city_code)
      $redis.lrange(firms_sort_key, 0, limit-1 )
    end
    
    # 返回最新添加的若干条印象
    # 由@@limit决定有多少条
    def latest(deco_firm_id)
      $redis.zrevrange latest_list_for(deco_firm_id), 0, -1
    end
    
    #根据公司ID或城市代号得到当前的KEY值
    #options[:deco_firm_id] 为公司ID
    #options[:city_code]为城市代号
    def firms_soft_latest_city_for(options={})
       deco_firm_id = options[:deco_firm_id]
       city_code = options[:city_code]
      unless deco_firm_id.nil?
        firm = DecoFirm.find(deco_firm_id)
        if firm.city.to_i == 11910
          "tagged_decos:11910:impression:sort:latest"
        elsif firm.city.to_i == 11905
          "tagged_decos:11905:impression:sort:latest"
        elsif firm.city.to_i == 31959
          "tagged_decos:31959:impression:sort:latest"
        elsif firm.city.to_i == 11908
          "tagged_decos:11908:impression:sort:latest"
        elsif firm.city.to_i == 11887
          "tagged_decos:11887:impression:sort:latest"
        else
          "tagged_decos:#{firm.district}:impression:sort:latest"
        end
      else
      "tagged_decos:#{city_code}:impression:sort:latest"      
       end
    end
    
    def impression_set_for(deco_firm_id)
      "tagged_decos:#{deco_firm_id}:impressions"
    end

    def counter_for(deco_firm_id)
      "tagged_decos:#{deco_firm_id}:impressions:counter"
    end

    def latest_list_for(deco_firm_id)
      "tagged_decos:#{deco_firm_id}:impressions:latest"
    end

  end

  def initialize(attributes)
    attributes.each do |field, value|
      send "#{field}=", value
    end
  end

  def errors
    @errors ||= ActiveRecord::Errors.new(self)
  end

  def valid?
    errors.empty?
  end
  
  def save
    normalize_attributes
    validates
    
    valid? && create && set_firms_impression_sort_for(deco_firm_id)
    
  end

  private
  
  def normalize_attributes
    self.title = title.strip if title
    self.number ||= 1
  end
  
  def validate_click_limit
    key = "dianping:firms:show:deco_impression:#{deco_firm_id}:#{session_id}"
    expired_at = (Time.now.tomorrow.at_beginning_of_day - Time.now).to_i
    if Hejia[:cache].get(key).nil?
      Hejia[:cache].set(key,1,expired_at)
    elsif  Hejia[:cache].get(key) == 1
      Hejia[:cache].set(key,2,expired_at)
    elsif Hejia[:cache].get(key) == 2
      errors.add_to_base('每天每个公司最多可投两个印象')
    end
  end

  def validates
    validate_click_limit if RAILS_GEM_VERSION > "2.0.0"
    errors.add_to_base('请填写印象') if title.blank?
    errors.add_to_base('得票数必须是个整数') unless number.is_a?(Integer)
    errors.add_to_base('得票数不能少于1') if number.is_a?(Integer) && number < 1
    errors.add_to_base('请选择公司') if deco_firm_id.blank?
  end
  
  def create
    $redis.multi
    # 给品牌添加印象，包括这个印象的得票数(ordered set)
    $redis.zincrby self.class.impression_set_for(deco_firm_id), number, title
    
    # 处理最新添加的印象(ordered set)
    latest_list = self.class.latest_list_for deco_firm_id
    $redis.zadd latest_list, Time.now.to_i, title
    $redis.zrem latest_list, $redis.zrange(latest_list, 0, 0).first if $redis.zcard(latest_list).to_i > @@limit
    $redis.exec
    true
  rescue
    Rails.logger.error $!
    Rails.logger.error $@.join("\n")
    $redis.discard
    false
  end

    #添加最新得到印象的公司
    def set_firms_impression_sort_for(deco_firm_id)
      # params[:deco_firm_id] is_a?(DecoFirm) Don't Find 
      firm = deco_firm_id.is_a?(DecoFirm) ? deco_firm_id : DecoFirm.find_by_id(deco_firm_id)
      deco_firm_id = firm.id
      if firm.is_cooperation.to_i != 1
        true
      else
        firms_sort_key = self.class.firms_soft_latest_city_for(:deco_firm_id => deco_firm_id)
        key_length = $redis.llen(firms_sort_key)
        $redis.lrem(firms_sort_key, key_length, deco_firm_id) if key_length > 0
        $redis.lpush(firms_sort_key,deco_firm_id)
        true
      end
    end
  
end
