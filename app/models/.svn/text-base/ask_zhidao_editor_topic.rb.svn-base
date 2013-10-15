class AskZhidaoEditorTopic < ActiveRecord::Base
  def self.save_distributed_topic(editor_id, zhidao_topic_id)
    transaction() {
      #      往AskZhidaoEditorTopic表中插值
      azet = AskZhidaoEditorTopic.new
      azet.editor_id = editor_id
      azet.zhidao_topic_id = zhidao_topic_id
      azet.save
      
      #      更新AskZhidaoTopic表中字段is_distribute为1
      azt = AskZhidaoTopic.find(zhidao_topic_id)
      azt.update_attribute("is_distribute", 1)
    }
  end
end