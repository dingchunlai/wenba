class LogController < ApplicationController

  before_filter :authentication

  def authentication
    if current_user.id.to_i == 7213592
      return true
    else
      render :text => "您无权访问该地址！"
      return false
    end
  end

  def get_log_file
    return "log/#{RAILS_ENV}.log"
  end

  def show
    line = params[:id] || params[:line]
    line = line.to_i
    line = 200 if line == 0
    file_size = File.size(get_log_file)
    clear_log if file_size > 10.megabytes #如果日志文件大于10M，则清空log文件。
    file = File.new(get_log_file, "r")
    lines = file.readlines
    file.close_read
    line = lines.length if line > lines.length
    if lines.length == 0
      render :text => "暂时没有任何日志内容，请刷新本页以浏览最新日志。"
    else
      file_size_mb = eval(sprintf("%8.2f",file_size.to_f / 1024 /1024))
      render :text => "日志文件大小： #{file_size_mb} MB<br/>#{"="*80}<br/>" + lines[lines.length-line..lines.length-1].join("<br />")
    end
  end

  #清空log文件。
  def clear_log
    file = File.new(get_log_file, "w")
    file.print("")
    file.close_write
  end

 
end
