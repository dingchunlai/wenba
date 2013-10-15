class AskHejiaCompany < ActiveRecord::Base   
  def self.save(user_id, cn_name, description, address, tel, linkman, web_stage, country, area, guild_id, method = 3, type_id= 12362)
    transaction(){
      ahc = AskHejiaCompany.new
      ahc.user_id = user_id
      ahc.cn_name = cn_name
      ahc.description = description
      ahc.address = address
      ahc.tel = tel
      ahc.linkman = linkman
      ahc.web_stage = web_stage
      ahc.country = country
      ahc.area = area
      ahc.method = method
      ahc.type_id = type_id
      ahc.guild_id = guild_id
      ahc.save
    }
  end
  
  
  def self.view(hejia_company_id)
    ahc = AskHejiaCompany.find(hejia_company_id)
    ahc.view_counter = ahc.view_counter + 1
    ahc.save
  end
  
   def self.delete(hejia_company_id, editor_id)
    ahc = AskHejiaCompany.find(hejia_company_id)
    ahc.is_delete = 1
    ahc.editor_id = editor_id
    ahc.save
  end
  
end
