# encoding: utf-8
# 关于地区的各种操作
# 每个地区有两个属性，code和name。
# code是地区代号；name是地区名称。
# 比如：上海，code可能就是shanghai，name就是“上海”。
module Hejia::Location
  WHOLE = {:pinyin => 'quanguo', :name => '全国'}

  def self.append_features(mod)
    mod.class_eval { alias_attribute :code, :pinyin }
    mod.extend ClassMethods
  end

  module ClassMethods
    # 返回所有城市（包括代号和名称）
    # @param [Hash] options 各种选项
    # @option options [Boolean] :reverse 是否取反。如果是true，返回的hash将是{name => code}。默认是{code => name}。
    # @option options [Boolean] :without_whole 是否去除全国。默认false。
    # @option options [Boolean] :sort 是否排序（按code递增排序）
    # @return options [Hash, Array[Array]] 如果指定了sort，返回一个二维数组；否则返回一个Hash。
    def all(options = nil)
      order = options.try(:[], :sort) || :desc
      order = :desc if order === true

      first_attribute, second_attribute = options.try(:[], :reverse) ? [:pinyin, :name] : [:name, :pinyin]

      all = super(:order => "pinyin #{order}").map! { |city| [city[first_attribute], city[second_attribute]] }
      all.unshift [WHOLE[first_attribute], WHOLE[second_attribute]] unless options.try(:[], :without_whole)
      all
    end

    # 根据城市代号，返回城市的名称。
    # @param [String] code 城市代号
    # @return [String] 城市名称
    def name_for_code(code)
      first(:conditions => {:pinyin => code}).try(:name) ||
        (WHOLE[:pinyin] == code ? WHOLE[:name] : nil)
    end

    # 根据城市名称，返回城市的代号。
    # @param [String] name 城市代号
    # @return [String] 城市代号
    def code_for_name(name)
      first(:conditions => {:name => name}).try(:pinyin) ||
        (WHOLE[:name] == name ? WHOLE[:pinyin] : nil)
    end

    # 返回所有城市名称
    def names
      all.map! &:first
    end

    # 返回所有城市代号
    def codes
      all.map! &:last
    end

    # 返回“全国”的代码和名称。
    def the_whole_contry
      WHOLE
    end
  end
end
