# encoding: utf-8
class DecoFirmsController  < ApplicationController
  
  def name_list
    DecoFirm
    if (city_id = REDIS_DB.get "diary/in_city_id_limit")
      @name_list = DecoFirm.published.find(:all,:select=>"name_zh",:limit=>10,:conditions=>["name_zh like ? and (city=? or district=?)","%#{params[:term]}%","#{city_id}","#{city_id}"],:order=>"is_cooperation desc").map(&:name_zh)
    else
      @name_list = DecoFirm.published.find(:all,:select=>"name_zh",:limit=>10,:conditions=>["name_zh like ?","%#{params[:term]}%"],:order=>"is_cooperation desc").map(&:name_zh)
    end
    render :json =>  @name_list.to_json
  end
  
end
