# == Schema Information
#
# Table name: pictures
#
#  id                   :integer(11)     not null, primary key
#  image_url            :string(255)
#  decoration_dairiy_id :integer(11)
#  created_at           :datetime
#  updated_at           :datetime
#  space                :integer(11)
#  is_master            :integer(4)      default(0)
#

class Picture < Hejia::Db::Hejia
  belongs_to :item, :polymorphic => true
end
