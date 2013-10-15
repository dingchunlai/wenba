class FocusController < ApplicationController 
  def index

  end

  def form
    image_url = params[:upload_dir]
    topic_url = params[:upload]
    text_url = params[:load]
    image_url1 = params[:upload_dir1]
    topic_url1 = params[:upload1]
    text_url1 = params[:load1]
    image_url2 = params[:upload_dir2]
    topic_url2 = params[:upload2]
    text_url2 = params[:load2]

    if !image_url.nil? and !topic_url.nil? and !image_url1.nil? and !topic_url1.nil? and !image_url2.nil? and !topic_url2.nil? and
        !text_url.nil? and !text_url1.nil? and !text_url2.nil?
      # dir ='/var/www/ask.51hejia.com/app/views/visitor/_toptoday.rhtml'
      dir ='D:\RubyProjects\ask\Code\app\views\visitor\_toptoday.rhtml'

      open(dir,"r+") do |file|
        newstr1 = file.read.gsub(/imag\[1\]=".*?";$/, 'imag[1]="'+image_url.to_s+'";')
        file.reopen(dir, "w+") << newstr1
      end

      open(dir,"r+") do |file|
        newtop1 = file.read.gsub(/link\[1\]=".*?";$/, 'link[1]="'+topic_url.to_s+'";')
        file.reopen(dir, "w+") << newtop1
      end

      open(dir,"r+") do |file|
        newtit1 = file.read.gsub(/text\[1\]=".*?";$/, 'text[1]="'+text_url.to_s+'";')
        file.reopen(dir, "w+") << newtit1
      end

      open(dir,"r+") do |file|
        newstr2 = file.read.gsub(/imag\[2\]=".*?";$/, 'imag[2]="'+image_url1.to_s+'";')
        file.reopen(dir, "w+") << newstr2
      end

      open(dir,"r+") do |file|
        newtop2 = file.read.gsub(/link\[2\]=".*?";$/, 'link[2]="'+topic_url1.to_s+'";')
        file.reopen(dir, "w+") << newtop2
      end

      open(dir,"r+") do |file|
        newtit2 = file.read.gsub(/text\[2\]=".*?";$/, 'text[2]="'+text_url1.to_s+'";')
        file.reopen(dir, "w+") << newtit2
      end

      open(dir,"r+") do |file|
        newstr3 = file.read.gsub(/imag\[3\]=".*?";$/, 'imag[3]="'+image_url2.to_s+'";')
        file.reopen(dir, "w+") << newstr3
      end

      open(dir,"r+") do |file|
        newtop3 = file.read.gsub(/link\[3\]=".*?";$/, 'link[3]="'+topic_url2.to_s+'";')
        file.reopen(dir, "w+") << newtop3
      end

      open(dir,"r+") do |file|
        newtit3 = file.read.gsub(/text\[3\]=".*?";$/, 'text[3]="'+text_url2.to_s+'";')
        file.reopen(dir, "w+") << newtit3
      end
      flash[:notice] = '操作成功'
    end
  end

  def uptodate
    wd = params[:wd]
    tp = params[:tp]
    ry = params[:ry]

    if !wd.nil? and !tp.nil? and !ry.nil?
      # dir ='/var/www/ask.51hejia.com/app/views/visitor/_toptoday.rhtml'
      dir ='D:\RubyProjects\ask\Code\app\views\visitor\_toptoday.rhtml'
      

      open(dir,"r+") do |file|
        newstr3 = file.read.gsub(/imag\[3\]=".*?";$/, 'imag[4]="'+wd.to_s+'";')
        file.reopen(dir, "w+") << newstr3
      end

      open(dir,"r+") do |file|
        newtop3 = file.read.gsub(/link\[3\]=".*?";$/, 'link[4]="'+tp.to_s+'";')
        file.reopen(dir, "w+") << newtop3
      end

      open(dir,"r+") do |file|
        newtit3 = file.read.gsub(/text\[3\]=".*?";$/, 'text[4]="'+ry.to_s+'";')
        file.reopen(dir, "w+") << newtit3
      end
      
      open(dir,"r+") do |file|
        newstr1 = file.read.gsub(/imag\[2\]/, 'imag['+3.to_s+']')
        file.reopen(dir, "w+") << newstr1
      end

      open(dir,"r+") do |file|
        newtop1 = file.read.gsub(/link\[2\]/, 'link['+3.to_s+']')
        file.reopen(dir, "w+") << newtop1
      end

      open(dir,"r+") do |file|
        newtit1 = file.read.gsub(/text\[2\]/, 'text['+3.to_s+']')
        file.reopen(dir, "w+") << newtit1
      end

      open(dir,"r+") do |file|
        newstr2 = file.read.gsub(/imag\[1\]/, 'imag['+2.to_s+']')
        file.reopen(dir, "w+") << newstr2
      end

      open(dir,"r+") do |file|
        newtop2 = file.read.gsub(/link\[1\]/, 'link['+2.to_s+']')
        file.reopen(dir, "w+") << newtop2
      end

      open(dir,"r+") do |file|
        newtit2 = file.read.gsub(/text\[1\]/, 'text['+2.to_s+']')
        file.reopen(dir, "w+") << newtit2
      end

      open(dir,"r+") do |file|
        newstr4 = file.read.gsub(/imag\[4\]/, 'imag['+1.to_s+']')
        file.reopen(dir, "w+") << newstr4
      end

      open(dir,"r+") do |file|
        newtop4 = file.read.gsub(/link\[4\]/, 'link['+1.to_s+']')
        file.reopen(dir, "w+") << newtop4
      end

      open(dir,"r+") do |file|
        newtit4 = file.read.gsub(/text\[4\]/, 'text['+1.to_s+']')
        file.reopen(dir, "w+") << newtit4
      end
      flash[:notice] = '操作成功'
    end
  end
  
end
