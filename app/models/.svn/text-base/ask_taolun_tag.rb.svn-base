class AskTaolunTag < ActiveRecord::Base
  def self.save(name)
    transaction() {
      azt = AskTaolunTag.new
      azt.name = name
      azt.save
    }
  end
  
  def self.edit(id,name)
    azt = AskTaolunTag.find(:first, :select => "id,name",
      :conditions => ["id = ?",id ])
    azt.update_attribute("id", id)
    azt.update_attribute("name", name)
  end
   
end
