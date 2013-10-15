class HejiaStaff < Hejia::Db::Hejia
  self.table_name = "radmin_users"
#  validates_presence_of :name, :message=>"<script>alert('用户名必须填写!');</script>"
#  validates_presence_of :password, :message=>"<script>alert('密码必须填写!');</script>"
#  validates_presence_of :role, :message=>"<script>alert('用户角色必须选择!');</script>"
#  validates_uniqueness_of :name, :message=>"<script>alert('您输入的用户名已经被占用!');</script>"
 
  # 得到用户所有的角色（名称）
  def roles
    @roles ||=
      Webpm.find(:all,
                 :select => "value",
                 :conditions => ["keyword = ? and id in (?)", 'role', role.blank? ? [] : role.split(',')]
                ).map! { |pm| pm.value }
  end

  def member_of?(role)
   # logger.info "[比较角色] #{role.inspect} in #{roles.inspect}"
    roles.include? role
  end

  def admin?
    member_of? '管理员'
  end

  #是否具有《和家编辑》权限
  def hejia_editor?
    return true if admin? || member_of?('文章编辑')
    false
  end

  #是否具有《问吧编辑》权限
  def wenba_editor?
    return true if admin? || member_of?('问吧编辑') || member_of?('问吧管理')
    false
  end

  #是否具有《论坛编辑》权限
  def bbs_editor?
    return true if admin? || member_of?('论坛编辑') || member_of?('论坛管理')
    false
  end

end
