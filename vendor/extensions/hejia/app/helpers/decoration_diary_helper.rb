# encoding: utf-8
# encoding: utf-8
module DecorationDiaryHelper
  
  # 根据日记对象或者日记编号生成对应的日记链接地址
  # params[:diary_id]  (DecorationDiary or diary_id)
  # return diary_url
  def generate_diary_url diary
    if diary.class.to_s == "DecorationDiary"
      diary_id = diary.id
    else
      diary_id = diary
    end
    CACHE.fetch("/generate/decoration_diaries/diary_url/#{diary_id}", 1.day) do
     begin
        diary = DecorationDiary.find diary_id
        firm = DecoFirm.find diary.deco_firm_id
        "http://z.#{firm.city_pinyin}.51hejia.com/gs-#{firm.id}/zhuangxiugushi/#{diary.id}"
     rescue 
      "http://z.51hejia.com"
     end
    end
  end
  
  
     #生成图片地址。(兼容旧的)
  def decoration_diary_image(image_urls , size)
    image_path = ""
    if !image_urls.nil? && image_urls.include?("/files/hekea/article_img/sourceImage/")
      image = image_urls.split(".")
      if image.size>0
        image_path.concat IMAGE_URL
        if !size.blank? && size.split(/x/)[0].to_i <= 150
          image_path.concat image[0].to_s  
          image_path.concat "_thumb."
          image_path.concat image[1].to_s
        else
          image_path.concat image_urls
        end
      end
    elsif !image_urls.nil? && image_urls.include?("/images/binary/")
      image_path.concat IMAGE_URL
      image_path.concat image_urls
    else
      image_path = image_urls
    end
    image_path
  end
  
  #生成图片地址
  def image_full_path(picture, size ="" ,index = 1)
    picture.url(size)
  end
  
   def get_diary_master_picture(diary)
      diary.master_picture
  end

  
end