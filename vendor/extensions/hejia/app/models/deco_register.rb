class DecoRegister < Hejia::Db::Hejia
  validates_presence_of :name, :phone
  attr_accessor :firmname #预约参观在建样板房 提交公司名称，用于google统计代码
  belongs_to :event, :class_name => "DecoEvent", :foreign_key => "event_id"

  belongs_to :factory, :class_name => "DecoFactory", :foreign_key => "event_id"

  SEX = {
    "男" => 1, 
    "女" => 2
  }
  THE_TIME_TO_VISIT = {
    "周一至周五" => 1,
    "双休日" => 2
  }
  
end
