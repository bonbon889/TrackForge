ActionController::Routing::Routes.draw do |map|

  map.invite '/invite', :controller => 'users', :action => 'invite'

  map.popular '/popular', :controller => 'tracks', :action => 'popular'
  map.popular_rss '/popular.rss', :controller => 'tracks', :action => 'popular', :format => 'rss'
  
  map.recent '/recent', :controller => 'tracks', :action => 'recent'
  map.recent_rss '/recent.rss', :controller => 'tracks', :action => 'recent', :format => 'rss'

  map.upload  '/:user_id/upload', :controller => 'tracks', :action => 'new'

  map.play      '/play/:id/:filename', :controller => 'downloads', :action => 'play', :filename => /.*/
  map.download  '/download/:id/:filename', :controller => 'downloads', :action => 'download', :filename => /.*/


  map.from_plugin :community_engine
  
  

  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
