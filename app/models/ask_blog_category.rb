class AskBlogCategory < ActiveRecord::Base
  def self.save(user_id, category_name, category_description)
    existing_category_names = AskBlogCategory.find(:all, :select => "id",
      :conditions => ["user_id = ? and category_name = ?", user_id, category_name])
    static_category_name = AskBlogCategory.find(:first, :select => "category_name",
      :conditions => "user_id is null").category_name
    if (existing_category_names.size > 0) or (category_name == "") or (category_name == static_category_name)
      #
    else
      abc = AskBlogCategory.new
      abc.user_id = user_id
      abc.category_name = category_name
      abc.category_description = category_description
      abc.save
    end
  end
  
  def self.update(id,user_id, category_name, category_description)
    existing_category_names = AskBlogCategory.find(:all, :select => "id",
      :conditions => ["user_id = ? and category_name = ?", user_id, category_name])
    static_category_name = AskBlogCategory.find(:first, :select => "category_name",
      :conditions => "user_id is null").category_name
    if (existing_category_names.size > 0) or (category_name == "") or (category_name == static_category_name)
      #
    else
      transaction(){
        AskBlogCategory.find(id).update_attribute("category_name", category_name)
        AskBlogCategory.find(id).update_attribute("category_description", category_description)
      }
      
    end
  end
  
end