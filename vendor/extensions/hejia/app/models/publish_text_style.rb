class PublishTextStyle < Hejia::Db::Hejia
#  acts_as_readonlyable [:read_only_51hejia]
   named_scope :get_value ,lambda{ |key| {:select=> "style_value" ,:conditions => ["style_key = ?", key]} }
end
