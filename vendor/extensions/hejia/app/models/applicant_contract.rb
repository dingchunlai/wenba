class ApplicantContract < Hejia::Db::Hejia
  belongs_to :deco_firm
  include Hejia::FixTimestampZone
  validates_presence_of :contract, :limit_number
  validates_numericality_of :limit_number, :only_integer => true, :message => "单数必须为整数！"
end
