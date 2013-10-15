class AskZhidaoAdmin < ActiveRecord::Base
  def self.save(admin_id,editor_id, is_delete = 0)
    transaction(){
      afa = AskZhidaoAdmin.new
      afa.admin_id = admin_id
      afa.editor_id = editor_id
      afa.is_delete = is_delete
      afa.save
    }
  end

end