class Tag < ActiveRecord::Base
  acts_as_readonlyable [:read_only_51hejia]
  acts_as_cached

  class << self

    def get_tag_level(tag_id)
      tag_id = tag_id.to_i
      if tag_id == 0
        return 0
      else
        return 1 if Tag.level1_tags.include?(tag_id)
        return 2 if Tag.level2_tags.include?(tag_id)
        return 3
      end
    end

    def get_sub_tag_ids(parent_tag_id)
      tag_level = Tag.get_tag_level(parent_tag_id)
      return [] if tag_level ==0 || tag_level > 3
      ids, sub_ids, sub_sub_ids = [parent_tag_id], [], []
      if tag_level == 1 || tag_level == 2
        sub_ids = get_tags_by_parent_id(parent_tag_id).map{ |r| r.id }
        if tag_level == 1
          sub_ids.each do |sub_id|
            sub_sub_ids.concat(get_tags_by_parent_id(sub_id).map{ |r| r.id })
          end
        end
      end
      return ids.concat(sub_ids.concat(sub_sub_ids))
    end

    def get_tags_by_parent_id(parent_id)
      parent_id = parent_id.to_i
      kw = "tags_by_parent_id_#{parent_id}"
      return CACHE.fetch(kw, 2.hours) do
        if parent_id > 0
          #如果父ID非顶级
          Tag.find(:all,:select=>"id,name",:conditions=>["parent_id = ?", parent_id])
        else
          #如果父ID是顶级
          Tag.find(:all,:select=>"id,name",:conditions=>["id in (?)", Tag.level1_tags])
        end
      end
    end

    def level1_tags
      [1,38,173,265]
    end

    def level2_tags
      $level2_tags = Tag.find(:all, :select=>"id", :conditions=>["parent_id in (?)", Tag.level1_tags]).map{ |r| r.id } if $level2_tags.nil?
      return $level2_tags
    end

  end

end