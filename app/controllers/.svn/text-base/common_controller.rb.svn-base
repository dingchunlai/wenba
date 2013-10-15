class CommonController < ApplicationController

  def user_navigation
    @user_id = current_user && current_user.USERBBSID || 0
    if @user_id > 0 && @user_id != session[:ind_id].to_i
      session[:ind_id] = @user_id
      session[:is_expert] = ""
      session[:is_expert] = "专家" if CommunityUser.is_expert(@user_id)
      session[:my_point] = CommunityUser.get_point(@user_id)
      session[:ask_num] = CommunityUser.get_question_num(@user_id)
      session[:answer_num] = CommunityUser.get_answer_num(@user_id)
    end
    render :partial => "user_navigation"
  end

  def user_entry
    render :partial => "user_entry"
  end
        
end