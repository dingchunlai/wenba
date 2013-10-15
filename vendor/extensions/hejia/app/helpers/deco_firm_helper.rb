# encoding: utf-8
# encoding: utf-8
module DecoFirmHelper

  # According to the company target a specific url or code generation
  # params[:firm_id]  (DecoFirm or firm_id)
  # return firm_url
  def generate_firm_url firm_id
    Hejia[:cache].fetch("/generate/firms/firm_url/#{firm_id}", 1.day) do
      firm = DecoFirm.find firm_id
      "http://z.#{firm.city_pinyin}.51hejia.com/#{firm.id}/"
    end
  end
end
