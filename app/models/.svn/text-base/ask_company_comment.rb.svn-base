class AskCompanyComment < ActiveRecord::Base
  def self.save(company_id,user_id,design_ability,buget_reasonality,construct_quality,after_source,recommend_designer,description,ip,is_delete= 0)
    transaction(){
    acc = AskCompanyComment.new
    acc.company_id = company_id
    acc.user_id = user_id
    acc.design_ability = design_ability
    acc.buget_reasonality = buget_reasonality
    acc.construct_quality = construct_quality
    acc.after_source = after_source
    acc.recommend_designer = recommend_designer
    acc.description = description
    acc.ip = ip
    acc.is_delete = is_delete
    acc.save

    ohc = OracleHejiaCompany.find(company_id)
    if ohc.designability.nil?
      ohc.designability = design_ability.to_i
    else
      ohc.designability += design_ability.to_i
    end
    if ohc.bugetreqnsonality.nil?
       ohc.bugetreqnsonality = buget_reasonality.to_i
    else
      ohc.bugetreqnsonality += buget_reasonality.to_i
    end
    if ohc.constractquality.nil?
       ohc.constractquality = construct_quality.to_i
    else
      ohc.constractquality += construct_quality.to_i
    end
    if ohc.afterservice.nil?
      ohc.afterservice = after_source.to_i
    else
      ohc.afterservice += after_source.to_i
    end
    ohc.save
    }
  end
end
