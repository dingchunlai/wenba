class HejiaCase < Hejia::Db::Hejia
 self.table_name = "HEJIA_CASE"

 def self.getCaseIdByBBSID(bbsid)
   case_entity= HejiaCase.find(:first,:select=>"id",:conditions=>[" DESIGNERID=? ",bbsid],:order=>" id desc ")
    unless case_entity.nil?
     case_entity.id
     else
      '#'
    end
 end

end
