# encoding: utf-8

class SalesMan < Hejia::Db::Hejia
  
  validates_presence_of :name, :email, :city

  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'email must be valid'

  # =>validates_format_of :telephone, :with => /(^(\d{2,4}[-_－—]?)?\d{3,8}([-_－—]?\d{3,8})?([-_－—]?\d{1,7})?$)|(^0?1[35]\d{9}$)/, :message => "Telephone is invalid"

  has_many :deco_firms

  validate :validate_city

  # 有效的
  named_scope :valid, :conditions => ["deleted = ?", false], :order => "created_at DESC"
  # 失效的
  named_scope :failure, :conditions => ["deleted = ?", true], :order => "created_at DESC"
  # 不区分的
  named_scope :every, :order => "created_at DESC"

  named_scope :with_name, lambda{|name|
    {
      :conditions => name.blank? ? nil : ['name like ?', "%#{name}%"]
    }
  }
 
  named_scope :with_city, lambda{|city|
    {
      :conditions => city.blank? ? nil : ['city = ?', city]
    }
  }
  
  def hidden
    update_attribute :deleted, true
  end

  def display
    update_attribute :deleted, false
  end

  private
    def validate_city
      obj = City.find_by_name_en(self.city)
      obj.blank? ? errors.add(:city, 'Search this City is not  Exp: shanghai') : write_attribute(:city, obj.name_en)
    end

end
