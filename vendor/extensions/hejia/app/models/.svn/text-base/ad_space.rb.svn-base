class AdSpace < Hejia::Db::Hejia

  AD_TYPES = ['safp','afp','openx'] #广告类型
  IS_USING = ['未启用','已启用'] #已启用就是已埋广告位代码

  class << self

    def memkey(code)
      "hejia_ad_space_#{code}"
    end

    def ad_type_options
      AD_TYPES.zip((0...AD_TYPES.length).to_a)
    end

    def clear_cache(code)
      Hejia::Cache.delete(memkey(code))
    end

    #fill 当广告位不存在时，用来代替广告位呈现的内容，可以给方法带入block来实现这个功能。
    #wrap 包裹在广告位两边的代码(当有广告位呈现时) 比如：<div></div>
    def render(code, fill = '', wrap = '', delete_cache = false)
      Hejia::Cache.delete(memkey(code)) if delete_cache
      Hejia::Cache.fetch(memkey(code), RAILS_ENV == 'development' ? 1.seconds : 3.hours) do
        space = self.find(:first, :select => 'id, ad_id, ad_type, is_using', :conditions => ['code = ?', code])
        #space.ad_type = 0
        if space.nil?
          state = '无广告位数据，无替代内容！'
          if block_given?
            datas = [yield, '']
          else
            datas = [fill, '']
          end
          state = '无广告位数据，有替代内容。' unless datas[0].blank?
        else
          state = '有广告位数据。'
          #在线上环境读到该广告位内容后，自动将该广告位设为已启用状态。
          if space.is_using == 0 && RAILS_ENV == 'production'
            space.is_using = 1
            space.save
          end
          datas = self.render_ad(space.ad_id, code, space.ad_type)
          datas[0] = self.append_wrap(datas[0], wrap) unless wrap.blank?
        end
        ["<!-- 广告位：#{code} (STATUS: #{state} #{Time.now.to_s(:db)}) -->\n#{datas[0]}", datas[1]]
      end
    end

    #添加外套包裹
    def append_wrap(data, wrap='')
      wraps = wrap.to_s.split('><')
      if wraps.length == 1
        "#{wrap}#{data}"
      elsif wraps.length == 2
        "#{wraps[0]}>#{data}<#{wraps[1]}"
      else
        data
      end
    end

    def render_ad(id, remark="", type="afp")
      if type.is_a?(Fixnum)
        type = 'safp' if type == 0
        type = 'afp' if type == 1
        type = 'openx' if type == 2
      end
      remark = "#{type}广告代码　" + remark + "　"
      b_js = content = ''
      if type=="afp"
        content = <<START
      <!-- #{remark + "START　" + "="*30} -->
      <script type="text/javascript">//<![CDATA[
      ac_as_id = #{id};
      ac_format = 0;
      ac_mode = 1;
      ac_group_id = 1;
      ac_server_base_url = "afp.csbew.com/";
      //]]></script>
      <script type="text/javascript" src="http://static.csbew.com/k.js"></script>
      <!-- #{remark + "END　" + "="*32} -->
START
        
      elsif type=="safp"
        content = "<span id='afp_id_#{id}'></span>"
        b_js = <<START
      <!-- #{remark + "START　" + "="*30} -->
      <script type="text/javascript">//<![CDATA[
      ac_as_id = #{id};
      ac_format = 0;
      ac_mode = 1;
      ac_group_id = 1;
      ac_dest_id = 'afp_id_#{id}';
      ac_server_base_url = "afp.csbew.com/";
      //]]></script>
      <script type="text/javascript" src="http://static.csbew.com/k.js"></script>
      <!-- #{remark + "END　" + "="*32} -->
START
      elsif type=="openx"
        content = <<START
      <!-- #{remark + "START　" + "="*30} -->
      <script type='text/javascript'><!--//<![CDATA[
      var m3_u = (location.protocol=='https:'?'https://a.51hejia.com/www/delivery/ajs.php':'http://a.51hejia.com/www/delivery/ajs.php');
      var m3_r = Math.floor(Math.random()*99999999999);
      if (!document.MAX_used) document.MAX_used = ',';
      document.write ("<scr"+"ipt type='text/javascript' src='"+m3_u);
      document.write ("?zoneid=#{id}");
      document.write ('&amp;cb=' + m3_r);
      if (document.MAX_used != ',') document.write ("&amp;exclude=" + document.MAX_used);
      document.write (document.charset ? '&amp;charset='+document.charset : (document.characterSet ? '&amp;charset='+document.characterSet : ''));
      document.write ("&amp;loc=" + escape(window.location));
      if (document.referrer) document.write ("&amp;referer=" + escape(document.referrer));
      if (document.context) document.write ("&context=" + escape(document.context));
      if (document.mmm_fo) document.write ("&amp;mmm_fo=1");
      document.write ("'><\/scr"+"ipt>");
      //]]>--></script>
      <!-- #{remark + "END　" + "="*32} -->
START
      end
      return [content, b_js]
    end

  end

end
