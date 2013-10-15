module DetailHelper

  def render_accept_post_button(cur_user_id,topic_user_id,post_user_id,post_id,best_post_id) #展示“采纳该答案”按钮
    rv = ""
    if cur_user_id.to_i != 0  #如果当前用户不是游客
      if cur_user_id.to_i == topic_user_id.to_i  #如果当前用户是发帖者
        if post_user_id.to_i != 0  #如果回帖者不是游客
          if best_post_id.to_i == 0  #如果当前帖子没有采纳过最佳答案
            if post_user_id.to_i != topic_user_id.to_i  #如果回帖者不是发帖者
                rv = "<div style='text-align:right'><input type='button' value='采纳该答案' onclick='accept_post(#{post_id});' /></div>"
            end
          end
        end
      end
    end
    return rv
  end

 def render_user_operate_button(cur_user_id, t_user_id, topic_id, post_id, t_type)  #展示用户操作(编辑及删除)按钮
   rv = ""
   if cur_user_id.to_i != 0  #如果当前用户不是游客
     if cur_user_id.to_i == t_user_id.to_i  #如果当前用户是发帖者
       if t_type == "topic"
        rv = "<div style='text-align:right'><input type='button' value='编辑' onclick='' disabled />
             <input type='button' value='删除' onclick='if (confirm(\"是否确定要删除该问题?\"))
             hideiframe.location.href=\"/user_handle/del_topic?topic_id=#{topic_id}\";' /></div>"
       else
        rv = "<div style='text-align:right'><input type='button' value='编辑' onclick='edit_post(#{topic_id},#{post_id});' />
             <input type='button' value='删除' onclick='if (confirm(\"是否确定要删除该回帖?\"))
             hideiframe.location.href=\"/user_handle/del_post?post_id=#{post_id}&topic_id=#{topic_id}\";' /></div>"
       end
     end
   end
   return rv
 end

end
