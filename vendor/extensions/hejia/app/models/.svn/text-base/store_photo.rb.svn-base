class StorePhoto < Hejia::Db::Hejia
  belongs_to :deco_firm
  has_one :picture, :as => :item ,:dependent => :destroy
  validates_associated :picture
  acts_as_list :scope => :deco_firm_id
end
