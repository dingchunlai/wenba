class FilterWord < ActiveRecord::Base
   self.table_name = "radmin_filter_words"
  def self.word_filter(str)
    filter_words = CACHE.get("filter_words")
    if filter_words.nil? || true
     filter_words=get_filter_keys()
    end
    alert_keys = get_alert_filter_keys(str,filter_words["ban"])
    if alert_keys.size>0
        return {"ban" => alert_keys}
      else
        return {"***" => get_filter_after(str,filter_words["***"]) }
    end
  end
  
  private

    def self.get_filter_keys()
      filter_words = Hash.new
      fws = self.find(:all, :select=>"old, new, sort_id", :conditions=>"sort_id in (0, 2)")
      filter_words=fws.group_by{|x| x.new}
      CACHE.set("filter_words", filter_words)
      filter_words
    end

    def self.get_alert_filter_keys(str,filter_keys)
        keys_array=[]
      filter_keys.each do |v|
         keys_array << trim(v.old) if(str.include?(trim(v.old)))
      end
      keys_array.uniq.join(",")
    end

    def self.get_filter_after(str,filter_keys)
     filter_keys.each do |v|
         str = str.gsub(trim(v.old), trim(v.new))
      end
      str
    end
    
end
