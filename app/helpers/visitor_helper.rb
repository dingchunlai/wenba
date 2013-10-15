module VisitorHelper
  def get_wiki_catalog_name_by_item_id(item_id)
    catalog_id = AskWikiItem.find(item_id).catalog_id
    AskWikiCatalog.find(catalog_id).catalog_name
  end

  def get_wiki_item_names_by_item_id(item_id)
    catalog_id = AskWikiItem.find(item_id).catalog_id
    @wiki_items = AskWikiItem.find(:all,:conditions=>["catalog_id = ?",catalog_id])
  end
  
  def get_tag_name_by_tag_id(tag_id)
    #    tag_name = Tag.find(:first, :select => "name", :conditions => ["id = ?", tag_id]).name
    tag_name = Tag.get_cache(tag_id).name
    return tag_name
  end
  
  def get_tag_name_by_tag_id_for_discussion(tag_id)
    tag_name = AskTaolunTag.find(:first, :select => "name", :conditions => ["id = ?", tag_id]).name
    return tag_name
  end
  
  def get_html_of_question_state_by_topic_id(topic_id)
    html_of_question_state = ""
    best_post_id = AskZhidaoTopic.find(:first, :select => "best_post_id",
      :conditions => ["id = ?", topic_id]).best_post_id
    if best_post_id.nil?  #未解决
      html_of_question_state = "<img src=\"http://www.51hejia.com/images/wenba/daijj.gif\" />"
    else  #已解决
      html_of_question_state = "<img src=\"http://www.51hejia.com/images/wenba/yjj.gif\"/>"
    end
    return html_of_question_state
  end
  
  def get_user_tag_name_by_user_tag_id(user_tag_id)
    user_tag_name = AskUserTag.find(:first, :select => "name", :conditions => ["id = ?", user_tag_id]).name
    return user_tag_name
  end
  
  def get_html_of_user_tags_by_topic_id(topic_id)  #知道
    html_of_user_tags = ""
    @ask_topic_user_tags = AskTopicUserTag.find(:all, :select => "DISTINCT user_tag_id",
      :conditions => ["topic_id = ? and topic_type_id = ?", topic_id, 1])
    if @ask_topic_user_tags
      @ask_topic_user_tags.each { |ask_topic_user_tag|
        user_tag_name = get_user_tag_name_by_user_tag_id(ask_topic_user_tag.user_tag_id)
        html_of_user_tags = html_of_user_tags + "<a href=\"/visitor/ut/#{ask_topic_user_tag.user_tag_id}.html\" target=\"_blank\">" + user_tag_name + "</a>" + "&nbsp;"
      }      
    end
    return html_of_user_tags
  end
  
  def get_html_of_user_tags_by_zhishi_topic_id(zhishi_topic_id)  #知识（分享）
    html_of_user_tags = ""
    @ask_topic_user_tags = AskTopicUserTag.find(:all, :select => "DISTINCT user_tag_id",
      :conditions => ["topic_id = ? and topic_type_id = ?", zhishi_topic_id, 2])
    if @ask_topic_user_tags
      @ask_topic_user_tags.each { |ask_topic_user_tag|
        user_tag_name = get_user_tag_name_by_user_tag_id(ask_topic_user_tag.user_tag_id)
        html_of_user_tags = html_of_user_tags + "<a href=\"/visitor/entryut/#{ask_topic_user_tag.user_tag_id}.html\" target=\"_blank\">" + user_tag_name + "</a>" + "&nbsp;"
      }      
    end
    return html_of_user_tags
  end
  
  def get_html_of_user_tags_by_taolun_topic_id(taolun_topic_id)  #讨论
    html_of_user_tags = ""
    @ask_topic_user_tags = AskTopicUserTag.find(:all, :select => "DISTINCT user_tag_id",
      :conditions => ["topic_id = ? and topic_type_id = ?", taolun_topic_id, 2])
    if @ask_topic_user_tags
      @ask_topic_user_tags.each { |ask_topic_user_tag|
        user_tag_name = get_user_tag_name_by_user_tag_id(ask_topic_user_tag.user_tag_id)
        html_of_user_tags = html_of_user_tags + "<a href=\"/visitor/discussionut/#{ask_topic_user_tag.user_tag_id}.html\" target=\"_blank\">" + user_tag_name + "</a>" + "&nbsp;"
      }      
    end
    return html_of_user_tags
  end
  
  def get_html_of_question_navigation_by_tag_id(tag_id)  #知道
    html_of_question_navigation = "<span class=\"location\">您现在的位置：</span><a href=\"http://www.51hejia.com\">和家首页</a> > " + 
      "<a href=\"#{BASEURL}\">问吧</a> > "
    parent_id = Tag.find(:first, :select => "parent_id",
      :conditions => ["id = ?", tag_id]).parent_id
    if parent_id  #二级或三次目录的情况
      parent_parent_id = Tag.find(:first, :select => "parent_id",
        :conditions => ["id = ?", parent_id]).parent_id
      if parent_parent_id  #三级目录的情况
        html_of_question_navigation = html_of_question_navigation + "<a href=\"#{get_link_of_tag(parent_parent_id)}\" > " + get_tag_name_by_tag_id(parent_parent_id) + "</a>" + " > " +
          "<a href=\"#{get_link_of_tag(parent_id)}\" > " + get_tag_name_by_tag_id(parent_id) + "</a>" + " > " +
          "<a href=\"#{get_link_of_tag(tag_id)}\" > " + get_tag_name_by_tag_id(tag_id) + "</a>" + " > "
      else  #二级目录的情况
        html_of_question_navigation = html_of_question_navigation + "<a href=\"#{get_link_of_tag(parent_id)}\" > " + get_tag_name_by_tag_id(parent_id) + "</a>" + " > " + 
          "<a href=\"#{get_link_of_tag(tag_id)}\" > " + get_tag_name_by_tag_id(tag_id) + "</a>" + " > "
      end
    else  #一级目录的情况
      html_of_question_navigation = html_of_question_navigation + "<a href=\"#{get_link_of_tag(tag_id)}\" > " + get_tag_name_by_tag_id(tag_id) + "</a>" + " > "
    end
    return html_of_question_navigation
  end
  
  def get_html_of_question_navigation_by_tag_id_for_share(tag_id)  #知识（分享）
    html_of_question_navigation = "<span class=\"location\">您现在的位置：</span><a href=\"http://www.51hejia.com\">和家首页</a> > " + 
      "<a href=\"#{BASEURL}\">问吧</a> > "
    parent_id = Tag.find(:first, :select => "parent_id",
      :conditions => ["id = ?", tag_id]).parent_id
    if parent_id  #二级或三次目录的情况
      parent_parent_id = Tag.find(:first, :select => "parent_id",
        :conditions => ["id = ?", parent_id]).parent_id
      if parent_parent_id  #三级目录的情况
        html_of_question_navigation = html_of_question_navigation + "<a href=\"#{get_link_of_tag_for_share(parent_parent_id)}\" > " + get_tag_name_by_tag_id(parent_parent_id) + "</a>" + " > " +
          "<a href=\"#{get_link_of_tag_for_share(parent_id)}\" > " + get_tag_name_by_tag_id(parent_id) + "</a>" + " > " +
          "<a href=\"#{get_link_of_tag_for_share(tag_id)}\" > " + get_tag_name_by_tag_id(tag_id) + "</a>" + " > "
      else  #二级目录的情况
        html_of_question_navigation = html_of_question_navigation + "<a href=\"#{get_link_of_tag_for_share(parent_id)}\" > " + get_tag_name_by_tag_id(parent_id) + "</a>" + " > " + 
          "<a href=\"#{get_link_of_tag_for_share(tag_id)}\" > " + get_tag_name_by_tag_id(tag_id) + "</a>" + " > "
      end
    else  #一级目录的情况
      html_of_question_navigation = html_of_question_navigation + "<a href=\"#{get_link_of_tag_for_share(tag_id)}\" > " + get_tag_name_by_tag_id(tag_id) + "</a>" + " > "
    end
    return html_of_question_navigation
  end
  
  def get_html_of_question_navigation_by_tag_id_for_discussion(tag_id)  #讨论
    html_of_question_navigation = "<span class=\"location\">您现在的位置：</span><a href=\"http://www.51hejia.com\">和家首页</a> > " + 
      "<a href=\"#{BASEURL}\">问吧</a> > "
    tag_name = AskTaolunTag.find(:first, :select => "id,name",
      :conditions => ["id = ?", tag_id]).name
    html_of_question_navigation = html_of_question_navigation + "<a href=\"#{get_link_of_tag_for_discussion(tag_id)}\" > " + get_tag_name_by_tag_id_for_discussion(tag_id) + "</a>" + " > "
    return html_of_question_navigation
  end
  
  def get_html_of_tags_navigation_by_tag_id(tag_id)
    html_of_tags_navigation = ""
    parent_id = Tag.find(:first, :select => "parent_id",
      :conditions => ["id = ?", tag_id]).parent_id
    if parent_id  #二级或三次目录的情况
      parent_parent_id = Tag.find(:first, :select => "parent_id",
        :conditions => ["id = ?", parent_id]).parent_id
      if parent_parent_id  #三级目录的情况
        html_of_tags_navigation = "<a href=\"#{get_link_of_tag(parent_parent_id)}\">" + get_tag_name_by_tag_id(parent_parent_id) + "</a>" + ">" +
          "<a href=\"#{get_link_of_tag(parent_id)}\">" + get_tag_name_by_tag_id(parent_id) + "</a>" + ">" +
          get_tag_name_by_tag_id(tag_id)
      else  #二级目录的情况
        html_of_tags_navigation = "<a href=\"#{get_link_of_tag(parent_id)}\">" + get_tag_name_by_tag_id(parent_id) + "</a>" + ">" + 
          get_tag_name_by_tag_id(tag_id)
      end
    else  #一级目录的情况
      html_of_tags_navigation = get_tag_name_by_tag_id(tag_id)
    end
    return html_of_tags_navigation
  end
  
  def get_html_of_tags_title_by_tag_id(tag_id)
    html_of_tags_title = ""
    parent_id = Tag.find(:first, :select => "parent_id",
      :conditions => ["id = ?", tag_id]).parent_id
    if parent_id  #父目录的情况
      html_of_tags_title = get_tag_name_by_tag_id(parent_id)
    else  #当前目录的情况
      html_of_tags_title = get_tag_name_by_tag_id(tag_id)
    end
    return html_of_tags_title
  end
  
  def get_html_of_tags_by_tag_id(tag_id)  #知道
    html_of_tags = ""
    parent_id = Tag.find(:first, :select => "parent_id",
      :conditions => ["id = ?", tag_id]).parent_id
    if parent_id  #父目录的情况
      tags = Tag.find(:all, :select => "id",
        :conditions => ["parent_id = ?", parent_id])
      for tag0 in tags
        if tag0.id.to_i == tag_id.to_i
          html_of_tags = html_of_tags + "<li>" +
            get_tag_name_by_tag_id(tag0.id) +
            "<span>(" + get_tags_count_by_tag_id(tag0.id).to_s + ")</span>" + "</li>"
        else
          html_of_tags = html_of_tags + "<li>" + 
            "<a href=\"#{get_link_of_tag(tag0.id)}\" target=\"_blank\" title=\"#{get_tag_name_by_tag_id(tag0.id)}\">" +
            get_tag_name_by_tag_id(tag0.id) + "</a>" +
            "<span>(" + get_tags_count_by_tag_id(tag0.id).to_s + ")</span>" + "</li>"
        end
      end
    else  #当前目录的情况
      tags = Tag.find(:all, :select => "id",
        :conditions => ["parent_id = ?", tag_id])
      for tag1 in tags
        html_of_tags = html_of_tags + "<a href=\"#{get_link_of_tag(tag1.id)}\">" + get_tag_name_by_tag_id(tag1.id) + "</a>" +
          "(" + get_tags_count_by_tag_id(tag1.id).to_s + ")" + " "
      end
    end
    return html_of_tags
  end
  
  def get_html_of_tags_by_tag_id_for_share(tag_id)  #知识（分享）
    html_of_tags = ""
    parent_id = Tag.find(:first, :select => "parent_id",
      :conditions => ["id = ?", tag_id]).parent_id
    if parent_id  #父目录的情况
      tags = Tag.find(:all, :select => "id",
        :conditions => ["parent_id = ?", parent_id])
      for tag0 in tags
        if tag0.id.to_i == tag_id.to_i
          html_of_tags = html_of_tags + "<li>" +
            get_tag_name_by_tag_id(tag0.id) +
            "<span>(" + get_tags_count_by_tag_id_for_share(tag0.id).to_s + ")</span>" + "</li>"
        else
          html_of_tags = html_of_tags + "<li>" + 
            "<a href=\"#{get_link_of_tag_for_share(tag0.id)}\" target=\"_blank\" title=\"#{get_tag_name_by_tag_id(tag0.id)}\">" +
            get_tag_name_by_tag_id(tag0.id) + "</a>" +
            "<span>(" + get_tags_count_by_tag_id_for_share(tag0.id).to_s + ")</span>" + "</li>"
        end
      end
    else  #当前目录的情况
      tags = Tag.find(:all, :select => "id",
        :conditions => ["parent_id = ?", tag_id])
      for tag1 in tags
        html_of_tags = html_of_tags + "<a href=\"#{get_link_of_tag_for_share(tag1.id)}\">" + get_tag_name_by_tag_id(tag1.id) + "</a>" +
          "(" + get_tags_count_by_tag_id_for_share(tag1.id).to_s + ")" + " "
      end
    end
    return html_of_tags
  end
  
  def get_html_of_tags_by_tag_id_for_discussion(tag_id)  #讨论
    html_of_tags = ""
    parent_id = Tag.find(:first, :select => "parent_id",
      :conditions => ["id = ?", tag_id]).parent_id
    if parent_id  #父目录的情况
      tags = Tag.find(:all, :select => "id",
        :conditions => ["parent_id = ?", parent_id])
      for tag0 in tags
        if tag0.id.to_i == tag_id.to_i
          html_of_tags = html_of_tags + "<li>" +
            get_tag_name_by_tag_id(tag0.id) +
            "<span>(" + get_tags_count_by_tag_id_for_discussion(tag0.id).to_s + ")</span>" + "</li>"
        else
          html_of_tags = html_of_tags + "<li>" + 
            "<a href=\"#{get_link_of_tag_for_discussion(tag0.id)}\" target=\"_blank\" title=\"#{get_tag_name_by_tag_id(tag0.id)}\">" +
            get_tag_name_by_tag_id(tag0.id) + "</a>" +
            "<span>(" + get_tags_count_by_tag_id_for_discussion(tag0.id).to_s + ")</span>" + "</li>"
        end
      end
    else  #当前目录的情况
      tags = Tag.find(:all, :select => "id",
        :conditions => ["parent_id = ?", tag_id])
      for tag1 in tags
        html_of_tags = html_of_tags + "<a href=\"#{get_link_of_tag_for_discussion(tag1.id)}\">" + get_tag_name_by_tag_id(tag1.id) + "</a>" +
          "(" + get_tags_count_by_tag_id_for_discussion(tag1.id).to_s + ")" + " "
      end
    end
    return html_of_tags
  end
  
  def get_tags_count_by_tag_id(tag_id)
    tag_ids = get_self_and_children_ids_by_tag_id(tag_id)
    tags_count = AskZhidaoTopic.count :conditions => ["tag_id in (#{tag_ids}) and area_id = ? and user_id >= 0 and is_delete = ?", 1, 0]
    return tags_count
  end
  
  def get_tags_count_by_tag_id_for_share(tag_id)
    tag_ids = get_self_and_children_ids_by_tag_id(tag_id)
    tags_count = AskZhishiTopic.count :conditions => ["tag_id in (#{tag_ids}) and area_id = ? and user_id >= 0 and is_delete = ?", 1, 0]
    return tags_count
  end
  
  def get_tags_count_by_tag_id_for_discussion(tag_id) #讨论
    #    tag_ids = get_self_and_children_ids_by_tag_id(tag_id)
    tags_count = AskTaolunTopic.count :conditions => ["tag_id = #{tag_id} and area_id = ? and user_id >= 0 and is_delete = ?", 1, 0]
    return tags_count
  end
  
  def get_self_and_children_ids_by_tag_id(tag_id)
    children_ids = Tag.find(:all, :select => "id",
      :conditions => ["parent_id = ?", tag_id])
    if children_ids.size > 0  #有子节点的情况
      #二级目录
      children_ids0 = children_ids.collect{|c| c.id}.join(',')
      for child_id in children_ids
        children_children_ids = Tag.find(:all, :select => "id",
          :conditions => ["parent_id = ?", child_id.id])
        if children_children_ids.size > 0  #三级目录
          children_ids0 = children_ids0 + "," + children_children_ids.collect{|c| c.id}.join(',')  
        end
      end
      self_and_children_ids = tag_id.to_s + "," + children_ids0
    else  #无子节点的情况
      self_and_children_ids = tag_id
    end
    return self_and_children_ids
  end
  
  def get_link_of_tag(tag_id)  #知道
    link_of_tag = "/visitor/browse/#{tag_id}.html"
    parent_id = Tag.find(:first, :select => "parent_id",
      :conditions => ["id = ?", tag_id]).parent_id
    if parent_id
      #
    else  #一级目录
      link_of_tag = link_of_tag + "?ct=1"
    end
    return link_of_tag
  end
  
  def get_link_of_tag_for_share(tag_id)  #知识（分享）
    link_of_tag = "/visitor/entrybrowse/#{tag_id}.html"
    #    parent_id = Tag.find(:first, :select => "parent_id",
    #      :conditions => ["id = ?", tag_id]).parent_id
    #    if parent_id
    #      #
    #    else  #一级目录
    #      link_of_tag = link_of_tag + "?ct=1"
    #    end
    return link_of_tag
  end
  
  def get_link_of_tag_for_discussion(tag_id)  #讨论
    link_of_tag = "/visitor/discussionbrowse/#{tag_id}.html"
    #    parent_id = Tag.find(:first, :select => "parent_id",
    #      :conditions => ["id = ?", tag_id]).parent_id
    #    if parent_id
    #      #
    #    else  #一级目录
    #      link_of_tag = link_of_tag + "?ct=1"
    #    end
    return link_of_tag
  end
  
  def get_zhidao_topics_by_tag_id(tag_id)
    tag_ids = get_self_and_children_ids_by_tag_id(tag_id)
    zhidao_topics = AskZhidaoTopic.find(:all, :select => "id, subject, created_at, best_post_id",
      :conditions => ["area_id = ? and user_id >= 0 and tag_id in (#{tag_ids}) and is_delete = ?", 1, 0],
      :order => "id DESC",
      :limit => 6)
    return zhidao_topics
  end
  
  def get_zhidao_topic_post_by_best_post_id(best_post_id)
    zhidao_topic_post = AskZhidaoTopicPost.find(:first, :select => "content, user_id, created_at",
      :conditions => ["id = ?", best_post_id])
    return zhidao_topic_post
  end
  
  def is_best(zhidao_topic_id, post_user_id)
    is_best = nil
    user_id = get_user_id_by_cookie_name()
    if user_id > 0
      azt = AskZhidaoTopic.find(:first, :select => "user_id, best_post_id",
        :conditions => ["id = ? and is_delete = ?", zhidao_topic_id, 0])
      user_id1 = azt.user_id.to_i
      best_post_id = azt.best_post_id
      if user_id1 == user_id and best_post_id.nil? and user_id1 != post_user_id
        is_best = true
      else
        is_best = nil
      end
    else
      is_best = nil
    end
    return is_best
  end
  
  def get_tags_level2_by_tag_level1_id(tag_level1_id)
    tags_level2 = Tag.find(:all, :select => "id, name",
      :conditions => ["parent_id = ?", tag_level1_id])
    return tags_level2
  end
  
  def get_html_of_menu_for_b2list_by_type_id(tag_id)  #知道
    if params[:tp]  #type
      if params[:tp].to_i == 1  #已解决
        html_of_menu = "<a href=\"/visitor/browse/#{tag_id}.html\"><li id=\"s1\" class=\"menu_off\">全部</li></a>" +
          "<a href=\"/visitor/browse/#{tag_id}.html?tp=1\"><li id=\"s2\" class=\"menu_on\">已解决</li></a>" +
          "<a href=\"/visitor/browse/#{tag_id}.html?tp=2\"><li id=\"s3\" class=\"menu_off\">待解决</li></a>"
      end
      if params[:tp].to_i == 2  #待解决
        html_of_menu = "<a href=\"/visitor/browse/#{tag_id}.html\"><li id=\"s1\" class=\"menu_off\">全部</li></a>" +
          "<a href=\"/visitor/browse/#{tag_id}.html?tp=1\"><li id=\"s2\" class=\"menu_off\">已解决</li></a>" +
          "<a href=\"/visitor/browse/#{tag_id}.html?tp=2\"><li id=\"s3\" class=\"menu_on\">待解决</li></a>"
      end
    else
      html_of_menu = "<a href=\"/visitor/browse/#{tag_id}.html\"><li id=\"s1\" class=\"menu_on\">全部</li></a>" +
        "<a href=\"/visitor/browse/#{tag_id}.html?tp=1\"><li id=\"s2\" class=\"menu_off\">已解决</li></a>" +
        "<a href=\"/visitor/browse/#{tag_id}.html?tp=2\"><li id=\"s3\" class=\"menu_off\">待解决</li></a>"
    end
    return html_of_menu
  end
  
  def get_html_of_menu_for_entryb2list_by_type_id(tag_id)  #知识（分享）
    if params[:tp]  #type
      if params[:tp].to_i == 0  #全部
        html_of_menu = "<a href=\"/visitor/entrybrowse/#{tag_id}.html\"><li id=\"s1\" class=\"menu_on\">全部</li></a>"
      end
    else
      html_of_menu = "<a href=\"/visitor/entrybrowse/#{tag_id}.html\"><li id=\"s1\" class=\"menu_on\">全部</li></a>"
    end
    return html_of_menu
  end
  
  def get_html_of_menu_for_discussionb2list_by_type_id(tag_id)  #讨论
    if params[:tp]  #type
      if params[:tp].to_i == 0  #全部
        html_of_menu = "<a href=\"/visitor/discussionbrowse/#{tag_id}.html\"><li id=\"s1\" class=\"menu_on\">全部</li></a>"
      end
    else
      html_of_menu = "<a href=\"/visitor/discussionbrowse/#{tag_id}.html\"><li id=\"s1\" class=\"menu_on\">全部</li></a>"
    end
    return html_of_menu
  end
  
  def get_html_of_menu_for_utlist_by_type_id(tag_id)  #知道
    if params[:tp]  #type
      if params[:tp].to_i == 1  #已解决
        html_of_menu = "<a href=\"/visitor/ut/#{tag_id}.html\"><li id=\"s1\" class=\"menu_off\">全部</li></a>" +
          "<a href=\"/visitor/ut/#{tag_id}.html?tp=1\"><li id=\"s2\" class=\"menu_on\">已解决</li></a>" +
          "<a href=\"/visitor/ut/#{tag_id}.html?tp=2\"><li id=\"s3\" class=\"menu_off\">待解决</li></a>"
      end
      if params[:tp].to_i == 2  #待解决
        html_of_menu = "<a href=\"/visitor/ut/#{tag_id}.html\"><li id=\"s1\" class=\"menu_off\">全部</li></a>" +
          "<a href=\"/visitor/ut/#{tag_id}.html?tp=1\"><li id=\"s2\" class=\"menu_off\">已解决</li></a>" +
          "<a href=\"/visitor/ut/#{tag_id}.html?tp=2\"><li id=\"s3\" class=\"menu_on\">待解决</li></a>"
      end
    else
      html_of_menu = "<a href=\"/visitor/ut/#{tag_id}.html\"><li id=\"s1\" class=\"menu_on\">全部</li></a>" +
        "<a href=\"/visitor/ut/#{tag_id}.html?tp=1\"><li id=\"s2\" class=\"menu_off\">已解决</li></a>" +
        "<a href=\"/visitor/ut/#{tag_id}.html?tp=2\"><li id=\"s3\" class=\"menu_off\">待解决</li></a>"
    end
    return html_of_menu
  end
  
  def get_html_of_menu_for_entryutlist_by_type_id(tag_id)  #知识（分享）
    if params[:tp]  #type
      if params[:tp].to_i == 0  #全部
        html_of_menu = "<a href=\"/visitor/ut/#{tag_id}.html\"><li id=\"s1\" class=\"menu_off\">全部</li></a>"
      end
    else
      html_of_menu = "<a href=\"/visitor/ut/#{tag_id}.html\"><li id=\"s1\" class=\"menu_on\">全部</li></a>"
    end
    return html_of_menu
  end
  
  def get_html_of_menu_for_discussionutlist_by_type_id(tag_id)  #讨论
    if params[:tp]  #type
      if params[:tp].to_i == 0  #全部
        html_of_menu = "<a href=\"/visitor/ut/#{tag_id}.html\"><li id=\"s1\" class=\"menu_off\">全部</li></a>"
      end
    else
      html_of_menu = "<a href=\"/visitor/ut/#{tag_id}.html\"><li id=\"s1\" class=\"menu_on\">全部</li></a>"
    end
    return html_of_menu
  end
  
  def get_html_of_menu_for_search_by_type_id(tag_id)
    if params[:tp]  #type
      if params[:tp].to_i == 1  #已解决
        html_of_menu = "<a href=\"/visitor/s?tp=1&wd=#{u(params[:wd])}\"><li id=\"s2\" class=\"menu_on\">已解决</li></a>" +
          "<a href=\"/visitor/s?tp=2&wd=#{u(params[:wd])}\"><li id=\"s3\" class=\"menu_off\">待解决</li></a>"
      end
      if params[:tp].to_i == 2  #待解决
        html_of_menu = "<a href=\"/visitor/s?tp=1&wd=#{u(params[:wd])}\"><li id=\"s2\" class=\"menu_off\">已解决</li></a>" +
          "<a href=\"/visitor/s?tp=2&wd=#{u(params[:wd])}\"><li id=\"s3\" class=\"menu_on\">待解决</li></a>"
      end
    else
      html_of_menu = "<a href=\"/visitor/s?tp=1&wd=#{u(params[:wd])}\"><li id=\"s2\" class=\"menu_on\">已解决</li></a>" +
        "<a href=\"/visitor/s?tp=2&wd=#{u(params[:wd])}\"><li id=\"s3\" class=\"menu_off\">待解决</li></a>"
    end
    return html_of_menu
  end
    
  def get_html_of_best_post_user_for_b2list_by_best_post_id(best_post_id)
    html_of_best_post_user = ""
    if best_post_id
      best_post_user_id = AskZhidaoTopicPost.find(:first, :select => "user_id",
        :conditions => ["id = ?", best_post_id]).user_id
      html_of_best_post_user = "最佳答案贡献者：<a href=\"http://blog.51hejia.com/u/#{best_post_user_id}\" target=\"_blank\">#{get_user_name_by_user_id(best_post_user_id)}</a>"
    end
    return html_of_best_post_user
  end
  
  def get_html_of_user_sign_by_user_id(user_id)
    html_of_user_sign = ""
    #如果是专家，显示签名档
    begin
      if get_admin_by_user_id(user_id)
        html_of_user_sign = "<div class=\"qianming\">
      <h5>签名档</h5>
          <ul>
            <li>QQ：#{get_admin_info_by_user_id(user_id).qq}</li>
            <li>MSN：#{get_admin_info_by_user_id(user_id).msn}</li>
          </ul>
    </div>"
      end
    rescue
      #
    end
    return html_of_user_sign
  end
  
  def get_topic_view(ask_id)
    AskZhidaoTopic.find(ask_id).view_counter
  end
  
  def get_topic_post(ask_id)
    AskZhidaoTopic.find(ask_id).post_counter
  end
  
  def get_topic_desc(ask_id)
    AskZhidaoTopic.find(ask_id).description.to_s.strip
  end
  
  def get_wiki_title_by_wiki_id(wiki_id)
    html_of_wiki_title =""
    @descripts = WikiDescript.find(:all,:conditions => ["content_id = ? and is_del = 0",wiki_id])
    @descripts.each { |descript|
      wiki_title = descript.title
      html_of_wiki_title = html_of_wiki_title + "<a href=\"/visitor/list_wiki?id=#{wiki_id}##{descript.id}\" target=\"_self\">" + wiki_title + "</a>" + "<br>"
    }
    return html_of_wiki_title
  end
  
  def get_wiki_description_by_wiki_id(wiki_id)
    wiki_title =""
    @descripts = WikiDescript.find(:all,:conditions => ["content_id = ? and is_del = 0",wiki_id])
    @descripts.each { |descript|
      wiki_title = descript.description
    }
    return wiki_title
  end
   
  def get_title_by_content_id(content_id)
    @titles = WikiDescript.find(:all, :conditions => ["content_id = ? and is_del = 0",content_id])
    return @titles
  end
   
  def get_description_by_id(id)
    description = WikiDescript.find(:first, :conditions => ["id = ? and is_del = 0",id])
    return description.description
  end

  def get_html_of_admin_operations_by_topic_id(admin_id, topic_id,tag_id)
    html_of_admin_operations = ""
    if admin_id.to_i > 0
      if is_admin(admin_id).nil?
        #
      else
        html_of_admin_operations = html_of_admin_operations +
          " <a href=\"/delete_topic/#{topic_id}/#{tag_id}/#{admin_id}\"onclick=\"if (confirm('您确定要彻底删除这篇帖子及其所有回复吗？')) { var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;f.submit(); };return false;\"><b>删除</b></a>"
      end
    else
      #
    end
    return html_of_admin_operations
  end

  def get_html_of_admin_operations_by_post_id_and_topic_id(admin_id, post_id, topic_id)
    html_of_admin_operations = ""
    if admin_id.to_i > 0
      if is_admin(admin_id).nil?
        #
      else
        html_of_admin_operations = html_of_admin_operations +
          " <a href=\"/delete_post/#{post_id}/#{admin_id}/#{topic_id}\"onclick=\"if (confirm('您确定要彻底删除这条回复吗？')) { var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;f.submit(); };return false;\"><b>删除</b></a>"
      end
    else
      #
    end
    return html_of_admin_operations
  end

  private
  def is_admin(admin_id)
    afa = AskZhidaoAdmin.find(:first, :select => "id",:conditions => ["is_delete = 0 and admin_id = ?",admin_id])
    return afa
  end
  
end