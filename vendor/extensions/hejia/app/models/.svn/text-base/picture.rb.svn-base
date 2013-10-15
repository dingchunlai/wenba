# encoding: utf-8
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
  has_many :paint_case_pictures, :dependent => :destroy

    before_create :set_is_master

    # 是主图？
    def master?
      is_master == true || is_master == 1
    end

    # 设为主图
    def master!
      self.is_master = 1
      if save
        resolve_conflict
        true
      else
        false
      end
    end

    # 去掉主图属性
    def not_master!
      self.is_master = 0
      save
    end

    # 把其他主图的主图属性去掉
    def resolve_conflict
      Picture.update_all('is_master = 0', ["id <> ? and attachable_type = ? and attachable_id = ? and is_master <> 0", id, attachable_type, attachable_id])
    end

    
  
  # 当前图片的URL,兼容cloud_fs和文件系统
  def url(size = "")
    if self.image_url.blank?
      cloud_fs_url(size)
    else
      file_system_url(size)
    end.strip
  end
  
private

  # 新添加的图片，除非指定，否则不设为主图
  def set_is_master
    self.is_master = 0 unless self.is_master
  end

  # cloud_fs中图片的URL地址
  def cloud_fs_url size=""
    file_size = size.blank? ? "" : "_"+ size
    IMAGE_PREFIX_ARRAY[rand(IMAGE_PREFIX_ARRAY.length)].chomp('/') + '/' + image_id + "-" + image_md5 + file_size + "." + image_ext
  end
  
  # 文件系统中图片的地址,主要是一些比较老的图片
  def file_system_url size=""
    image_urls = self.image_url
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
    
end
