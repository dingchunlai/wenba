module Hejia
  module FixTimestampZone
    class << self; attr_reader :zone_offset end
    @zone_offset = Time.local(Time.now.year, 1, 1).utc_offset.freeze

    def self.append_features(mod)
      unless Time.respond_to?(:zone)
        mod.__send__ :include, InstanceMethods
        mod.default_timezone = :utc
      end
    end

    module InstanceMethods
      def created_at
        time = read_attribute(:created_at)
        if time && time.utc?
          Time.local(time.year, time.month, time.day, time.hour, time.min, time.sec) + Hejia::FixTimestampZone.zone_offset
        end
      end

      def updated_at
        time = read_attribute(:updated_at)
        if time && time.utc?
          Time.local(time.year, time.month, time.day, time.hour, time.min, time.sec) + Hejia::FixTimestampZone.zone_offset
        end
      end
    end
  end
end
