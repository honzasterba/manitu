ActionController::Routing::Routes.draw do |map|

  # public URLs
  map.home      '', :controller => "about"
  map.register  'registrace', :controller => "about", :action => "register"
  map.login     'login', :controller => "about", :action => "login"
  map.logout    'logout', :controller => "about", :action => "logout"
  map.confirm   'confirm/:id', :controller => "about", :action => "confirm"
  map.rss       'feed/:id', :controller => "about", :action => "rss"

  # private URLs
  map.manitu    'manitu', :controller => "manitu/monitoring"
  map.help_logout 'manitu/help/logout', :controller => "about", :action => "logout"
  map.help      'manitu/help/*names', :controller => "manitu/help", :action => "index"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  
  map.error   '*path', :controller => "about", :action => "not_found"
end
