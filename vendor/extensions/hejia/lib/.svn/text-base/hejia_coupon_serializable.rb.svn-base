# 调用方式
# Model文件
# include HeJiaCouponSerializable
# hejia_set_serialization (0..9).to_a.concat(('A'..'Z').to_a) 或 hejia_set_serialization (0..9).to_a.concat(('A'..'Z').to_a), 'hejia:coupon:tag'

# Model 类方法
# Model.next_success(key)
# Example : Tag.next_success('hejia:coupon:tag') (A..Z)(0..9)

# Model 实例方法
# Model.instance.next_success(key)
# Example : ProductionCategory.instance.next_success('hejia:coupon:tag_a')
# Example : Coupon.instance.next_success('hejia:coupon:sh:tag_a')

module HejiaCouponSerializable

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval {
      include InstanceMethods
    }
  end

  module ClassMethods
    def hejia_set_serialization(serial = [])
      raise ArgumentError, 'serial must be a Array' unless serial.is_a?(Array)
      @_serial = serial
    end

    def seralization_enumarator
      @_serial
    end
  end

  module InstanceMethods
    def next_success
      value = Hejia[:redis].incr serialization_key
      if self.class.seralization_enumarator.empty?
        value
      else
        raise 'Out of range!' if self.class.seralization_enumarator[value - 1].nil?
        self.class.seralization_enumarator[value - 1]
      end
    end

    def serialization_key
      ""      
    end

  end
  
end
