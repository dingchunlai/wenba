class MineController < ApplicationController

  before_filter :user_validate

  def m3
    cd = "is_delete=0 and user_id=#{current_user.id.to_i}"
    order = "best_post_id,id desc"
    h = Hash.new
    h["model"] = AskZhidaoTopic
    h["pagesize"] = 15 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id,subject,best_post_id,post_counter,view_counter,created_at"
    h["conditions"] = cd
    h["order"] = order
    @my_topics = paging_record(h)
    render :layout => false
  end

  def m4
    cd = "is_delete=0 and user_id=#{current_user.id.to_i}"
    order = "id desc"
    h = Hash.new
    h["model"] = AskZhidaoTopicPost
    h["pagesize"] = 15 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id,content,zhidao_topic_id,created_at"
    h["conditions"] = cd
    h["order"] = order
    @my_posts = paging_record(h)
    render :layout => false
  end

  def user_validate
    show_validate_error("您还未登录！") unless current_user
  end

  def show_validate_error(str) #输出验证错误
    #    if (request.request_uri=="/" || request.request_uri=="/admin")
    #        render :text => js(top_load("/user/login"))
    #    else
    render :text => "<div style='line-height:30px; padding:30px'><b>#{str} <a href=\"/\">[点这里登录]</a></b>\
  <br /><br />如果您是因长时间未访问页面而使登录信息失效的话，\
  请 <a href=\"/\" target=\"_blank\">点这里在新窗口中登录</a> ,<br />\
  然后 <a href=\"javascript://\" onclick=\"location.reload();\">点这里刷新本页面</a> 以完成您的操作。<br /><br />\
  或者您也可以 <a href=\"javascript://\" onclick=\"history.back();\">点这里返回前一页</a> 。</div>" + js("if (top!=self) alert(\"#{str}\");")
    #    end
  end

  def goto_mine
    render :text => js("window.open('/mine/index','_top');")
  end

  def index
      @user_id = current_user.id.to_i
      @username = current_user.USERNAME
  end

end
