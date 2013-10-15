# encoding: utf-8

TIMESTAMP = Time.now.to_i.to_s
# 不和谐词汇在redis中的key
BAD_WORDS_KEY = "bad_words"  #全局

DECO_CASE_NAME_BAD_WORDS_KEY = "deco_case_name_bad_words" #案例

CITIES = {
  11910 => "上海",
  12117 => "苏州",
  12301 => "宁波",
  12306 => "杭州",
  12118 => "无锡",
  12093 => '武汉',
  12122 => "南京",
  12173 => '青岛',
  12109 => '长沙',
  11921 => '合肥',
  12059 => '郑州',
  11905 => '北京',
  31959 => '广州',
  11971 => '深圳',
  12013 => '海口',
  11944 => '厦门',
  12243 => '成都',
  11908 => '重庆',
  11887 => '天津',
  12349 => '长春',
  12142 => '大连',
  12069 => '哈尔滨',
  12288 => '昆明',
  12030 => '石家庄',
  12194 => '太原',
  12208 => '西安'

}

TAGURLS = {
  0 => "",
  0 => "quanguo",
  11910 => "shanghai",
  12117 => "suzhou",
  12122 => "nanjing",
  12301 => "ningbo",
  12306 => "hangzhou",
  12118 => "wuxi",
  12093 => 'wuhan',
  12122 => 'nanjing',
  12173 => 'qingdao',
  12109 => 'changsha',
  11921 => 'hefei',
  12059 => 'zhengzhou',
  11905 => 'beijing',
  31959 => 'guangzhou',
  11971 => 'shenzhen',
  12013 => 'haikou',
  11944 => 'xiamen',
  12243 => 'chengdu',
  11908 => 'chongqing',
  11887 => 'tianjin',
  12349 => 'changchun',
  12142 => 'dalian',
  12069 => 'haerbin',
  12288 => 'kunming',
  12030 => 'shijiazhuang',
  12194 => 'taiyuan',
  12208 => 'xian'
}

ROOM = {
  1 => '小户型',
  2 => '两房',
  3 => '三房',
  4 => '四房',
  5 => '复式',
  6 => '别墅'
}



# cloud_fs 图片的地址
if %w[development staging].include?(RAILS_ENV)

  PICTURE_PREFIX = "http://192.168.0.15:8081/"
  IMAGE_PREFIX_ARRAY = ["http://192.168.0.15:8081/"]
  #开发前台的时候需要
  #IMAGE_PREFIX_ARRAY = ["http://assets1.image.51hejia.com/"]
else
  PICTURE_PREFIX = "http://upload.image.51hejia.com/"
  IMAGE_PREFIX_ARRAY =["http://assets1.image.51hejia.com/", "http://assets2.image.51hejia.com/", "http://assets3.image.51hejia.com/"]
end

IMAGE_URL = "http://img.51hejia.com"

MODELS = {
  1 => '清包',
  2 => '半包',
  3 => '全包',
  4 => '纯设计'
}
SHANGHAI_MODELS = {
  1 => '清包',
  2 => '半包',
  3 => '全包',
  4 => '设计工作室',
  5 => '装修监理'
}

SPACE = {
  1 => '厨房',
  2 => '餐厅',
  3 => '客厅',
  4 => '卫生间',
  5 => '卧室',
  6 => '书房',
  7 => '儿童房',
  8 => '衣帽间',
  9 => '阳台',
  10 => '阁楼',
  11 => '花园',
  12 => '飘窗',
  13 => '储藏室',
  14 => '阳光房',
  15 => '玄关',
  16 => '过道',
  17 => '其他'


}

FACTORY_FANGXING = {
  1 => '1房1厅',
  2 => '2房1厅',
  3 => '2房2厅',
  4 => '3房1厅',
  5 => '3房2厅',
  6 => '4房以上',
  7 => '复式',
  8 => '别墅',
  9 => '工装'

}

QUOTE_PRICE_TYPE = {
  1 => "清包",
  2 => "半包",
  3 => "全包",
  4 => "精装",
  5 => "简装"
}

CASE_CATEGORY = {
  0 => "家装",
  1 => "工装"
}

PRICE = {
  1 => '8万以下',
  2 => '8-15万',
  3 => '15-30万',
  4 => '30万-100万',
  5 => '100万以上'
}

SHANGHAI_PRICE = {
  1 => '8万以下',
  2 => '8-15万',
  3 => '15万以上'
}

NINBO_PRICE = {
  1 => '6万以下',
  2 => '6-10万',
  3 => '10-15万',
  4 => '15-30万',
  5 => '30万以上'
}



CASE_CATEGORY = {
  0 => "家装",
  1 => "工装"
}

QUOTE_PRICE_TYPE = {
  1 => "清包",
  2 => "半包",
  3 => "全包",
  4 => "精装",
  5 => "简装"
}

APPLICANT_STATUS = {
  -1 => "删除",
  0 => "未确认",
  1 => "已确认"
}

FIRM_IMPRESSIONS_KEY = "firm_impressions"

# 公司的各种排序规则
COMPANY_SORT_ORDERS = {
  1 => %w[praise              口碑],
  2 => %w[design_praise       设计],
  3 => %w[construction_praise 施工],
  4 => %w[service_praise      服务]
}

STYLES = {
  1 => '现代简约',
  2 => '田园风格',
  3 => '欧美式',
  4 => '中式风格',
  5 => '地中海',
  6 => '混搭'
}