class HejiaIndex < Hejia::Db::Index

  set_table_name "hejia_indexes"

  ARTICLE_ENTITY_TYPE_ID = 1

  # default_scope :conditions => ['hejia_indexes.entity_type_id = ?', ARTICLE_ENTITY_TYPE_ID], :order => 'entity_created_at DESC'
  named_scope :with_image,    :conditions => 'image_url is not null'
  named_scope :without_image, :conditions => 'image_url is null'

  # 从hejia_indexes中，找出包含某关键字的文章。
  # @param [String] keyword 关键字
  # @param [Hash] options 选项。除了说明的选项外，其它选项均带入到HejiaIndex.find方法中。
  # @option [Boolean] with_image 是否选择带有主图的文章。true则只选择带主图的文章；false则只选择不带主图的文章；不指定则找所有的文章
  # @return [Array] 文章列表

  class << self

    def find_by_keyword(keyword, options={})
      with_image = options.delete :with_image
      entity_type_id = options.delete :entity_type_id
      if kw = HejiaIndexKeyword.first(:select => 'id', :conditions => ["name = ?", keyword])
        entities = Relation.all(:select => "entity_id", :conditions => ["keyword_id = ?", kw.id])
        cond = ['entity_id in (?)', entities.map(&:entity_id)]
        unless entity_type_id.nil?
          cond[0] += ' and entity_type_id = ?'
          cond << entity_type_id
        end
        Hejia::Cache.fetch("get_atricles_by_#{keyword}", 1.hour) do
          if true === with_image
            HejiaIndex.with_image
          elsif false === with_image
            HejiaIndex.without_image
          else
            HejiaIndex
          end.all({:conditions => cond}.merge(options))
        end
      else
        # 没找到关键字，返回空列表
        []
      end
    end

    #获取《装修日记》通过《栏目专区id》
    def diaries_by_zhuanqu_sort(zhuanqu_sort_id, limit=10)
      entity_type_id = 7
      keyword_ids = ZhuanquKw.get_kw_names_by_sort_id(zhuanqu_sort_id).map{ |e| HejiaIndexKeyword.get_id_by_keyword(e)}
      relations = Relation.find(:all,:select => 'distinct entity_id',
        :conditions => ["keyword_id in (?) and relation_type = ?", keyword_ids, entity_type_id],
        :order => 'entity_id desc')
      entity_ids = relations.map{ |r| r.entity_id }
      indexes = HejiaIndex.with_exclusive_scope{ HejiaIndex.find(:all,
          :conditions => ["entity_id in (?) and entity_type_id = ?", entity_ids, entity_type_id])}
      #如果取不满指定的记录数，用最新《装修日记》填充。
      if indexes.length < limit
        newdiaries = self.new_diaries(10)
        titles = indexes.map{ |r| r.title }
        0.upto(9) do |i|
          break if indexes.length == limit || newdiaries[i].nil?
          indexes << newdiaries[i] unless titles.include?(newdiaries[i].title)
        end
      end
      indexes[0...limit]
    end

    #得到最新的油漆文章 ，第一章必须有主图，
    def get_indexs(keyword, limit = 7)
      with_image = HejiaIndex.find_by_keyword(keyword , :with_image => true ,:limit => 1)
      other = HejiaIndex.find_by_keyword(keyword ,:limit => limit)
      indexs = with_image + (other - with_image)
      indexs[0..limit]
    end

    def findbyids(ids)
      return find(:all, :conditions => ["id in (#{ids})"])
    end

    def findnamebylike options={}
      title = options[:title]
      etype = options[:etype]
      beginnum = options[:beginnum]
      allnum = options[:allnum]
      conditions = []
      conditions << " is_valid = '1' and entity_type_id <> '1'"
      conditions << " entity_type_id = '#{etype}' " if etype && etype != ''
      conditions << " title like '%#{title}%' " if title && title != ''
      return find(:all,:conditions => conditions.join(" and "),:order => 'created_at desc',:offset => beginnum,:limit => allnum)
    end

    def zhuanqu_list_memkey(keyword_id, entity_type_id, type = 'records')
      "zhuanqu_list_#{keyword_id}_#{entity_type_id}_#{type}_2"
    end

    def articles_memkey(keyword_id)
      "articles_by_editor_keyword_id_#{keyword_id}"
    end

    def get_zhuanqu_list(keyword_id, board_id, entity_type_id, curpage)
      curpage = 1 unless curpage.to_i > 0
      entity_type_id = 1 unless board_id.to_i == 1  #除非是装修板块，否则类型只可能是文章（entity_type_id=1）。
      if curpage.to_i == 1
        #第一页使用缓存
        memkey = zhuanqu_list_memkey(keyword_id, entity_type_id)
        Hejia::Cache.fetch(memkey, 1.day) do
          zhuanqu_list(keyword_id, entity_type_id, curpage)
        end
      else
        #第2页起不使用缓存
        zhuanqu_list(keyword_id, entity_type_id, curpage)
      end
    end

    def zhuanqu_list(keyword_id, entity_type_id, page)
      conditions = []
      conditions << "i.entity_id = r.entity_id and r.keyword_id = #{keyword_id} and r.relation_type = #{entity_type_id} and i.entity_type_id = #{entity_type_id}"
      HejiaIndex.paginate(
        :select => "i.id, i.entity_id, i.entity_type_id, i.title, i.entity_created_at, i.resume, i.url, i.image_url, i.image_url2, i.image_url3, i.image_url4, i.image_url5",
        :joins => "i, relations r",
        :conditions => conditions.join(" and "),
        :order => "entity_updated_at desc",
        :total_entries => HejiaIndex.get_zhuanqu_list_counter(keyword_id, entity_type_id),
        :per_page => 6,
        :page => page
      )
    end

    #清除列表专区缓存
    def zhuanqu_list_clear_cache(keyword_id, entity_type_id = 1)
      memkey = zhuanqu_list_memkey(keyword_id, entity_type_id)
      Hejia::Cache.delete(memkey)
    end

    def get_resume_by_id(id)
      resume = ""
      if id.to_i > 0
        kw = get_key("article_resume_by_id_2", id)
        resume = get_memcache(kw, 1.month) do
          index = HejiaIndex.find(:first, :select=>"id,entity_id,entity_type_id,resume", :conditions=>["id = ?", id])
          unless index.nil?
            resume = index.resume.to_s
            if resume.blank? && index.entity_type_id.to_i == 1
              resume = HejiaArticle.resume(index.entity_id)
            end
          end
          resume
        end
      end
      return resume
    end

    def get_tag_lists(keyword_id, curpage)
      #tag_view_count(@keyword)
      curpage = 1 unless curpage.to_i > 0
      kw = get_key("tag_lists_1", keyword_id, curpage)
      if curpage.to_i == 1
        return get_memcache(kw, 1.day) do
          tag_lists(keyword_id, curpage)
        end
      else
        #第2页起不使用缓存
        return tag_lists(keyword_id, curpage)
      end
    end

    def tag_lists(keyword_id, curpage)
      conditions = []
      conditions << "i.id = k.index_id and k.keyword_id = #{keyword_id}"
      lists = HejiaIndex.paginate(:select => "i.id, i.entity_type_id, i.title, i.entity_created_at, i.resume, i.url, i.image_url, i.image_url2, i.image_url3, i.image_url4, i.image_url5",
        :joins => "i, 51hejia_index.hejia_indexes_keywords k",
        :conditions => conditions.join(" and "),
        :order => "media_type_id desc, entity_created_at desc",
        :total_entries => HejiaIndex.get_tag_list_counter(keyword_id),
        :page => curpage.to_i)
      lists = [] if lists.nil?
      return lists
    end

    def get_tag_list_counter(keyword_id)
      kw = get_key("tag_list_counter_1", keyword_id)
      return get_memcache(kw, 3.days) do
        conditions = []
        conditions << "i.id = k.index_id and k.keyword_id = #{keyword_id}"
        HejiaIndex.count("i.id", :conditions => conditions.join(" and "), :joins => "i, 51hejia_index.hejia_indexes_keywords k")
      end
    end

    def get_zhuanqu_list_counter(keyword_id, entity_type_id)
      memkey = zhuanqu_list_memkey(keyword_id, entity_type_id, 'counter')
      Hejia::Cache.fetch(memkey, 3.days) do
        conditions = []
        conditions << "i.entity_id = r.entity_id and r.keyword_id = #{keyword_id} and r.relation_type = #{entity_type_id} and i.entity_type_id = #{entity_type_id}"
        HejiaIndex.count("i.id", :conditions => conditions.join(" and "), :joins => "i, relations r")
      end
    end

    #获取《装修日记》通过《栏目专区id》
    def diaries_by_zhuanqu_sort_id(zhuanqu_sort_id, limit=10)
      entity_type_id = 7
      max_limit = 10
      fail "The parameter named limit only maximum of #{max_limit}." if limit > max_limit
      key = "hejia_index_diaries_by_zhuanqu_sort_id_6_#{zhuanqu_sort_id}_#{entity_type_id}"
      indexes = CACHE.fetch(key, 1.hours) do
        keyword_ids = ZhuanquKw.get_kw_names_by_sort_id(zhuanqu_sort_id).map{ |e| HejiaIndexKeyword.keyword_to_id(e)}
        relations = Relation.find(:all,:select => 'distinct entity_id',
          :conditions => ["keyword_id in (?) and relation_type = ?", keyword_ids, entity_type_id],
          :order => 'entity_id desc', :limit => max_limit)
        entity_ids = relations.map{ |r| r.entity_id }
        diaries = HejiaIndex.find(:all, :select => 'title, url',
          :conditions => ["entity_id in (?) and entity_type_id = ?", entity_ids, entity_type_id], :order => "id desc")
        hezuo_diaries = []
        diaries.each do |diary|
          if firm_id = diary.url.split('/').delete_if{|x| !x.include?("gs")}[0].split('-')[1]
            hezuo_diaries << diary if DecoFirm.find_by_id(firm_id).is_cooperation == 1
          end
        end
        hezuo_diaries + (diaries - hezuo_diaries)
      end
      #如果取不满指定的记录数，用最新《装修日记》填充。
      if indexes.length < limit
        newdiaries = new_diaries(10)
        titles = indexes.map{ |r| r.title }
        0.upto(9) do |i|
          break if indexes.length == limit || newdiaries[i].nil?
          indexes << newdiaries[i] unless titles.include?(newdiaries[i].title)
        end
      end
      indexes[0...limit]
    end

    #获取最新《装修日记》
    def new_diaries(limit = 10, has_resume = 0)
      entity_type_id = 7
      if has_resume == 1
        max_limit = 2
      else
        max_limit = 10
      end
      fail "The parameter named limit only maximum of #{max_limit}." if limit > max_limit
      key = "hejia_index_new_diaries_9_#{max_limit}_#{has_resume}"
      indexes = Hejia::Cache.fetch(key, 2.hours) do
        relations = Relation.find(:all,:select => 'distinct entity_id',
          :conditions => ["relation_type = ?", entity_type_id],
          :order => 'id desc', :limit => max_limit)
        entity_ids = relations.map{ |r| r.entity_id }
        select = ['title','url']
        select << 'left(resume, 80) as resume' if has_resume == 1
        HejiaIndex.find(:all, :select => select.join(','),
          :conditions => ["entity_id in (?) and entity_type_id = ?", entity_ids, entity_type_id])
      end
      indexes[0...limit]
    end

  end

  # 和api推广兼容
  def SUMMARY
    description
  end

  def readonly?
    defined?(@readonly) && @readonly == true
  end

  def keywords
    key = "hejia_index_keywords_#{entity_id}"
    HejiaIndexKeyword
    CACHE.fetch(key, 3.days) do
      HejiaIndexKeyword.find(:all, :select=>"k.name", :joins=>"k, relations r",
        :conditions=>"k.id = r.keyword_id and r.entity_id = #{entity_id}").map{ |r| r.name}
    end
  end

end
