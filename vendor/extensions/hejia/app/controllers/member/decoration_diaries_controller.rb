# encoding: utf-8
class Member::DecorationDiariesController < ApplicationController
  layout "layouts/member/decoration_diaries"

  before_filter FormTokenFilter, :only => [:new,:create]
  before_filter :verified_user_required, :only =>[:create]
  before_filter :login_required
  before_filter :decoration_diary_limit, :only => [:new, :create]
  def index
    if current_user
      @decoration_diaries = current_user.decoration_diaries.paginate(:all,:conditions=>["deco_firm_id is not null"],:per_page=>"10",:page=>params[:page],:order=>"created_at desc")
    elsif params[:user_id]
      @decoration_diaries = DecorationDiary.paginate(:all, :conditions => ["user_id=#{params[:user_id]} and status<>-1"],:per_page=>"10",:page=>params[:page],:order=>"created_at desc")
    else
      redirect_to '/review/note_list'
    end
  end
  
  def new
    @decoration_diary = DecorationDiary.new
    REDIS_DB.del "diary/in_city_id_limit" #用于新建日记时，按城市跟关键字查找公司
  end
  
  def create
    @decoration_diary = DecorationDiary.new(params[:decoration_diary])
    @decoration_diary.user_id = current_user.USERBBSID if current_user
    @decoration_diary.deco_firm = DecoFirm.published.find_by_name_zh(params[:deco_firm_name])
    @decoration_diary.order_time = Time.now.utc.to_s(:db)
    if @decoration_diary.save
      redirect_to decoration_diary_path(@decoration_diary)
    else
      render :action => :new
    end
  end
  
  def show
    @decoration_diary = DecorationDiary.find params[:id]
    @post = DecorationDiaryPost.new
    @posts = @decoration_diary.decoration_diary_posts.paginate(:all, :page => params[:page], :per_page => 10, :order => "created_at desc")
    @form_url = decoration_diary_decoration_diary_posts_path(@decoration_diary)
    @type = "POST"
    if params[:post_id]
      @post = DecorationDiaryPost.find(params[:post_id])
      @pictures = @post.pictures
      @form_url = decoration_diary_decoration_diary_post_path(@decoration_diary,@post)
      @type = "PUT"
    end
  end
  
  def edit
    @decoration_diary = DecorationDiary.find params[:id]
    @areas = get_areas2(@decoration_diary.city)
    render :action => "new"
  end
  
  def update
    params[:decoration_diary][:deco_firm_id] = DecoFirm.published.find_by_name_zh(params[:deco_firm_name]).id
    @decoration_diary = DecorationDiary.find params[:id]
    Hejia[:cache].delete("/generate/decoration_diaries/diary_url/#{@decoration_diary.id}") if @decoration_diary.deco_firm_id.to_i != params[:decoration_diary][:deco_firm_id].to_i
    if @decoration_diary.update_attributes(params[:decoration_diary])
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
  
  def destroy
    @decoration_diary = DecorationDiary.find params[:id]
    if  @decoration_diary.destroy
      flash[:notice] = "删除成功"
    else
      flash[:error] = "删除出现错误"
    end
    redirect_to :action => "index"
  end
  
  def score
    return render :json => "error".to_json if $redis.get("remark:mark:user:#{current_user.id}")
    @decoration_diary = DecorationDiary.find params[:other_id]
    if @decoration_diary.update_attributes params[:decoration_diary]
      $redis.setex("remark:mark:user:#{current_user.id}",6.months,1)
    end
    # 公司评论是否通过审核之内  取决于公司的评论权限
    firm = DecoFirm.find_by_id @decoration_diary.deco_firm.id
    
    hash = {
      :ip => request.remote_ip,
      :other_id => params[:other_id],
      :content => params[:content],
      :resource_type => "DecoFirm",
      :resource_id => @decoration_diary.deco_firm.id,
      :status => (firm.popedom.to_i == 1 ? 1 : 0),
      :user_id => current_user.id
    }
    if firm.popedom.to_i == -1
      render :json => "don't remark".to_json
    else
      @remark = Remark.new(hash)
      if @remark.save
        render :json => "success".to_json
      else
        render :json => "error".to_json
      end
    end
  end
  
  def get_deco_firm_id
    deco_firm =  DecoFirm.published.find_by_name_zh(params[:deco_firm_name])
    if deco_firm.nil?
      render :json => false.to_json
    else
      render :json => true.to_json
    end
  end
  
  def select_city_area
    @area = get_areas2(params[:cityid])
    REDIS_DB.set "diary/in_city_id_limit", params[:cityid]
    render :partial => "select_city_area"
  end
  #根据省市编号取得各省市下的地区域Hash
  def get_areas2(cityid)
    return {} if cityid.to_i == 0
    Tag.urban_areas_to_hash(cityid)
  end
   

  
  
  private

  def verified_user_required
    unless current_user.mobile_verified
      flash[:error] = "只有通过验证的用户才可以发表日记"
      return redirect_to :back
    end
  end
  
  # 6个月只能写一篇日记
  def decoration_diary_limit
    if current_user.decoration_diaries.published.find(:all,:conditions=>["created_at >= ?",6.months.ago.to_s(:db)]).size > 0
      flash[:error] = "6个月内只能写一篇日记"
      redirect_to :action => :index
    end
  end
  
  
  
end
