class Applicant < Hejia::Db::Hejia
  belongs_to :deco_firm
  include Hejia::FixTimestampZone
  validates_presence_of :name,:tel
  
  named_scope :applicat_top, lambda{ |limit|
    {
      :joins => 'join deco_firms on applicants.deco_firm_id = deco_firms.id',
      :select => "applicants.deco_firm_id,count(applicants.status) as count",
      :conditions => "applicants.status = 1 and applicants.confirm_at > '#{1.month.ago.to_date.to_s}'",
      :group => "applicants.deco_firm_id",
      :order => "count(applicants.status) desc, deco_firms.is_cooperation DESC,deco_firms.praise DESC",
      :limit => limit
    }
  }
  
  named_scope :for_city,lambda{|city_code| 
    city = ([11910,11905,31959,11908,11887].include? city_code.to_i) ? "city" : 'district'
    {
      :joins => 'join deco_firms on applicants.deco_firm_id = deco_firms.id',
      :conditions => ["#{city} = ?" , city_code]
    }
  }
  
  named_scope :confirmed, :conditions => "status = 1"

  def confirm_at
    time = read_attribute(:confirm_at)
    if time && time.utc?
      Time.local(time.year, time.month, time.day, time.hour, time.min, time.sec) + Hejia::FixTimestampZone.zone_offset
    end
  end
  
  class << self
    #return an array of columns(not column object) that should be listed on list view
    def list_columns
      re_array=self.content_columns.map do |column|
        column.name unless %w[updated_at style marker appointment_type].include? column.name
      end
      re_array.compact#.insert(0,'id')
    end

  end
end
