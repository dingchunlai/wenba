module AdminHelper
  def get_post_id_by_topic_id(topic_id)
    post_id = AskZhidaoTopicPost.find(:first, :select => "id",
      :conditions => ["zhidao_topic_id = ? and method = 2", topic_id]).id
    return post_id
  end
  
  def get_select_name_by_select_value(value_id)
    nickname = ""
    value_id = value_id.to_i
    nickname = "设置最佳答案" if value_id == 1
    nickname = "批量打标签" if value_id == 2
    nickname = "单个打标签" if value_id == 3
    nickname = "删除相应的文章" if value_id == 4
    nickname = "删除指定的帖子和回复" if value_id == 5
    nickname = "删除指定的回复" if value_id == 6
    nickname = "设置黑名单" if value_id == 7
    nickname = "解析上传文件" if value_id == 8
    nickname = "创建新专家" if value_id == 9
    nickname = "讨论版小区名更新" if value_id == 10
    nickname = "讨论版小区名删除" if value_id == 11
    nickname = "讨论版小区名添加" if value_id == 12
    nickname = "讨论版帖子固顶设置" if value_id == 13
    nickname = "讨论版帖子置顶设置" if value_id == 14
    nickname = "取消讨论版帖子的特权操作" if value_id == 15
    nickname = "添加讨论版公告" if value_id == 16
    nickname = "删除讨论版公告" if value_id == 17
    nickname = "讨论版公告的编辑" if value_id == 18
    return nickname    
  end
  
end