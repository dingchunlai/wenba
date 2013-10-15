namespace :gandiao_exin_pinglun do
	desc "干掉恶心的留言评论"
  task :gandiao_exin_pinglun => :environment  do
    replies_array = Reply.find(:all, :conditions => "(content like '%迷奸%') or (content like '%联系人：云苗%')").map(&:entity_id)
    replies_array.each do |entity_id|
      CACHE.delete "replies_cache_#{entity_id}"
    end
  end
end



