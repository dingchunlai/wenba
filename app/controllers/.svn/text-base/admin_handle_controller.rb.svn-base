class AdminHandleController < ApplicationController

  def recount_post_counter(rv="",ru=nil)
    if current_staff && current_staff.wenba_editor?
      method = params[:method].to_i
      limit = params[:limit].to_i
      limit = 10 if limit == 0
      cd = []
      cd << "is_delete = 0"
      cd << "is_vote = 0"
      cd << "method = #{method}" unless method == 0
      topics = AskZhidaoTopic.find(:all,:select=>"id,post_counter,view_counter",:conditions=>cd.join(" and "),:limit=>limit)
      i = 0
      for topic in topics
        pc = AskZhidaoTopicPost.count("id",:conditions=>"zhidao_topic_id = #{topic.id} and is_delete = 0").to_i
        us = []
        us << "is_vote = 1"
        us << "post_counter = #{pc}" if pc != topic.post_counter.to_i
        us << "view_counter = #{pc + rand(pc)}" if topic.post_counter > topic.view_counter && pc > 0
        i += 1 if pc != topic.post_counter.to_i || (topic.post_counter > topic.view_counter && pc > 0)
        AskZhidaoTopic.update_all(us.join(", "), "id = #{topic.id}")
      end
      rv = "重新统计成功！总共统计了 #{topics.length} 条记录，其中#{i}条记录被修改！"
    else
      rv = "你没有权限执行该操作！"
    end
    myrender(rv, ru)
  end
  
  def del_topics(rv="",load_url=nil)
    ids = params[:ids].to_s
    if ids.length > 0
      if current_staff && current_staff.wenba_editor?
        begin
          topics = AskZhidaoTopic.find(:all,:select=>"id,tag_id",:conditions=>"id in (#{ids})")
          for topic in topics
            expire_topic_info(topic.id) #清除某个问题详细信息的memcache缓存
            expire_sortlist(topic.tag_id) #清除某个栏目列表页的memcache缓存
          end
          AskZhidaoTopic.update_all("is_delete = 1, editor_id = #{current_staff.id}", "id in (#{ids})")
        rescue Exception => e
          rv = "操作失败：#{e}"
        end
      else
        rv = "您没有权限执行该操作!"
      end
    else
      rv = "参数错误!"
    end
    myrender(rv, load_url)
  end

  def del_posts(rv="",load_url=nil)
    id = params[:id].to_i
    topic_id = params[:topic_id].to_i
    if id != 0
      if current_staff && current_staff.wenba_editor?
        AskZhidaoTopicPost.delete_post(id, current_staff.id)
        post_user_id = AskZhidaoTopicPost.find(id, :select=>"user_id").user_id rescue 0
        CommunityUser.set_point(post_user_id, -5) unless post_user_id == 0 #回帖被管理员删除，该用户将扣除5个积分点。
        expire_posts(topic_id) #清除某个问题的回复信息的memcache缓存
        load_url = "self"
      else
        rv = "您没有权限执行该操作!"
      end
    else
      rv = "参数错误!"
    end
    myrender(rv, load_url)
  end


  def change_status()
    topic_id = params[:topic_id].to_i
    begin
      if current_staff && current_staff.wenba_editor?
        CACHE.delete(AskZhidaoTopic.memkey_new_topics)
        expire_topic_info(topic_id)
        is_distribute = AskZhidaoTopic.update_is_distribute(topic_id)
        render :text => js("top.document.getElementById('button_tgyz').innerHTML = '#{is_distribute == 0 ? '未验证' : '已验证'}';")
      end
    rescue Exception => e
      
    end
  end
end
