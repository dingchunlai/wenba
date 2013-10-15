# encoding: utf-8

class MobileCodeVerify < Hejia::Db::Hejia
  include Hejia::FixTimestampZone
  self.table_name = "mobile_verify_codes"
end

__END__
== Schema Information

mobile_code_verifies (
  id                    :integer(11)     not null, primary key
  user_id               :integer(11)
  user_mobile           :string(255)
  resource_type         :string(255)
  send_status           :integer(11)     default(0)
  verify_status         :integer(11)     default(0)
  created_at            :datetime
  updated_at            :datetime
)
