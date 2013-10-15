# 所有用到的数据库
# 用到哪个数据库的model，就继承相应的类。
module Hejia
  module Db
    class Base < ActiveRecord::Base
      self.abstract_class = true

      def self.uses_database(database)
        config = configurations[defined?(Rails.env) ? Rails.env : RAILS_ENV]
        key = config.has_key?('database') && 'database' || :database
        establish_connection config.merge(key => database)
      end
    end

    class Hejia < Base
      self.abstract_class = true
      uses_database '51hejia'
    end

    class Product < Base
      self.abstract_class = true
      uses_database 'product'
    end

    class Index < Base
      self.abstract_class = true
      uses_database '51hejia_index'
    end

    class Forum < Base
      self.abstract_class = true
      uses_database '51hejia_forum'
    end

    class HejiaProduct < Base
      self.abstract_class = true
      uses_database '51hejia_product'
    end
  end
end
