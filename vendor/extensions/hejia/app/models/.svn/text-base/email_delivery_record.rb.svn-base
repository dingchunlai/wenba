class EmailDeliveryRecord < Hejia::Db::Hejia
   belongs_to :resource, :polymorphic => true
   before_save :update_paint_worker_type
   
   
   private
  def update_paint_worker_type
     if self.resource_type == 'HejiaUserBbs'
       self.resource_type = HejiaUserBbs.get_user(self.resource_id).class.name
     end
  end

end