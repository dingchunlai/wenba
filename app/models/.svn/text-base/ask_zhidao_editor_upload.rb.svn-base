class AskZhidaoEditorUpload < ActiveRecord::Base
  has_attachment :storage => :file_system,
    :path_prefix => "public/uploads",
    :size => 1.kilobyte..2.megabytes,
    :content_type => ['text/plain']
end
