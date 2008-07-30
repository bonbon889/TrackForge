class BaseController < ApplicationController
  
  def site_index

    #@posts = Post.find_recent(:limit => 5)
    @featured = Track.featured
                         
    @rss_title = "#{AppConfig.community_name} Recent Posts"
    @rss_url = rss_url
    respond_to do |format|     
     format.html { get_additional_homepage_data }
     format.rss do
       # render_rss_feed_for(@posts, { :feed => {:title => "#{AppConfig.community_name} Recent Posts", :link => recent_url},
       #          :item => {:title => :title, :link => :link_for_rss, :description => :post, :pub_date => :published_at} 
       #          })        
     end
    end    
            
  end
  
  def access_denied
    respond_to do |accepts|
      accepts.html do
        store_location
        flash[:notice] = 'You need to be logged in to access that page.'
        redirect_to(:controller => '/sessions', :action => 'new') and return false
      end
      accepts.xml do
        headers["Status"]           = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "Could't authenticate you", :status => '401 Unauthorized'
      end
    end
    false
  end  

  def get_additional_homepage_data
    @sidebar_right = true
    @homepage_features = HomepageFeature.find_features
    @homepage_features_data = @homepage_features.collect {|f| [f.id, f.public_filename(:large) ]  }    
    
    # @active_users = User.find_by_activity({:limit => 5, :require_avatar => false})
    # @featured_writers = User.find_featured
    # 
    # @featured_posts = Post.find_featured
    # 
    # @topics = Topic.find(:all, :limit => 5, :order => "replied_at DESC")
    # 
    # @active_contest = Contest.get_active
    # @popular_posts = Post.find_popular({:limit => 10})    
    # @popular_polls = Poll.find_popular(:limit => 8)
  end

  # fix for postgres db
  def popular_tags(limit = nil, order = ' tags.name ASC', type = nil)
    sql = "SELECT tags.id, tags.name, count(*) AS count 
      FROM taggings, tags 
      WHERE tags.id = taggings.tag_id "
    sql += " AND taggings.taggable_type = '#{type}'" unless type.nil?      
    sql += " GROUP BY tags.id, tags.name"
    sql += " ORDER BY #{order}"
    sql += " LIMIT #{limit}" if limit
    Tag.find_by_sql(sql).sort{ |a,b| a.name.downcase <=> b.name.downcase}
  end
  
end