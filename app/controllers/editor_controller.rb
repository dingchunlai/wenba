class EditorController < ApplicationController
 before_filter :is_editor
  
  in_place_edit_for :ask_zhidao_topic, :subject
  in_place_edit_for :ask_zhidao_topic_post, :content
  
  #  上传文件
  def upload
    @upload = AskZhidaoEditorUpload.new
  end
  
  #  解析上传的文件，往数据库插值
  def analyze
    @upload = AskZhidaoEditorUpload.new(params[:ask_zhidao_editor_upload])
    if @upload.save
      filename = "public" + @upload.public_filename()
      editor_id = get_user_id_by_cookie_name()
      begin
        batch(filename, editor_id)
        @upload.update_attribute("editor_id", editor_id)
        @upload.update_attribute("flag", 1)
        AskEditorOperation.save(editor_id, 1, 8, request.request_uri)
        flash[:notice] = '文件上传成功'
        redirect_to :action => "untaggable"
      rescue
        flash[:notice] = '文件内容有误，请重新编辑'
      end
    else
      flash[:notice] = '文件上传失败'
    end
  end
  
  #  未分配问题
  def undistributed
    editor_id = get_user_id_by_cookie_name()
    
    @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject", 
      :conditions => ["area_id = ? and method = ? and is_delete = ? and is_distribute = ? and editor_id = ?", 1, 2, 0, 0, editor_id], 
      :order => 'id DESC', 
      :per_page => 10)
  end
  
  #  保存分配的问题
  def save
    if params[:topics]
      editor_id = get_user_id_by_cookie_name()
      params[:topics].each do |topic|
        AskZhidaoEditorTopic.save_distributed_topic(editor_id, topic.to_i)
      end
      redirect_to :action => "undistributed"
    else
      redirect_to :action => "undistributed"
    end
    if params[:tags]
      #
    end
  end
  
  def distributed
    
  end
  
  #  显示问答--答案
  def show_answer
    zhidao_topic_id = params["id"]
    @post = AskZhidaoTopicPost.find(:first, :select => "id, content",
      :conditions => ["method = ? and zhidao_topic_id = ?", 2, zhidao_topic_id])
  end
  
  #  显示问答--标签
  def show_tags
    zhidao_topic_id = params["id"]
    @post = AskZhidaoTopicPost.find(:first, :select => "id, content",
      :conditions => ["method = ? and zhidao_topic_id = ?", 2, zhidao_topic_id])
  end
  
  #  未打标签
  def untaggable
    @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject", 
      :conditions => ["area_id = ? and is_delete = ? and tag_id is null", 1, 0], 
      :order => 'id DESC', 
      :per_page => 20)
  end
  
  #  打上标签
  def taggable
    tag1 = params[:ClassLevel1]
    tag2 = params[:ClassLevel2]
    tag3 = params[:ClassLevel3]
    
    tag2 = 0 if params[:ClassLevel2] == ""
    tag3 = 0 if params[:ClassLevel3] == ""
    
    tag_id = tag1 if (tag2 == 0) and (tag3 == 0)
    tag_id = tag2 if (tag2 != 0) and (tag3 == 0)
    tag_id = tag3 if (tag2 != 0) and (tag3 != 0)
    
    topic_id = params[:tid].to_i
    tag_id = tag_id.to_i
    #    title = strip(params[:ti].to_s)
    #    description = strip(params[:co].to_s)
    #    user_tags = strip(params[:ut].to_s)
    if tag_id > 0
      editor_id = get_user_id_by_cookie_name()
      AskZhidaoTopic.taggable(topic_id, tag_id, editor_id)
      AskEditorOperation.save(editor_id, 1, 3, request.request_uri)
    end
    redirect_to :controller => "editor", :action => "untaggable"
  end
  
  #  显示
  #  tp
  #  为ut时表示未打标签
  def show
    if params[:tp]      #未打标签
      if params[:tp].to_s == "ut"
        @topic_id = params[:id].to_i
        @topic = AskZhidaoTopic.find(:first, :select => "id, subject, description",
          :conditions => ["id = ?", @topic_id])
        render :partial => 'show_untaggable_topic', :layout => true
      end  
    else
      #
    end  
  end
  
  def search
    if params[:tp].to_s == "wd"
      date1 = params[:date1].to_s
      date2 = params[:date2].to_s
      session[:date1] = date1
      session[:date2] = date2
      @keywords = AskSearchKeyword.find_by_sql("SELECT keyword, count(keyword) as counter 
                              FROM ask_search_keywords 
                              WHERE area_id = 1 and type_id = 1 and created_at >= '#{date1} 00:00:00' and created_at <= '#{date2} 23:59:59'  
                              GROUP BY keyword ORDER BY counter DESC LIMIT 10") 
      render :partial => 'editor/search_keyword/results', :layout => true
    end
  end
  
  def delete
    if strip(params[:wd]) and strip(params[:wd])!= ""  #关键词非空
      wd = strip(params[:wd])
      editor_id = get_user_id_by_cookie_name()
      @ids = AskZhidaoTopic.find(:all, :select => "id", 
        :conditions => ["id = ?", wd])
      if @ids.size == 1
        AskZhidaoTopic.delete(wd,editor_id)
        AskEditorOperation.save(editor_id, 1, 4, request.request_uri)
        flash[:notice] = "对应文章删除完成！"
      else
        flash[:notice] = "没有相对应的文章！"
      end
      render :partial => 'editor/delete_wenzhang/delete', :layout => true
    end
  end
  
  def showtoday
    date1 = params[:date1].to_s
    date2 = params[:date2].to_s
    session[:date1] = date1
    session[:date2] = date2
    @topic_pages, @subjects = paginate(:ask_zhidao_topics, :select => "id,subject,user_id,created_at,ip", 
      :conditions => ["area_id = ? and user_id >= 0 and tag_id > 0 and is_delete = ? and method = ? and created_at >= '#{date1} 00:00:00' and created_at <= '#{date2} 23:59:59'",1,0,3], 
      :order => 'id DESC', 
      :per_page => 10) 
    render :partial => 'editor/showtoday/showtoday', :layout => true
  end
  
  def del_wenzhang
    if strip(params[:wd]) and strip(params[:wd])!= ""  
      wd = strip(params[:wd])
      editor_id = get_user_id_by_cookie_name()
      @ids = AskZhidaoTopic.find(:all, :select => "id", 
        :conditions => ["user_id = ?", wd])
      @ids1 = AskZhidaoTopicPost.find(:all, :select => "id", 
        :conditions => ["user_id = ?", wd])
      #      if params[:tp].to_s == "wd1"
      #        if @ids1.size >= 1
      #          AskZhidaoTopicPost.del_post(wd,editor_id)
      #          flash[:notice] = "该用户的回复删除完成！"  
      #        else
      #          flash[:notice] = "没有相对应的用户编号！"
      #        end
      #      end
      if params[:tp].to_s == "wd2"
        if @ids.size >= 1 || @ids1.size  >= 1
          AskZhidaoTopic.update(wd,editor_id)
          AskZhidaoTopicPost.del_post(wd,editor_id)
          AskEditorOperation.save(editor_id, 1, 5, request.request_uri)
          flash[:notice] = "该用户的帖子和回复删除完成！"  
        else
          flash[:notice] = "没有相对应的用户编号！"
        end
      end
      render :partial => 'editor/delete_huifu/dele', :layout => true
    end
  end
  
  def piliang_tag
    @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject", 
      :conditions => ["area_id = ? and is_delete = ? and tag_id is null", 1, 0], 
      :order => 'id DESC', 
      :per_page => 20)
  end
  
  def piliang_tagable  #批量打标签
    tag1 = params[:ClassLevel1]
    tag2 = params[:ClassLevel2]
    tag3 = params[:ClassLevel3]
    
    tag2 = 0 if params[:ClassLevel2] == ""
    tag3 = 0 if params[:ClassLevel3] == ""
    
    tag_id = tag1 if (tag2 == 0) and (tag3 == 0)
    tag_id = tag2 if (tag2 != 0) and (tag3 == 0)
    tag_id = tag3 if (tag2 != 0) and (tag3 != 0)
    
    #    topic_id = params[:tid].to_i
    tag_id = tag_id.to_i
    if tag_id > 0
      if params[:topics]
        editor_id = get_user_id_by_cookie_name()
        params[:topics].each do |topic|
          AskZhidaoTopic.piliang_tag(topic.to_i, tag_id, editor_id)
          AskEditorOperation.save(editor_id, 1, 2, request.request_uri)
        end
      end
    end
    redirect_to :controller => "editor", :action => "piliang_tag"
  end
  
  def delete_p
    if strip(params[:wd]) and strip(params[:wd])!= ""  
      wd = strip(params[:wd]).to_i
      @topics = AskZhidaoTopic.find(:all, :select => "id, subject", 
        :conditions => ["id = ?", wd])
      @posts = AskZhidaoTopicPost.find(:all, :select => "id, content",
        :conditions => ["zhidao_topic_id = ? and is_delete = ? ", wd, 0])
    end
    render :partial => 'editor/del_huifu/delete_p', :layout => true
  end 
   
  def del_huifu
    if params[:posts]
      editor_id = get_user_id_by_cookie_name()
      params[:posts].each do |post|
        AskZhidaoTopicPost.delete_post(post.to_i, editor_id)
        AskEditorOperation.save(editor_id, 1, 6, request.request_uri)
      end
      flash[:notice] = "删除对应的回复，成功!"
    end
    render :partial => 'editor/del_huifu/tishi', :layout => true
  end
  
  def del_ip
    if strip(params[:wd]) and strip(params[:wd])!= ""  
      user_id = get_user_id_by_user_name(strip(iconv_utf8(params[:wd])))
      if user_id == 0 
        flash[:now] = "用户不存在"
      end
    end
  end
  
  def delete_ip
    if strip(params[:wd]) and strip(params[:wd])!= ""  
      user_id = get_user_id_by_user_name(strip(iconv_utf8(params[:wd])))
      editor_id = get_user_id_by_cookie_name()
      if user_id != 0
        @topics = AskZhidaoTopic.find(:all, :select => "DISTINCT ip", 
          :conditions => ["user_id = ?", user_id])
        if @topics.size > 0
          0.upto(@topics.size-1) do |i|
            if @topics[i].ip != nil
              AskBlockedIp.save(@topics[i].ip)
              AskEditorOperation.save(editor_id, 1, 7, request.request_uri)
            end
          end
        end
        @posts = AskZhidaoTopicPost.find(:all, :select => "DISTINCT ip",
          :conditions => ["user_id = ?", user_id])
        if @posts.size > 0
          0.upto(@posts.size-1) do |i|
            if @posts[i].ip != nil
              AskBlockedIp.save(@posts[i].ip)
              AskEditorOperation.save(editor_id, 1, 7, request.request_uri)
            end
          end
        end
        flash[:notice] = "添加用户进黑名单，成功!"
      end
    end
    render :partial => 'editor/delete_ip/tishia', :layout => true
  end
  
  def showwenzhang
    if strip(params[:wd]) and strip(params[:wd])!= ""  
      wd = strip(params[:wd]).to_i
      @topics = AskZhidaoTopic.find(:all, :select => "user_id,subject,ip", 
        :conditions => ["id = ?", wd])
      @posts = AskZhidaoTopicPost.find(:all, :select => "user_id,id,content,ip",
        :conditions => ["zhidao_topic_id = ?", wd])
    end
    render :partial => 'editor/del_ip/showwenzhang', :layout => true
  end
  
  def delete_allip
    if params[:topics]
      #      editor_id = get_user_id_by_cookie_name()
      params[:topics].each do |topic|
        AskBlockedIp.save(topic)
      end
    end
    if params[:posts]
      #      editor_id = get_user_id_by_cookie_name()
      params[:posts].each do |post|
        AskBlockedIp.save(post)
      end
    end
    flash[:notice] = "添加发帖/回复人到黑名单，成功!"
    render :partial => 'editor/del_ip/tishib', :layout => true
  end
  
  def list
    if strip(params[:wd]) and strip(params[:wd])!= ""  
      wd = strip(params[:wd]).to_i
      @topic = AskZhidaoTopic.find(:first, :select => "id,subject,created_at,editor_id", 
        :conditions => ["id = ?", wd])
      @post = AskZhidaoTopicPost.find(:first, :select => "id,content",
        :conditions => ["zhidao_topic_id = ?", wd])
    end
    render :partial => 'editor/xiugai/list', :layout => true
  end
  
  def update_post
    if strip(params[:ti])  
      ti = strip(params[:ti]).to_s
      if strip(params[:time])
        time = strip(params[:time])
        if strip(params[:tid])  
          tid = strip(params[:tid]).to_i 
          editor = get_user_id_by_cookie_name()
          AskZhidaoTopic.edit_wenzhang(tid,ti,time,editor)
          flash[:notice] = "修改帖子消息，成功!"
        end
      end
    end
    render :partial => 'editor/xiugai/notice', :layout => true 
  end
  
  def unsolution
    @topic_pages, @topics = paginate(:ask_zhidao_topics, :select => "id, subject", 
      :conditions => ["area_id = ? and user_id > 0 and tag_id > 0 and is_delete = ? and best_post_id is null", 1, 0],
      :order => 'id DESC', 
      :per_page => 12)
  end
  
  def solution  #设置最佳答案
    if params[:post]
      params[:post].split("#").collect{ |p| 
        if p.size > 1
          zhidao_topic_id = p[0].to_i
          best_post_id = p[1].to_i
          editor_id = get_user_id_by_cookie_name()
          AskZhidaoTopic.best_post_for_editor(zhidao_topic_id, best_post_id, editor_id)
          AskEditorOperation.save(editor_id, 1, 1, request.request_uri)
        end
      }
    end
    redirect_to :controller => "editor", :action => "unsolution"
  end


  ################################################################ 百科 wiki#################################################################
  #百科列表
  def list_wiki
    @wikis = AskWikiContent.find(:all,:conditions=>["is_delete = 0"])
  end

  def show_wiki_content
    content_id = params[:content_id]
    @wiki_content = AskWikiContent.find(:first,:conditions=>["is_delete = 0 and id = ?",content_id])
  end

  #增加百科
  def add_wiki
    #
  end
  
  #保存增加的百科
  def save_wiki
    content_name = strip(params[:wn])
    editor_id = get_user_id_by_cookie_name
    tag = strip(params[:tag])
    if content_name!=''
      AskWikiContent.save(content_name, tag, editor_id)
      flash[:notice] = "增加百科成功！"
      redirect_to :action => "list_wiki"
    else  
      flash[:notice] = "*号为必填！"
      redirect_to :action => "add_wiki"
    end
  end
  
  #百科目录显示
  def list_wiki_catalog
    @content_id = params[:content_id]
    @wiki_content = AskWikiContent.find(:firsts, :conditions => ["id = ? and is_delete = 0",@content_id])
  end
  
  #增加百科目录
  def add_wiki_catalog
    @content_id = params[:content_id]
    @wiki_content = AskWikiContent.find(@content_id)
    
    @wiki_catalogs = AskWikiCatalog.find(:all,:conditions=>["content_id = ? and is_delete = 0",@content_id])
  end

  def save_wiki_catalog
    content_id = params[:content_id]
    catalog_name = params[:catalog]
    editor_id = get_user_id_by_cookie_name

    AskWikiCatalog.save(content_id, catalog_name, editor_id)
    redirect_to :action=>'add_wiki_catalog', :content_id => content_id
  end
  
  #百科知识列表
  def list_wiki_descript
    @wc_id = params[:wc_id]
    wiki = WikiContent.find(:first, :conditions => ["id = ? and is_delete = 0",@wc_id])
    @wiki_name = wiki.name
    @descripts = WikiDescript.find(:all, :conditions => ["content_id = ? and is_delete = 0",@wc_id])
  end
  
  #增加百科知识
  def add_wiki_item
    @content_id = params[:content_id]
    @catalog_id = params[:catalog_id]
   
    @wiki_content = AskWikiContent.find(@content_id)
    @wiki_catalog = AskWikiCatalog.find(@catalog_id)
    @wiki_items = AskWikiItem.find(:all,:conditions=>["is_delete = 0 and catalog_id = ?",@catalog_id])
  end
  
  #保存增加的百科知识
  def save_wiki_item
    content_id = params[:content_id]
    catalog_id = params[:catalog_id]
    editor_id = get_user_id_by_cookie_name

    title = strip(params[:title])
    description = strip(params[:description])
    if !title.eql?("") and !description.eql?("")
      AskWikiItem.save(title, description, content_id, catalog_id, editor_id)
      flash[:notice] = "增加知识成功！"
      redirect_to :action => "add_wiki_item", :content_id => content_id, :catalog_id => catalog_id
    else  
      flash[:notice] = "*号为必填！"
      redirect_to :action => "add_wiki_item", :content_id => content_id, :catalog_id => catalog_id
    end
  end
  
  #修改百科
  def modify_wiki
    @content_id = params[:content_id]
    @wiki_content = AskWikiContent.find(@content_id)
  end

  def save_modify_wiki
    content_id = params[:content_id]
    content_name = params[:wn]
    tag = params[:tag]
    #editor_id = get_user_id_by_cookie_name
    if !content_name.eql?("")
      AskWikiContent.modify(content_id, content_name, tag)
      redirect_to :action => "list_wiki"
    else
      flash[:notice] = "百科名称不能为空"
      redirect_to :action => "modify_wiki", :content_id => content_id
    end
  end
  
  #删除百科
  def del_wiki
    AskWikiContent.find(params[:content_id]).update_attribute("is_delete", 1)
    redirect_to :action => "list_wiki"
  end
  
  #修改百科目录名称
  def modify_wiki_catalog
    @content_id = params[:content_id]
    @catalog_id = params[:catalog_id]
    @catalog = AskWikiCatalog.find(:first, :conditions => ["id = ? and is_delete = 0",@catalog_id])
  end
  
  #保存修改的百科目录名称
  def save_modify_wiki_catalog
    content_id = params[:content_id]
    catalog_id = params[:catalog_id]
    catalog_name = params[:catalog_name]
    if !catalog_name.eql?("")
      AskWikiCatalog.modify(catalog_id, catalog_name)
      flash[:notice] = "编辑成功！"
      redirect_to :action=>'add_wiki_catalog', :content_id => content_id
    else
      flash[:notice] = "目录不能为空！"
      redirect_to :action => "modify_wiki_catalog", :content_id => content_id, :catalog_id => catalog_id
    end
  end
  
  #删除百科目录
  def del_wiki_catalog
    catalog_id = params[:catalog_id]
    content_id = params[:content_id]
    AskWikiCatalog.find(catalog_id).update_attribute("is_delete", 1)

    redirect_to :action=>'add_wiki_catalog', :content_id => content_id
  end
  
  #修改百科知识
  def modify_wiki_item
    @content_id = params[:content_id]
    @catalog_id = params[:catalog_id]
    @item_id = params[:item_id]
    @wiki_item = AskWikiItem.find(:first,:conditions=>["is_delete = 0 and id = ?",@item_id])
  end
  
  #保存修改的百科知识
  def save_modify_wiki_item
    item_id = params[:item_id]
    title = strip(params[:title])
    description = strip(params[:description])
    wiki_item = AskWikiItem.find(:first, :conditions => ["id = ? and is_delete = 0",item_id])
    if !title.eql?("") and !description.eql?("")
      AskWikiItem.modify(item_id, title, description)
      flash[:notice] = "编辑成功！"
      redirect_to :action => "add_wiki_item" , :content_id => wiki_item.content_id, :catalog_id => wiki_item.catalog_id
    else
      flash[:notice] = "不能为空！"
      redirect_to :action => "modify_wiki_item" , :content_id => wiki_item.content_id, :catalog_id => wiki_item.catalog_id, :item_id => wiki_item.id
    end
  end
  
  #删除百科知识
  def del_wiki_item
    content_id = params[:content_id]
    catalog_id = params[:catalog_id]
    item_id = params[:item_id]
    AskWikiItem.find(item_id).update_attribute("is_delete", "1")

    redirect_to :action => "add_wiki_item" , :content_id => content_id, :catalog_id => catalog_id
  end

  def list_moderator
    @moderators = AskZhidaoAdmin.find(:all, :conditions=>['is_delete = 0'],:order=>'id')
  end

  # 新增加版主
  def new_moderator
    @moderator = AskZhidaoAdmin.new
  end

  def create_moderator
    username = iconv_gb2312(params[:username])
    user = HejiaUserBbs.find(:first, :select =>'userbbsid',
      :conditions =>["username= ?",username])
    if user.nil?
      flash[:notice] = "对不起，用户名不存在"
      redirect_to "/editor/new_moderator"
    else
      user_id = user.userbbsid
      editor_id = get_user_id_by_cookie_name
      AskZhidaoAdmin.save(user_id, editor_id)
      AskEditorOperation.save(editor_id,3, 18, request.request_uri)
      redirect_to '/editor/list_moderator'
    end
  end

  def delete_moderator
    mid = params[:id].to_i
    editor_id = get_user_id_by_cookie_name

    AskZhidaoAdmin.find(mid).update_attributes(:is_delete=>'1', :editor_id=>editor_id)

    AskEditorOperation.save(editor_id,3, 19, request.request_uri)
    redirect_to '/editor/list_moderator'
  end
  
  private
  def batch(filename, editor_id)
    log = File.open(filename)
    YAML::load_documents(log) { |doc|
      puts doc['QT']
      doc['QT'] = iconv_gb18030(doc['QT'])
      doc['QD'] = iconv_gb18030(doc['QD'])
      doc['A'] = iconv_gb18030(doc['A'])
      doc['T'] = iconv_gb18030(doc['T'])
      Ask.insert_data_to_ask_db(doc['QT'], doc['QD'], doc['A'], doc['T'], editor_id)
    }
  end
  
  def get_user_id_by_user_name(user_name)
    @bbs = HejiaUserBbs.find(:first, :select => "userbbsid, username", :conditions => ["username = ?", user_name])
    if @bbs.nil?
      user_id = 0
      #      flash[:now] = "用户不存在"
    else
      user_id = @bbs.userbbsid
    end
    return user_id
  end
  
end