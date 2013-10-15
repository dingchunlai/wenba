class AskAuthorizedUser < ActiveRecord::Base
  def self.save(user_id, editor_id, authority_type_id=1, is_valid=1)
    aau = AskAuthorizedUser.new
    aau.user_id = user_id
    aau.editor_id = editor_id
    aau.authority_type_id = authority_type_id
    aau.is_valid = is_valid
    aau.save
  end
end