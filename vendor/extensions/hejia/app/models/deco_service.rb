class DecoService < Hejia::Db::Hejia
  belongs_to :deco_firm
  validates_presence_of :title,:content

  belongs_to :designer, :class_name => "CaseDesigner"
  has_many :pictures, :as => :item
  has_many :remarks, :as => :resource, :order => "created_at desc"
  has_many :show_remarks, :class_name => "Remark", :conditions => "resource_type='DecoService' and status=1", :foreign_key => "resource_id", :order => "created_at desc"

  def master_picture(size="")
    Picture
    Hejia[:cache].fetch "deco_service:#{self.id}:master_picture", RAILS_ENV != 'production' ? 0 : 1.month do
      picture = Picture.find(:first, :conditions => ["is_master=1 and item_type='DecoService' and item_id = ?", self.id])
      picture = Picture.find(:first, :conditions => [" item_type='DecoService' and item_id = ?", self.id] , :order=>"created_at desc") if picture.nil?
      picture.nil? ? Picture.new(:image_url => "http://www.51hejia.com/api/images/none.gif") : picture
    end
  end

  def pv_cache_key
    @pv_cache_key ||= "deco_services/#{id}/pv"
  end
  private :pv_cache_key


  # PV
  def increase_pv!
    if defined?($redis)
      $redis.incr pv_cache_key
    else
      self.pv += 1
      self.class.update_all({:pv => pv}, :id => id)
    end
  end

  #手动修改PV
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

end