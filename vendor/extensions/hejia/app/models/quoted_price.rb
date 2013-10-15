class QuotedPrice < Hejia::Db::Hejia
  belongs_to :deco_firm
  acts_as_list :scope => :deco_firm_id

  validates_presence_of :price,:room,:area,:type,:message => "不能为空"
  validates_numericality_of :price,:area ,:message => "需为数字"
  validates_inclusion_of :room,:in => FACTORY_FANGXING.keys ,:message => "选择错误"
  validates_inclusion_of :deco_type,:in => QUOTE_PRICE_TYPE.keys ,:message => "选择错误"
  
  def method_name
    
  end
  
  class << self
    #return an array of columns that should be listed on list view
    def list_columns
      re_array=self.content_columns.map do |column|
        column.name unless %w[created_at updated_at position].include? column.name
      end
      re_array.compact#.insert(0,'id')
    end
      
  end

  def show_error_on(column)
    column_error=self.errors.on(column.to_sym)
    column_error.class==Array ? column_error.join('；') : column_error
  end

  def room_selected(params)
    return params[:quoted_price][:room].to_i unless params[:quoted_price].nil?
    self.room||0
  end
  
  def price_text
    self.price.to_i == self.price ? self.price.to_i : self.price
  end

end
