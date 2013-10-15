# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #最新版嵌入广告位方法2010-11-12
  def adspace(code, fill='', wrap='', &block)
    delete_cache = params[:dont_cache_me] || params[:no_cache]
    datas = AdSpace.render(code, fill, wrap, delete_cache, &block)
    unless datas[1].blank?
      content_for :html_body_end do
        datas[1]
      end
    end
    datas[0]
  end

  def include_kindeditor_javascript
    content_for :head do
      if RAILS_ENV == 'production' || RAILS_ENV == 'rehearsal'
        javascript_include_tag "http://js.51hejia.com/js/jquery/plugins/kindeditor/3.5.2/kindeditor-min.js",
                                    "http://js.51hejia.com/js/jquery/plugins/kindeditor/3.5.2/config/config.js"
      else
        javascript_include_tag "/javascripts/plugins/kindeditor/kindeditor-min.js",
          "/javascripts/plugins/kindeditor/config/config.js"
      end
    end
  end

  def include_kindeditor_js
      javascript_include_tag "/javascripts/plugins/kindeditor/kindeditor-min.js",
          "/javascripts/plugins/kindeditor/config/config.js"
  end

end
