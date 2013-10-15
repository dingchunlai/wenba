class AskEditorOperation < ActiveRecord::Base
  def self.save(editor_id, project_id, operation_id, operation_url)
    aeo = AskEditorOperation.new
    aeo.editor_id = editor_id
    aeo.project_id = project_id
    aeo.operation_id = operation_id
    aeo.operation_url = operation_url
    aeo.save
  end
end