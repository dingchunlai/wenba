module ListHelper

  #取得明星专家
  def get_star_tops(limit=10)
    kw = "star_tops_2"
    HejiaUserBbs
    #rs = CACHE.fetch(kw, 1.day) do
      new_star_tops=[]
      star_tops = HejiaUserBbs.find(:all,:select=>"bbsid,username,point,deco_id,headimg",:conditions=>"USERTYPE=100 and deco_id is not null and !( length(`bbsid`) >18 ) ",:order=>"POINT desc",:limit=>10)
      for star in star_tops
        case_id=HejiaCase.getCaseIdByBBSID(star.bbsid)
        href = "http://z.51hejia.com/firms/gs-#{star.deco_id}/case/#{case_id}"
        href = '#' if case_id=='#'
        star[:href]=href
        image=star[:headimg].to_s
        image="http://img.51hejia.com/files/designer/"+image unless image.starts_with?("http")
        star[:headimg]=image
        new_star_tops << star
      end
     rs = new_star_tops
    #end
    return rs[0...limit]
  end

end
