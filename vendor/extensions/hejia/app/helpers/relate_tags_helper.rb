module RelateTagsHelper
  
  #把关键字由;分隔改为由_分隔
  def keywords_in_url keywords
    keywords.to_s.gsub(/;/,"_")
  end
  
  
end
