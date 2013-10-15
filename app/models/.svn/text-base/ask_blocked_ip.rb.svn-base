class AskBlockedIp < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia]

  def self.blocked?(ip)
    self.find(:first, :select => "id, ip", :conditions => ["ip = ?", ip]) ? true :false
  end
  
  def self.save(ip)
    @ads = self.find(:all, :select => "id, ip", :conditions => ["ip = ?", ip])
    if @ads.size == 0
      transaction() { 
        aztp = AskBlockedIp.new
        aztp.ip = ip
        aztp.save
      }
    end
  end
  
end