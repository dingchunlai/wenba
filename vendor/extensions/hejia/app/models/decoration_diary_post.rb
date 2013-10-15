# encoding: utf-8
class DecorationDiaryPost < Hejia::Db::Hejia

  include Hejia::FixTimestampZone
  
  has_many :remarks, :as => :resource, :dependent => :destroy
  has_many :pictures , :as => :item
  belongs_to :decoration_diary
  
  validates_presence_of :decoration_diary_id
  validates_presence_of :body
  
  after_save :clean_cache
  after_save :update_decoration_diary
  before_save :set_default_state


  
  # 日记留言要先显示装修监理的
  def ordered_remarks
    self.remarks.published.left_by_supervisor + self.remarks.published.left_by_member
  end

  private

  def clean_cache
    Hejia[:cache].delete "decoration_diary:#{self.decoration_diary.id}:master_picture"
  end
  
  def update_decoration_diary
    self.decoration_diary.update_attribute(:updated_at, Time.now.utc)
  end

  def set_default_state
    self.state = 1
    self.decoration_diary.update_attributes(:status => 1, :order_time => Time.now.utc) if self.id.nil?
  end
  
end
