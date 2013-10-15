class TestController < ApplicationController
  def send_mail
    @zhidao_topic_id = 13033
    email = Notifications.create_reply_notification(@zhidao_topic_id)
    email.set_content_type("text/html; charset=utf-8")
    Notifications.deliver(email)
  end
  
  def statistic
    #    visitor_id = get_user_id_by_cookie_name()
    #    AskStatistic.save("test", "statistic", request.request_uri, visitor_id, request.remote_ip)
  end

  def memcached
    
  end

end