# encoding: utf-8
class AjaxCityController < ApplicationController

  # 返回数据库中的省份列表
  def get_province
    Tag
    @provinces = CACHE.fetch "province_in_database", 1.day do
      Tag.provinces_to_hash.to_a.to_json
    end
    render :json => @provinces
  end
  
  # 返回数据库中的城市列表
  def get_city
    Tag
    provice_id = params[:province].to_i
    @cities = CACHE.fetch "cities_in_databse:#{provice_id}", 1.day do
      Tag.urban_areas_to_hash(provice_id).to_a.to_json
    end
    render :json => @cities
  end
 

end
