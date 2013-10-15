# encoding: utf-8
class Member::DecorationDiaryPostsController < ApplicationController
  #require 'yajl'

  before_filter :login_required

  def create
    @decoration_diary = DecorationDiary.find params[:decoration_diary_id]
    @decoration_diary_post = @decoration_diary.decoration_diary_posts.build(params[:post])
    add_picture_to_body unless params[:pictures].nil? || params[:pictures].empty?
    if @decoration_diary_post.save
      save_pictures
      render :json =>  @decoration_diary_post.attributes.to_json
    else
      render :json => "error"
    end
  end

  def update
    @decoration_diary_post = DecorationDiaryPost.find(params[:id])
    params[:post][:marker] = true if @decoration_diary_post.state && (@decoration_diary_post.body != params[:post][:body])
    add_picture_to_body(true) unless params[:pictures].nil? || params[:pictures].empty?
    if @decoration_diary_post.update_attributes(params[:post])
      save_pictures
      render :json => {:message=>"update_success",:decoration_diary_id=>@decoration_diary_post.decoration_diary.id}.to_json
    else
      render :json => "error".to_json
    end
  end

  def destroy
    @decoration_diary_post = DecorationDiaryPost.find(params[:id])
    @decoration_diary_post.destroy
    render :json => "true"
  end

  private

  def save_pictures
    return if params[:pictures].nil?
    # 保存图片附件
    params[:pictures].each do |picture|
      if @picture = Picture.find_by_image_id(picture[:image_id])
        @picture.update_attributes(picture)
      else
        @picture = Picture.new(picture)
        @picture.item = @decoration_diary_post
        @picture.save
      end
    end

    # 设置主图
    master_picture_image_id = params[:pictures][0][:is_master]
    if master_picture_image_id
      Picture.update_all("is_master = 0 ",["item_type = 'DecorationDiaryPost' and item_id in (?)",@decoration_diary_post.decoration_diary.decoration_diary_posts.map(&:id)])
      Picture.update_all("is_master = 1 ",:image_id => master_picture_image_id)
    else
      if master_picture_image_id.nil? || master_picture_image_id.empty?
        Picture.update_all("is_master = 1",:image_id => params[:pictures][0][:image_id])
      end
    end
    Hejia[:cache].delete "decoration_diaries:#{@decoration_diary_post.decoration_diary.id}:master_picture"
  end

  def add_picture_to_body(is_update = nil)
      all_images = []
      insert_images = []
      params[:pictures].each do |p|
        all_images << "#{p[:image_id]}" + '-' + "#{p[:image_md5]}" + '.' + "#{p[:image_ext]}"
      end
      all_images.each do |ai|
        insert_images << ai if @decoration_diary_post.body.include? ai
      end
      need_insert_end_image = all_images - insert_images
      need_insert_string = ''
      need_insert_end_image.each do |niei|
         need_insert_string += "<img src=\"http://assets1.image.51hejia.com/#{niei}\" _moz_resizing=\"true\"><br />"
      end
      unless is_update
        @decoration_diary_post.body << need_insert_string
      else
        params[:post][:body] << need_insert_string
      end
    end

end
