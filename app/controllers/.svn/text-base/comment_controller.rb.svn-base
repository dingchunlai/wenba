class CommentController < ApplicationController
  def list_comment
    @company_id = params[:company_id]
    @comment_pages, @comments =  paginate(:ask_company_comments, :conditions=>['company_id =? and is_delete = 0',@company_id],
        :order => 'created_at DESC',
        :per_page => 10)

    render :layout => 'company_comment'
  end

  def add_comment
    company_id = params[:company_id]
    user_id = params[:user_id]
    design_ability = params[:design_ability]
    buget_reasonality = params[:buget_reasonality]
    construct_quality = params[:construct_quality]
    after_source = params[:after_source]
    recommend_designer = params[:recommend_designer]
    description = strip(params[:description])
    AskCompanyComment.save(company_id, user_id, design_ability, buget_reasonality, construct_quality, after_source, recommend_designer, description, request.remote_ip)
  
    redirect_to '/comment/list_comment'
  end
end
