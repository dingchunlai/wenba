class OracleHejiaCompany < ActiveRecord::Base
  include OracleConn
  self.table_name = "hejia_company"
  self.inheritance_column = "type_id"
  #self.primary_key = "id"
end
