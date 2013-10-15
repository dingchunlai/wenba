class UploadController < ApplicationController

  def uploadfile
    save_path = params[:save_path]
    save_path = "/uploads/" if trim(save_path).length == 0
    if params[:upload_save].nil?
      render :layout => false
    else
      @imgurl = get_file(params[:FindFile], save_path, 100)
    end
  end

end
