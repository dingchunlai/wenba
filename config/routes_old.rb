ActionController::Routing::Routes.draw do |map|
  
  map.connect '', :controller => "visitor"
  map.connect 'visitor/question/:id.html', :controller => 'visitor', :action => 'question'
  map.connect 'visitor/entry/:id.html', :controller => 'visitor', :action => 'entry'
  map.connect 'visitor/discussion/:id.html', :controller => 'visitor', :action => 'discussion'
  map.connect 'visitor/company/:id.html', :controller => 'visitor', :action => 'company'
  map.connect 'visitor/browse/:id.html', :controller => 'visitor', :action => 'browse'
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

  #map.connect '', :controller => 'list', :action => 'default'
  #map.connect 'list/index.html', :controller => 'list', :action => 'sort'
  #map.connect 'list/sort/:id.html', :controller => 'list', :action => 'sort'
  #map.connect 'q/:id.html', :controller => 'detail', :action => 'view'
  #map.connect 'visitor/question/:id.html', :controller => 'detail', :action => 'view'
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  
  map.connect "*anything", :controller => "visitor", :action => "unknown_request"
end