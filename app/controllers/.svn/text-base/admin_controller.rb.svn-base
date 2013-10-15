class AdminController < ApplicationController
  before_filter :is_admin

  def new
    @admin = AskAuthorizedUser.new
  end
  
  def create
    if params[:username]
      user_id = get_user_id_by_user_name(strip(iconv_gb2312(params[:username])))
      editor_id = get_user_id_by_cookie_name()
      authority_type_id = 1
      is_valid = 1
      if user_id != 0
        AskAuthorizedUser.save(user_id, editor_id, authority_type_id, is_valid)
        AskEditorOperation.save(editor_id, 1, 9, request.request_uri)
        redirect_to :action => 'list'
      else
        redirect_to :action => 'new'
      end
    else
      redirect_to :action => 'new'
    end
  end
  
  def list
    @admin = AskAuthorizedUser.find(:all,:conditions => ["is_valid = 1"])
  end
  
  def show
    @admin = AskAuthorizedUser.find(:first, :conditions => ["user_id = ?", params[:id]])
  end
  
  def delete
    @admin= AskAuthorizedUser.find(params[:id])
    if @admin.update_attribute(:is_valid, 0)
      redirect_to :action => 'list'
    end
  end
  
  def add_info
    session[:type] = params[:id]
    @admins = AskAuthorizedUser.find(:all, :conditions => ["is_valid = 1"])
    if params[:id] and params[:id].to_i != 0
      @bbs_info = HejiaUserBbs.find(params[:id])
    end
  end
  
  def create_info
    user_id = params[:t]
    if user_id == "0"
      redirect_to :action => 'add_info'
    else    
      @admin = HejiaUserBbs.find(user_id)
      if @admin.update_attributes(params[:admin])
        redirect_to :action => 'add_info'
        flash[:notice] = '操作成功'
      else
        redirect_to :action => 'add_info'
      end
    end
  end
  
  def zomelist
    @name_pages, @names = paginate(:ask_taolun_tags, :select => "id, name,created_at", 
      :order => 'id ', 
      :per_page => 10)
  end
  
  def edit_zome
    @name = AskTaolunTag.find(:first, :select => "id, name",
      :conditions => ["id = ?", params[:id]])
  end
  
  def update_zome
    if strip(params[:ti])  
      ti = strip(params[:ti]).to_s
      if strip(params[:tid])  
        tid = strip(params[:tid]).to_i
        editor_id = get_user_id_by_cookie_name()
        AskTaolunTag.edit(tid,ti)
        AskEditorOperation.save(editor_id, 1, 10, request.request_uri)
        flash[:notice] = '小区名更新成功!'
      end
    end
    redirect_to :action => 'zomelist'
  end
  
  def dele
    if strip(params[:id]) and strip(params[:id])!= ""  
      re = strip(params[:id])
      editor_id = get_user_id_by_cookie_name()
      res = AskTaolunTag.destroy(re)
      AskEditorOperation.save(editor_id, 1, 11, request.request_uri)
    end
    redirect_to :action => 'zomelist'
  end
  
  def add_zome
    if strip(params[:wd]) and strip(params[:wd])!= ""  
      wd = strip(params[:wd])
      editor_id = get_user_id_by_cookie_name()
      AskTaolunTag .save(wd)
      AskEditorOperation.save(editor_id, 1, 12, request.request_uri)
      flash[:notice] = "该小区名添加成功！"
    end
    redirect_to :action => 'zomelist'
  end
  
  def top
    @names = AskTaolunTag.find(:all, :select => "id, name")
  end
  
  def xiaoqu_list
    @topic_pages, @topics = paginate(:ask_taolun_topics, :select => "id, subject,is_top", 
      :conditions => ["area_id = ?  and tag_id = ?", 1,params[:id]], 
      :order => 'id DESC', 
      :per_page => 5)
    session[:p] = params[:id]
    render :partial => 'admin/top/xiaoqu_list', :layout => true
  end
    
  def gu_top
    if strip(params[:id]) and strip(params[:id])!= ""  
      re = strip(params[:id])
      editor_id = get_user_id_by_cookie_name()
      res =AskTaolunTopic.gu_top(re,editor_id)
      AskEditorOperation.save(editor_id, 1, 13, request.request_uri)
      flash[:notice] = "该贴设置固顶成功！"
    end
    redirect_to :controller => "admin", :action => "xiaoqu_list", :id => session[:p]
  end
  
  def zhi_top
    if strip(params[:id]) and strip(params[:id])!= ""  
      re = strip(params[:id])
      editor_id = get_user_id_by_cookie_name()
      res =AskTaolunTopic.zhi_top(re,editor_id)
      AskEditorOperation.save(editor_id, 1, 14, request.request_uri)
      flash[:notice] = "该贴设置置顶成功！"
    end
    redirect_to :controller => "admin", :action => "xiaoqu_list", :id => session[:p]
  end
     
  def cancel_top
    if strip(params[:id]) and strip(params[:id])!= ""  
      re = strip(params[:id])
      editor_id = get_user_id_by_cookie_name()
      res =AskTaolunTopic.cancel_top(re,editor_id)
      AskEditorOperation.save(editor_id, 1, 15, request.request_uri)
      flash[:notice] = "取消该贴特权成功！"
    end
    redirect_to :controller => "admin", :action => "xiaoqu_list", :id => session[:p]
  end
 
  def bugaolist
    @bugao_pages, @bugaos = paginate(:ask_editor_choice, :select => "id, title,url,order_number", 
      :order => 'order_number DESC', 
      :per_page => 5)
  end
  
  def addbugao
    if strip(params[:ti])  
      ti = strip(params[:ti]).to_s
      if strip(params[:wd])
        wd = strip(params[:wd])
        if strip(params[:data])
          data = strip(params[:data]) 
          editor_id = get_user_id_by_cookie_name()
          AskEditorChoice.save(ti,wd,data,editor_id)
          AskEditorOperation.save(editor_id, 1, 16, request.request_uri)
          flash[:notice] = "上传公告，成功!"
        end
      end
    end
    redirect_to :action => 'bugaolist'
  end
  
  def delete_bugao
    if strip(params[:id]) and strip(params[:id])!= ""  
      re = strip(params[:id])
      editor_id = get_user_id_by_cookie_name()
      res = AskEditorChoice.destroy(re)
      AskEditorOperation.save(editor_id, 1, 17, request.request_uri)
    end
    redirect_to :action => 'bugaolist'
  end
 
  def edit_bugao
    @bugao = AskEditorChoice.find(:first, :select => "id, title, url,order_number ",
      :conditions => ["id = ?", params[:id]])
  end
 
  def update_bugao
    if strip(params[:ti])  
      ti = strip(params[:ti]).to_s
      if strip(params[:li])  
        li = strip(params[:li]).to_s 
        if strip(params[:data])  
          data = strip(params[:data]).to_s
          if strip(params[:tid])  
            tid = strip(params[:tid]).to_i
            editor_id = get_user_id_by_cookie_name()
            AskEditorChoice.edit(tid,ti,li,data)
            AskEditorOperation.save(editor_id, 1, 18, request.request_uri)
            flash[:notice] = '公告更新成功!'
          end
        end
      end
    end
    redirect_to :action => 'bugaolist'
  end
  
  def statistics                      #统计操作
    if strip(params[:wd]) and strip(params[:wd])!= ""  #关键词非空
      wd = strip(params[:wd])
      tp = strip(params[:tp])
      session[:wd] = strip(params[:wd])
      session[:tp] = strip(params[:tp])
      date1 = params[:date1].to_s
      date2 = params[:date2].to_s
      
      @statistics = AskEditorOperation.find_by_sql("SELECT count(id) as counter
           FROM ask_editor_operations
           WHERE editor_id = '#{wd}' and operation_id = '#{tp}' and project_id = '1' and created_at >= '#{date1} 00:00:00' and created_at <= '#{date2} 23:59:59'")
      render :partial => 'statistics', :layout => true
    end
  end
   
  #    def get_admin_info
  #        @bbs_info = OracleHejiaUserBbs.find(params[:id])
  #        redirect_to :action => 'add_info'
  #       # redirect_to :action => 'add_info'
  #    end
  def list_ask_choice    
  end
  
  # type_id 为0
  def list_published_choice
    @publised_asks = AskEditorChoice.find(:all,:select=>'id,title,url,order_number',
      :conditions=>['type_id = ? and is_valid = ? and order_number > ?',0,1,0],
      :order=>'order_number DESC')
  end
  
  ## type_id 为0
  def create_ask_choice
    ask_id = params[:ask_id]
    order_number = params[:order_number]
    ask = AskZhidaoTopic.find(:first,:select=>'id,subject',:conditions=>['id = ? and is_delete = ?', ask_id, 0])
    if ask.nil?
      flash[:notice] = '帖子不存在'
      redirect_to '/admin/list_ask_choice'
    else
      ask_subject = ask.subject
      editor_id = get_user_id_by_cookie_name
      url = '#{BASEURL}visitor/question/'+ ask_id +'.html'
      topic_id = ask_id
      AskEditorChoice.save(ask_subject, url, order_number, editor_id, topic_id)
      
      redirect_to '/admin/list_published_choice'
    end
  end
  
  def save_published_choice
    publish_ids = params[:c_publish_id]
    order_numbers = params[:c_order_number]
    i = 0
    publish_ids.each do |publish_id|
      AskEditorChoice.update_all("order_number = "+ order_numbers[i], "id = " + publish_id)
      i += 1
    end
    redirect_to '/admin/list_published_choice'
  end
  
    
  private
  def get_user_id_by_user_name(user_name)
    @bbs = HejiaUserBbs.find(:first, :select => "userbbsid, username", :conditions => ["username = ?", user_name])
    if @bbs.nil?
      flash[:now] = "专家不存在"
      0
    else
      @bbs.userbbsid
    end
  end
        
end