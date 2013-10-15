class HejiaUserBbs < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia]

#  if RAILS_ENV == 'development'
#    self.table_name = "HEJIA_USER_BBS_bak"
#  else
    self.table_name = "HEJIA_USER_BBS"
#  end

  self.primary_key = "USERBBSID"

  belongs_to :tag, :class_name => "Tag", :foreign_key => "ask_expert"


  def id
    read_attribute("USERBBSID").to_i
  end
  def username
    read_attribute("USERNAME")
  end
  def point
    CommunityUser.get_point(id)
  end
  def headimg
    read_attribute("HEADIMG")
  end
  def gender
    sex = read_attribute("USERBBSSEX").to_s.strip
    if sex == '女' || sex  == '小姐' || sex == 'female'
      'FeMale'
    else
      'Male'
    end
  end
  def area
    read_attribute("AREA")
  end
  def city
    read_attribute("CITY")
  end
  def userbbsreadme
    read_attribute("USERBBSREADME")
  end
  def email
    read_attribute("USERBBSEMAIL")
  end
  def created_at
    read_attribute("CREATTIME").is_a?(Time) ? read_attribute("CREATTIME").to_s(:db) : ''
  end
  def case_url
    case_id = HejiaCase.getCaseIdByBBSID(read_attribute("BBSID"))
    case_id == '#' ? '' : "http://z.51hejia.com/designers/#{read_attribute("BBSID")}"
  end
  def case_headimg
    image = read_attribute("HEADIMG")
    return '' if image.blank?
    return image if image.starts_with?("http")
    "http://img.51hejia.com/files/designer/" + image
  end


  class << self

    #匿名用户
    def ano_user
      self.new(:USERNAME => '和家网友',:USERBBSSEX => 'Male')
    end

    #取得用户信息
    def get_userinfo(user_id)
      user_id = user_id.to_i
      return nil if user_id == 0
      memkey = "common_memkey_userinfo_2_#{user_id}"
      user_info = PUBLISH_CACHE.fetch(memkey, 3.days) do
        self.find(user_id, :select=>"USERBBSID, USERNAME, BBSID, DECO_ID, HEADIMG, USERBBSSEX, AREA, CITY, USERBBSEMAIL, USERBBSREADME, CREATTIME") rescue false
      end
      user_info = nil unless user_info.is_a?(HejiaUserBbs)
      user_info
    end

    def username(user_id)
      userinfo = self.get_userinfo(user_id)
      if userinfo.nil?
        username = "U#{user_id}"
      else
        username = userinfo.username
        username = "N#{user_id}" if username.blank?
      end
      return username
    end

    def point(user_id)
      CommunityUser.get_point(user_id)
    end

    def case_users(limit = 20)
      HejiaUserBbs.find(:all,:select => "USERBBSID, USERNAME, BBSID, DECO_ID, HEADIMG, CREATTIME",
        :conditions => "USERTYPE=100 and USERBBSID <> 7251436 and length(HEADIMG) > 10 and deco_id is not null and !( length(`bbsid`) >18 ) ",
        :order => "POINT desc",
        :limit => limit)
    end

    def authenticate(name, password)
      HejiaUserBbs.find(:first, :select => "userbbsid",
        :conditions => ["username = ? and userspassword = ?", name, md5(password)])
    end

    def check_user(username,password)
      hub = HejiaUserBbs.find(:first,:select=>"USERBBSID, USERSPASSWORD",:conditions=>["USERNAME=?",username])
      if hub.nil?
        return 0  #用户名不存在！
      else
        if hub.USERSPASSWORD == md5(password)
          return hub.USERBBSID
        else
          return -1 #密码不正确
        end
      end
    end

    private
    def md5(password)
      Digest::MD5.hexdigest(password)
    end

  end

end
