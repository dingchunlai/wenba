module OracleConn
  def self.included(c)  
    c.establish_connection "oracle_#{ENV['RAILS_ENV']}".to_sym  
  end
end