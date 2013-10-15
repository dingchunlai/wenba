class LocationRelateModel < Hejia::Db::Product
  
  belongs_to :resource, :polymorphic => true
  
  validates_uniqueness_of :model_name, :on => :create, :scope => [:resource_id, :resource_type]
  
  CITY_FOR_MODEL = ["多乐士"]
  JINSHAZI_FOR_MODEL = ["金刷子"]
  
  named_scope :get_relate_for_model ,lambda{|model_name| {:conditions => ["model_name = ? ", model_name]}}
  
  #根据其它字段查找有没有这条记录,返回boole
  def self.is_data(option = {})
    count = LocationRelateModel.count(:all,:conditions => ["model_name = ? and location_id = ? and location_type = ?",option[:model_name] , option[:location_id] , option[:location_type] ])
    count == 0 ? false : true 
  end

end