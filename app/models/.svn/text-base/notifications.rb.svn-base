class Notifications < ActionMailer::ARMailer
  def reply_notification(zhidao_topic_id)  #回复提问
    azt = AskZhidaoTopic.find(zhidao_topic_id)
    @subject    = "[和家问吧]回复：" + azt.subject
    @recipients = azt.guest_email
    @from       = "service@51hejia.com"
    @sent_on    = Time.now
    @body["zhidao_topic_id"] = zhidao_topic_id
  end
end