class PromotedFirm < Hejia::Db::Hejia
#CREATE TABLE promoted_firms(
#id INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
#city INT(11) NOT NULL COMMENT '城市编号',
#district INT(11) NOT NULL COMMENT '地区编号',
#created_at DATETIME DEFAULT NULL COMMENT '创建时间',
#updated_at DATETIME DEFAULT NULL COMMENT '修改时间',
#order_class INT(11) DEFAULT 0 COMMENT '种类',
#price INT(11) DEFAULT 0 COMMENT '主打价位',
#style INT(11) DEFAULT 0 COMMENT '装修风格',
#model INT(11) DEFAULT 0 COMMENT '装修类别',
#firms_id VARCHAR(255) COMMENT '公司ID',
#except TINYINT(1) DEFAULT 0 COMMENT '是否例外',
#PRIMARY KEY (id)
#)
  serialize :firms_id
  named_scope :find_price, lambda { |price| { :conditions => ['price = ?' , price] } }
  named_scope :find_style, lambda { |style| { :conditions => ['style = ?' , style] } }
  named_scope :find_model, lambda { |model| { :conditions => ['model = ?' , model] } }
  named_scope :find_district, lambda { |district| { :conditions => ['district = ?' , district] } }
  named_scope :find_city , lambda { |city| { :conditions => ['city = ?' , city] } }
  named_scope :find_order , lambda { |order| { :conditions => ['order_class = ?' , order] } }
  named_scope :find_except , lambda { |except| { :conditions => ['except = ?' , except] } }
  named_scope :find_category , lambda { |category| { :conditions => ['category = ?' , category] } }
  named_scope :find_villa , lambda { |villa| { :conditions => ['villa = ?' , villa] } }

  named_scope :dianping_home_promoted,lambda{|city_code,price|
    {
    :conditions =>["model=0 and style=0 and order_class = 1 and price in (?) and city = ?",price ,city_code ]
    }
  }
  
end
