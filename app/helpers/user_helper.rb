module UserHelper
  def get_zhidao_topic_by_zhidao_topic_id(zhidao_topic_id)
    zhidao_topic = AskZhidaoTopic.find(:first, :select => "subject, post_counter",
      :conditions => ["id = ?", zhidao_topic_id])
    return zhidao_topic
  end
end
