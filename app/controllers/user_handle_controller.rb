class UserHandleController < ApplicationController

  def del_topic(rv="",load_url=nil) #用户删除回帖操作
    topic_id = params[:topic_id].to_i
    user_id =  current_user && current_user.USERBBSID || 0
    topic = AskZhidaoTopic.find(topic_id,:select=>"tag_id, user_id")
    rv = "参数错误!" if topic_id == 0 || user_id == 0
    rv = "您没有权限执行该操作!" if (topic.user_id.to_i != user_id) rescue true
    if rv == ""
        AskZhidaoTopic.delete(topic_id, user_id)
        expire_sortlist(topic.tag_id) #清除某个栏目列表页的memcache缓存
        expire_topic_info(topic_id) #清除某个问题详细信息的memcache缓存
        load_url = "self"
    end
    if params[:refresh]=="f"
        render :text => alert("操作成功：记录已删除！") + js("top.Menu(3);")
    else
        myrender(rv, load_url)
    end
  end

  def del_post(rv="",load_url=nil) #用户删除回帖操作
    post_id = params[:post_id].to_i
    topic_id = params[:topic_id].to_i
    user_id =  current_user && current_user.USERBBSID || 0
    rv = "参数错误!" if post_id == 0 || topic_id == 0 || user_id == 0
    rv = "您没有权限执行该操作!" if (AskZhidaoTopicPost.find(post_id,:select=>"user_id").user_id.to_i != user_id) rescue true
    if rv == ""
        AskZhidaoTopicPost.delete_post(post_id, user_id)
        expire_posts(topic_id) #清除某个问题的回复信息的memcache缓存
        load_url = "self"
    end
    if params[:refresh]=="f"
        render :text => alert("操作成功：记录已删除！") + js("top.Menu(4);")
    else
      myrender(rv, load_url)
    end
    
  end

  def edit_post
    post_id = params[:post_id].to_i
    @post = AskZhidaoTopicPost.find(post_id,:select=>"id,content")
  end

  def edit_post_save(rv = "",load_url = nil) #回答问题保存
    post_id = params[:post_id].to_i
    content = trim(params[:content])
    utf8_length = content.split(//u).length
    user_id = current_user.id.to_i
    
    if utf8_length < 5
      rv = "提交失败：回复内容必须长于5个字符！"
    elsif (content.length - utf8_length) < 4
      rv = "提交失败：您的回复内容必须包含中文！"
    elsif user_id == 0
      rv = "操作失败：您还未登录或登录信息已失效！"
    else
      post = AskZhidaoTopicPost.find(post_id,:select=>"id,content,user_id,zhidao_topic_id")
      rv = "操作失败：您没有编辑改文章的权限！" if post.user_id.to_i != user_id
      topic_id = post.zhidao_topic_id
    end

    if rv == ""
      begin
          post.content = content
          post.save
          expire_posts(topic_id) #清除某个问题的回复信息的memcache缓存
          rv = "操作成功：回复信息已更改！"
          load_url = "/q/#{topic_id}.html"
      rescue Exception => e
          rv ="操作失败：#{e}"
      end
    end
    rv = alert(rv.to_s)
    rv += js(top_load(load_url)) unless load_url.nil?
    render :text => rv
  end

end
