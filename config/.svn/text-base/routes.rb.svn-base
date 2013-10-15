ActionController::Routing::Routes.draw do |map|

  map.connect 'visitor/entry/:id.html', :controller => 'visitor', :action => 'entry'
  map.connect 'visitor/discussion/:id.html', :controller => 'visitor', :action => 'discussion'
  map.connect 'visitor/company/:id.html', :controller => 'visitor', :action => 'company'
  
  map.connect 'visitor/entrybrowse/:id.html', :controller => 'visitor', :action => 'entrybrowse'
  map.connect 'visitor/discussionbrowse/:id.html', :controller => 'visitor', :action => 'discussionbrowse'
  map.connect 'visitor/u/:uid.html', :controller => 'visitor', :action => 'u'
  map.connect 'visitor/ut/:utid.html', :controller => 'visitor', :action => 'ut'
  map.connect 'visitor/entryut/:utid.html', :controller => 'visitor', :action => 'entryut'
  map.connect 'visitor/discussionut/:utid.html', :controller => 'visitor', :action => 'discussionut'
  map.connect 'editor/show/:id.html', :controller => 'editor', :action => 'show'
  map.connect 'rest/s', :controller => 'rest', :action => 's'
  map.connect 'delete_topic/:tid/:tagid/:uid', :controller => 'user', :action => 'delete_topic'
  map.connect 'delete_post/:pid/:uid/:tid', :controller => 'user', :action => 'delete_post'

  map.connect '', :controller => 'list', :action => 'default'
  map.connect 'list/s/:tag_id.html', :controller => 'list', :action => 'sort'
  map.connect 'list/sort/:tag_id.html', :controller => 'list', :action => 'sort'
  map.connect 'visitor/browse/:tag_id.html', :controller => 'list', :action => 'sort'
  

  map.connect 'q/:id.html', :controller => 'detail', :action => 'view'
  map.connect 'visitor/question/:id.html', :controller => 'detail', :action => 'view'
  map.connect 'expert_index/:expert_id.html', :controller => 'expert', :action => 'index'
  map.connect 'user_question/:user_id.html', :controller => 'list', :action => 'user_question'
  map.connect 'user_answer/:user_id.html', :controller => 'list', :action => 'user_answer'
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  
end