class OracleHejiaUsers < ActiveRecord::Base
  include OracleConn
  self.table_name = "hejia_users"
  self.primary_key = "id"
end
