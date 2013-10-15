class CaseDetail < Hejia::Db::Hejia
  
  # hejia_case_id
  # family_members
  # construction_area 建筑面积
  # real_area 使用面积
  # job 职业
  # hard_decoration_cost 硬装修
  # soft_decoration_cost 软装修
  # design_cost 设计费
  # management_cost 管理费
  # labor_cost 人工费
  # total_cost 总计费用
  
  
  belongs_to :hejia_case
  
  before_save :calculate_total_cost

private

  def calculate_total_cost
    self.total_cost = [hard_decoration_cost.to_f, soft_decoration_cost.to_f, design_cost.to_f, management_cost.to_f, labor_cost.to_f, tax.to_f].sum
  end
  
end