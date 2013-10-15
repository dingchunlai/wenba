class RelateTag < Hejia::Db::Hejia
  
  validates_uniqueness_of :article_tag, :on => :create, :scope => :diary_tag
  
  named_scope :search_for ,lambda { |params| 
    conditions = []
    condition_params = []
    unless params[:article_tag].nil?
      conditions << "article_tag like ?"
      condition_params << "%#{params[:article_tag]}%"
    end
    unless params[:diary_tag].nil?
      conditions << "diary_tag like ?"
      condition_params << "%#{params[:diary_tag]}%"
    end
    conditions << "true"
    {
      :conditions => [conditions.join(' and ')] + condition_params,
    }
  }
  
  named_scope :for_article , lambda{ |article_tag| {:conditions => [" article_tag = ? " , article_tag]}}
  
  #根据文章标签得到对应的日记标签
  def self.get_diary_tags_for article_tag
    RelateTag.for_article(article_tag).map{|relate_tag| relate_tag.diary_tag}  
  end
  
  #根据文章标签得到日记tag
  def self.get_diary_tag article_tags
    tags = article_tags.split("_")
    diary_tags = []
    tags.each do |article_tag|
      diary_tags += RelateTag.get_diary_tags_for(article_tag)
    end
  end
  
  #先放在这里.到时候移到rake里去
  def self.update_relate_tag 
    RelateTag.find(:all).each do |r|
      # RelateTag.update(r.id ,:article_tag => trim(r.article_tag) , :diary_tag => trim(r.diary_tag))
      r.update_attributes(:article_tag => trim(r.article_tag) , :diary_tag => trim(r.diary_tag))
    end
  end
end