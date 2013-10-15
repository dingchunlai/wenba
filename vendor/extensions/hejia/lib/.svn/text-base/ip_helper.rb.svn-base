# encoding: utf-8
module IpHelper
  CITIESIP = {
    0 => '0',
    1 => '11910',
    2 => '12117',
    3 => '12122',
    4 => '12301',
    5 => '12306',
    6 => '12118'
  }
   module_function
   
  # 获取用户城市
  #
  # return 当前用户所在城市汉字 和 数字
  def remote_city
    return {:name => cookies[:api_city], :number => CITIES.invert[cookies[:api_city]] } if cookies[:api_city]
    user_ip = request.remote_ip
    #user_ip = '222.73.180.146' # 上海 用于测试
    #user_ip = '122.224.185.6' # 杭州
    city = find_city_by_ip user_ip
    # 因为并非支持所有城市，如果城市不在支持的范围内，默认为上海
    unless city_id = CITIES.invert[city]
      city = '上海'
      city_id = CITIES.invert[city]
    end
    cookies[:api_city] = {:value => city, :expires => 1.month.from_now, :domain => ".51hejia.com"}
    {:name => city, :number => city_id, :pinyin => TAGURLS[city_id]}
  end

  # 不知道为什么要两个一样的方法
  alias remote_city_default remote_city

  # 返回ip所在城市的名称
  def find_city_by_ip(ip)
    if location = ChunzhenIp.default.find_location_by_ip(ip.to_s)
      location.city
    end
  end
  
end
