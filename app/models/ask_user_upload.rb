class AskUserUpload < ActiveRecord::Base
  has_attachment :storage => :file_system,
    :path_prefix => "public/uploads/images",
    :size => 1.kilobyte..2.megabytes,
    :thumbnails=>{:small=>'200x200>', :middle=>'400x400>'},
    :content_type => ['image']
end