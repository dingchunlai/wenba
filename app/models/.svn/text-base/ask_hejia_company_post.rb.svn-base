class AskHejiaCompanyPost < ActiveRecord::Base
  def self.save(hejia_company_id, user_id, content, guest_email, ip, method=3)
    transaction() { 
      ahcp = AskHejiaCompanyPost.new
      ahcp.hejia_company_id = hejia_company_id
      ahcp.user_id = user_id
      ahcp.content = content
      ahcp.guest_email = guest_email
      ahcp.ip = ip
      ahcp.method = method
      ahcp.save
      
      ahc = AskHejiaCompany.find(hejia_company_id)
      ahc.post_counter = ahc.post_counter + 1
      ahc.save
    }
  end
end
