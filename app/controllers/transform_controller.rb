class TransformController < ApplicationController
  def index
    if File.exist?("mysql.sql")
      File.delete("mysql.sql")
    end
    
    @companies = OracleHejiaCompany.find(:all, 
      :select=>"id, cn_name, address, tel, linkman, webstage, country, area, type, describe, guildId, hasordermanagerfeature, haschatmanagerfeature, createdate",
      :conditions => ["type = '12362'"])
    
    @companies.each do |company| 
      s = "insert into ask_hejia_companies
      (id, cn_name, address, tel, linkman, web_stage, 
       country, area, type_id, description, guild_id, has_order_manager_feature, 
       has_chat_manager_feature, create_date, created_at)
      values " + 
        "("+ "#{company.id.to_s}, " + "'" + company.cn_name.to_s + "', " + "'" + company.address.to_s + "', " + 
        "'" + company.tel.to_s + "', " + "'" + company.linkman.to_s + "', " + "'" + company.webstage.to_s + "', " +   
        "'"+ company.country.to_s + "', " + "'"+ company.area.to_s + "', " + "'12362', " +
        "'"+ company.describe.to_s + "', " +  "'" +company.guildid.to_s + "', " + 
        "'"+ company.hasordermanagerfeature.to_s + "', " +  "'" + company.haschatmanagerfeature.to_s + "'," + " from_unixtime(" + company.createdate.to_i.to_s + "), "  + "now()"  +  ");"
        
      open('mysql.sql', 'a') do |file|   
        file.puts s
      end
    end 
    
  end
end

