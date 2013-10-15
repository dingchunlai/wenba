# == Schema Information
#
# Table name: remarks
#
#  id            :integer(11)     not null, primary key
#  user_id       :integer(11)
#  ip            :string(255)
#  content       :text
#  created_at    :datetime
#  updated_at    :datetime
#  resource_type :string(255)
#  resource_id   :integer(11)
#  parent_id     :integer(11)
#

class Remark < Hejia::Db::Hejia
  belongs_to :resource, :polymorphic => true
  
  include Hejia::FixTimestampZone
  
  before_save :validate_remark
  before_save :validate_remark_date

  belongs_to :decoration_diary, :foreign_key => "other_id"
  validates_associated :decoration_diary
  
  # 后面都直接用user这个模型关系,上面的这个hejia_bbs_user先留着
  belongs_to :hejia_bbs_user, :class_name => "HejiaUserBbs",  :foreign_key => "user_id"
  belongs_to :user, :class_name => "HejiaUserBbs",  :foreign_key => "user_id"

  has_many :replies, :class_name => "Remark",  :foreign_key => "parent_id"
  has_many :show_replies, :class_name => "Remark", :conditions => "status=1", :foreign_key => "parent_id", :order => "created_at desc"
  belongs_to :parent, :class_name => "Remark", :foreign_key => "parent_id"
  # belongs_to :hejia_case, :class_name => "HejiaCase", :foreign_key => "parent_id"
  
  after_create  :increase_remarks_count
  after_destroy :decrease_remarks_count
  
  named_scope :published, :conditions => {:status => 1}
  
  named_scope :left_by_supervisor,
    {
    :joins => 'join HEJIA_USER_BBS  on HEJIA_USER_BBS.USERBBSID = remarks.user_id',
    :conditions => "HEJIA_USER_BBS.class_name = 'Supervisor'",
    :order => 'remarks.created_at'
  }
  
  named_scope :left_by_member,
    {
    :joins => 'join HEJIA_USER_BBS  on HEJIA_USER_BBS.USERBBSID = remarks.user_id',
    :conditions => "HEJIA_USER_BBS.class_name <> 'Supervisor' or HEJIA_USER_BBS.class_name is null",
    :order => 'remarks.created_at'
  }
  
  
  def increase_remarks_count
    case self.resource_type
    when "DecoIdea"
      DecoIdea.increment_counter(:remarks_count, self.resource_id)
    when "DecorationDiaryPost"
      DecorationDiary.increment_counter(:remarks_count, self.resource.decoration_diary_id)
    when "DecoFirm"
      DecoFirm.increment_counter(:remark_only_count, self.resource_id)
    when 'Case'
      HejiaCase.increment_counter(:remarks_count,self.resource_id)
    end
  end
  
  private :increase_remarks_count
  
  def decrease_remarks_count
    case self.resource_type
    when "DecoIdea"
      DecoIdea.decrement_counter(:remarks_count, self.resource_id)
    when "DecorationDiaryPost"
      DecorationDiary.decrement_counter(:remarks_count, self.resource.decoration_diary_id)
    when "DecoFirm"
      DecoFirm.decrement_counter(:remark_only_count, self.resource_id)
    when 'Case'
      HejiaCase.decrement_counter(:remarks_count,self.resource_id)
    end
  end
  private :decrease_remarks_count
  
  def user_name
    hejia_bbs_user ? hejia_bbs_user.USERNAME : '和家网友'
  end
  
  def HEADIMG
    hejia_bbs_user && hejia_bbs_user.HEADIMG || "http://member.51hejia.com/images/headimg/#{rand(100).to_s}.gif"
  end
  
  #和谐 ****** 
  def content
    (BadWord.all(BAD_WORDS_KEY).size > 0 and self[:content]) ? (self[:content].gsub %r/#{BadWord.all(BAD_WORDS_KEY).map! { |w| Regexp.escape w }.join('|')}/, '***') : self[:content]
  end
  
  # get_remarks_count
  def self.net_friend_remarks_number
    Hejia[:cache].fetch("remarks/net_friend_remarks_number/", 1.hour) do
      Remark.count
    end
  end
  
  #验证留言必须有用户ID #防止机器刷
  def validate_remark
    Hejia[:cache].fetch("remarks/validate_remark/#{user_id}", 1.hour) do
      if user_id.nil? 
        false
      else
        hejia_bbs_user ? true : false
      end
    end
  end
  private :validate_remark
  
  def validate_remark_date
    remark  = Remark.find(:first,:conditions => ["user_id = ? and resource_type = ? and resource_id = ? and created_at > ?",user_id, resource_type , resource_id , 1.minutes.ago.to_s(:db)])
    remark.nil? ? true : false
  end
  private :validate_remark_date

  def self.new_coupon_remark(city_id, limit = 12)
    Remark.find(:all, 
      :conditions => ["51hejia.remarks.resource_type = ? and product.coupons.city_id = ? and 51hejia.remarks.user_id is not null", "Coupon", city_id],
      :joins => "join product.coupons on product.coupons.id = 51hejia.remarks.resource_id",
      :limit => limit,
      :order => 'created_at DESC')
  end
  
end
