class TimeMechanism < ActiveRecord::Base
  def self.can_write
    string = ""
    tm = self.find(:first)
    unless tm.blank?
      now = Time.now.strftime("%H:%M:%S")
      if tm.s1_time and tm.e1_time and tm.s1_time < tm.e1_time
        string = "#{tm.s1_time.strftime("%H:%M:%S")}——#{tm.e1_time.strftime("%H:%M:%S")}暂停发言功能，敬请谅解。" if tm.s1_time.strftime("%H:%M:%S") < now and tm.e1_time.strftime("%H:%M:%S") > now
      end
      if tm.s2_time and tm.e2_time and tm.s2_time < tm.e2_time
        string = "#{tm.s2_time.strftime("%H:%M:%S")}——#{tm.e2_time.strftime("%H:%M:%S")}暂停发言功能，敬请谅解。" if tm.s2_time.strftime("%H:%M:%S") < now and tm.e2_time.strftime("%H:%M:%S") > now
      end

      if tm.s_date and tm.e_date
        string = "节假日期间暂停发言功能，敬请谅解。" if tm.s_date <= Date.today and Date.today <= tm.e_date
      end

    end
    return string
  end
end