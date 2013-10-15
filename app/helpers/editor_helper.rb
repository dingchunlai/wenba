module EditorHelper
  def get_user_tags_by_topic_id(topic_id)
    user_tags = ""
    @ask_topic_user_tags = AskTopicUserTag.find(:all, :select => "DISTINCT user_tag_id",
      :conditions => ["topic_id = ? and topic_type_id = ?", topic_id, 1])
    if @ask_topic_user_tags
      @ask_topic_user_tags.each { |ask_topic_user_tag|
        user_tag_name = get_user_tag_name_by_user_tag_id(ask_topic_user_tag.user_tag_id)
        user_tags = user_tags + user_tag_name + " "
      }      
    end
    return user_tags.lstrip.rstrip
  end
  
  def get_user_tag_name_by_user_tag_id(user_tag_id)
    user_tag_name = AskUserTag.find(:first, :select => "name", :conditions => ["id = ?", user_tag_id]).name
    return user_tag_name
  end
  
  def get_zhidao_topic_post_by_topic_id(topic_id)
    zhidao_topic_post = AskZhidaoTopicPost.find(:all, :select => "id ,content",
      :conditions => ["zhidao_topic_id = ? and user_id >= 0 and is_delete = 0", topic_id],
      :order => "id DESC",
      :limit => 6)
    return zhidao_topic_post
  end

  def get_moderator_info(id)
    @moderator_info = AskZhidaoAdmin.find(:first, :conditions=>['id = ? and is_delete = ?',id, 0])
    html = ""
      html = html + "<li>"+ get_user_name_by_user_id(@moderator_info.admin_id) + " <a href=\"/editor/delete_moderator/#{@moderator_info.id}\">删除</a></li>"
    return html
  end
  
end