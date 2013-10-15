# 将已有标签的日记信息导入新表
# 51hejia.decoration_diaries into hejia_index.hejia_indexes
# 标签表hejia_index_keywords
# hejia_index_keywords 于 hejia_indexes 关联表 relations

# 字段注意：relations => {:entity_id => 日记编号, entity_type => 7(标识为日记), keyword_id => 标签编号} 
# hejia_indexes表中信息大致描述
# {:title => 日记标题, :resume => 日记内容, :url => 日记链接地址, :entity_type_id => 标识类型为7(int), entity_id => 日记编号} 


module Decoration
  class MigrationDecorationDiary
    # 关于日记信息导入新表 标识类型为 7
    IMAGE_URL = "http://img.51hejia.com"
    TAGURLS = {
      0 => "",
      11910 => "shanghai",
      12117 => "suzhou",
      12122 => "nanjing",
      12301 => "ningbo",
      12306 => "hangzhou",
      12118 => "wuxi",
      12093 => 'wuhan',
      12122 => 'nanjing',
      12173 => 'qingdao',
      12109 => 'changsha',
      11921 => 'hefei',
      12059 => 'zhengzhou',
      11905 => 'beijing',
      31959 => 'guangzhou',
      11971 => 'shenzhen',
      12013 => 'haikou',
      11944 => 'xiamen',
      12243 => 'chengdu',
      11908 => 'chongqing',
      11887 => 'tianjin',
      12349 => 'changchun',
      12142 => 'dalian',
      12069 => 'haerbin',
      12288 => 'kunming',
      12030 => 'shijiazhuang',
      12194 => 'taiyuan',
      12208 => 'xian'
    }

    class << self

      include ActionView::Helpers::TextHelper

      # 当新建，修改日记时的操作
      def run! id
        diary = DecorationDiary.find_by_id id
        create_hejia_index(diary)
        create_relation(diary)
      end
      
      # 当删除某个日记时的操作
      def delete_diary id
        index = HejiaIndex.find_by_entity_type_id_and_entity_id 7, id
        unless index.blank?
          Relation.destroy_all("entity_id = #{id} and relation_type = 7")
          index.destroy
        end
      end

      # 开始迁移数据
      def into_hejia_index
        diaries = DecorationDiary.find(:all, 
          :conditions => ["decoration_diaries.status = 1 and decoration_diaries.tags is not null and decoration_diaries.id > ?", last_diary_id],
          :order => "decoration_diaries.id DESC")
        diaries && diaries.each do |diary|
          create_hejia_index(diary)
          create_relation(diary)
        end
      end
      
      # hejia_indexes添加日记信息
      def create_hejia_index(diary)
        index = HejiaIndex.find(:first, :conditions => ["entity_type_id = 7 and entity_id = ?", diary.id]) || HejiaIndex.new
        index.title = diary.title
        index.resume = strip_tags(diary.decoration_diary_posts.first.body) if diary.decoration_diary_posts.size > 0
        index.entity_id = diary.id
        index.entity_type_id = 7
        index.entity_expired_at = 20.years.from_now
        # 生成日记地址
        index.url = diary_url(diary)
        # 添加写日记用户
        index.username = diary.user.USERNAME unless diary.user.blank?
        # 设置主图，没有则有附图中提取一张主图，若即么主图也麼附图则无能为力 （为空）
        index.image_url = set_master_picture(diary) if (diary.master_picture || diary.attach_pictures.size > 0)
        # 抽取四章日记附图
        unless diary.attach_pictures.blank?
          pictures = diary.attach_pictures.first(4)
          if pictures.size == 1
            index.image_url2 = image_full_path(pictures[0])
          elsif pictures.size == 2
            index.image_url2 = image_full_path(pictures[0])
            index.image_url3 = image_full_path(pictures[1])
          elsif pictures.size == 3
            index.image_url2 = image_full_path(pictures[0])
            index.image_url3 = image_full_path(pictures[1])
            index.image_url4 = image_full_path(pictures[2])
          elsif pictures.size == 4
            index.image_url2 = image_full_path(pictures[0])
            index.image_url3 = image_full_path(pictures[1])
            index.image_url4 = image_full_path(pictures[2])
            index.image_url5 = image_full_path(pictures[3])
          else
          end
        end
        index.save
      end
     
      # 创建日记于标签关联信息
      def create_relation(diary)
        unless diary.tags.blank?
          Relation.destroy_all("entity_id = #{diary.id} and relation_type = 7")
          diary.tags.uniq.each do |tag_name|
            tag = HejiaIndexKeyword.find_by_name tag_name
            if tag.nil?
              tag = HejiaIndexKeyword.create(:name => tag_name)
            end
            relation = Relation.new
            relation.entity_id = diary.id
            relation.relation_type = 7
            relation.keyword_id = tag.id
            relation.save
            # 清除专区前台缓存
            Hejia[:cache].delete("hejia_index_zhuanqu_list_#{relation.keyword_id}_7_1")
            key = "hejia_index_zhuanqu_list_counter_#{relation.keyword_id}_7"
            Hejia[:cache].set(key, (Hejia[:cache].get(key).to_i + 1))
          end
        end
      end

      # 获取上次导入的最后日记编号
      def last_diary_id
        index = HejiaIndex.find(:first, :conditions => "entity_type_id = 7", :order => "entity_id DESC")
        index && index.entity_id || 0
      end
      
      # 设置主图||如果说没有主图存在而有附图的话 将附图提取一张填充主图
      # 既没主图也麼附图则无能为力
      def set_master_picture(diary)
        unless diary.master_picture.blank?
          image_full_path(diary.master_picture)
        else
          unless diary.attach_pictures.blank?
            image_full_path(diary.attach_pictures[0])
          end
        end
      end

      # 日记URL地址
      def diary_url(diary)
        unless diary.deco_firm.blank?
          city = ([11910,11905,31959,11908,11887].include? diary.deco_firm.city) ? diary.deco_firm.city : diary.deco_firm.district
          "http://z.#{TAGURLS[city]}.51hejia.com/stories/#{diary.id}"
          #"http://z.#{TAGURLS[city]}.51hejia.com/gs-#{diary.deco_firm_id}/zhuangxiugushi/#{diary.id}"
        else
          "http;//www.51hejia.com"
        end
      end

      # 生成图片地址。(兼容旧的)
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
      
      # 生成图片地址
      def image_full_path(picture, size = "",i=0)
        return "http://www.51hejia.com/api/images/none.gif" unless picture
        if picture.image_url
          decoration_diary_image(picture.image_url,size)
        else
          #          domain_index = rand(3)
          #          IMAGE_PREFIX_ARRAY
          #          image_domain = IMAGE_PREFIX_ARRAY[domain_index]
          image_domain = IMAGE_PREFIX_ARRAY[i % IMAGE_PREFIX_ARRAY.size]
          if picture.image_id && picture.image_md5 && picture.image_ext
            if size.blank?
              image_domain + "/" + picture.image_id + "-" + picture.image_md5 + "." + picture.image_ext
            else
              image_domain + "/" + picture.image_id + "-" + picture.image_md5 + "_"+ size + "." + picture.image_ext
            end
          end
        end
      end
    end
  end
end
