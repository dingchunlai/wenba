class GloryCertificate < Hejia::Db::Hejia
  belongs_to :deco_firm
  has_one :picture, :as => :item ,:dependent => :destroy
  acts_as_list :scope => :deco_firm_id
end
