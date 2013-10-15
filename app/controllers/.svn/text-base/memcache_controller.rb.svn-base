class MemcacheController < ApplicationController

  def expire
    keywords = params[:keywords].to_s.strip
    if keywords.blank?

    else
      begin
        keywords = keywords.split("\r\n").map{ |e| e.strip}
        keywords.each do |keyword|
          CACHE.delete(keyword)
          CACHE.delete(MEMCACHE_PREFIX_KEY+"_"+keyword) unless keyword[0..3] == MEMCACHE_PREFIX_KEY+"_"
        end
        @alert_text = "操作成功： [#{keywords.join(", ")}] 的缓存已清除！"
      rescue Exception => e
        @alert_text = "操作失败： #{e.to_s}"
      end
    end
    my_render
  end

  def my_render(alert_text=@alert_text, forward_url=@forward_url, render_text=@render_text)
    str = ""
    str += render_text  unless render_text.blank?
    str += alert(alert_text)  unless alert_text.blank?
    str += js(top_load(forward_url)) unless forward_url.blank?
    render :text => str unless str.blank?
  end

end
