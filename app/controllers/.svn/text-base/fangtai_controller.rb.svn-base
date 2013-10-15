class FangtaiController < ApplicationController
  
  def get_kws
    return ["","选购","使用","保养","吸油烟机","灶具","消毒柜","微波炉","板","台面","五金","烤箱"]  #搜微波炉的同时也搜烤箱
  end

  def get_all_fangtai_topics
    AskZhidaoTopic
    kw_fangtai = "fangtai"
    topics = mc(kw_fangtai)
    if topics.nil?
      conditions = []
      conditions << "is_delete = 0"
      conditions << "method = 5"
      topics = AskZhidaoTopic.find(:all,:select=>"id,subject",:conditions=>conditions.join(" and "))
      mc(kw_fangtai, topics)
    end
    return topics
  end

  def get_fangtai_topics(kw1,kw2,is_reject=false)
    afts = get_all_fangtai_topics
    fts = []
    for ft in afts
      if is_reject
        unless ft.subject.include?(kw1) || (kw1=="微波炉" && ft.subject.include?(@kws[11]))
            fts << {"id"=>ft.id, "subject"=>ft.subject}
        end
      else
        if ft.subject.include?(kw1) || (kw1=="微波炉" && ft.subject.include?(@kws[11]))
          if ft.subject.include?(kw2) || kw2 == ""
            fts << {"id"=>ft.id, "subject"=>ft.subject}
          end
        end
      end
    end
    return fts
  end

  def list
    @kws = get_kws
    @stext = trim(params[:stext])
    @kw1 = params[:kw1].to_i
    @kw2 = params[:kw2].to_i
    @kw1 = 4 if @kw1 == 0
    @kw2 = 1 if @kw2 == 0
    if @stext.length > 0
      @p_kw = ""
      @qs = get_fangtai_topics(@stext,"")
    else
      @p_kw = "&kw1=#{@kw1}"
      @qs = get_fangtai_topics(@kws[@kw1],@kws[@kw2])
    end
  end

  def get_kw1_by_subject(subject)
    4.upto(@kws.length-1) do |i|
      kw = @kws[i]
      if kw.to_s.length > 0
        return i if subject.include?(kw)
      end
    end

  end

  def detail
    @kws = get_kws
    id = params[:id].to_i
    @kw1 = params[:kw1].to_i
    if id > 0
      @q = AskZhidaoTopic.find(id,:select=>"id,subject")
      @a = AskZhidaoTopicPost.find(:first,:select=>"id,content",:conditions=>"user_id = 7232717 and zhidao_topic_id=#{id} and is_delete=0")
      @kw1 = get_kw1_by_subject(@q.subject) if @kw1 == 0
      @about_qs = get_fangtai_topics(@kws[@kw1],"").sort_by{rand}
      @other_qs = get_fangtai_topics(@kws[@kw1],"",true).sort_by{rand}
    else
      render :text => "无此记录！"
    end
  end

end
