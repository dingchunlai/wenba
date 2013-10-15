class DecoFirmsContact < Hejia::Db::Hejia

  validates_presence_of :deco_firm_id
  belongs_to :deco_firm

  before_create :set_master_shop

  ADDRESS_TYPE = {'总店' => 1, '分店' => 0}

  # 把其他总店的去掉
  def resolve_conflict
    self.class.update_all('is_master = 0', ["id <> ? and deco_firm_id = ? and is_master <> 0", id, deco_firm_id])
  end

  # 是否是总店
  def master?
    is_master == true || is_master == 1 
  end

  # 设为总店
  def master!
    self.is_master = 1
    if save
      resolve_conflict
      true
    else
      false
    end
  end

  # 去掉总店
  def not_master!
    self.is_master = 0
    save
  end

  private 
    def set_master_shop
      self.is_master = 0 unless self.is_master
    end

end
