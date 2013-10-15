class AskBlogConfig < ActiveRecord::Base
  def self.save(user_id, blog_name, blog_description)
    abc = AskBlogConfig.new
    abc.user_id = user_id
    abc.blog_name = blog_name
    abc.blog_description = blog_description
    abc.save
  end
  
  def self.modify(user_id, blog_name, blog_description)
    abc = AskBlogConfig.find(:first, :conditions => ["user_id = ?",user_id])
    abc.blog_name = blog_name
    abc.blog_description = blog_description
    abc.save
  end
end
