class TracksController < BaseController
  self.allow_forgery_protection = false
  # before_filter :login_required, :only => [:new, :edit, :update, :destroy, :create, :manage]
  before_filter :find_user, :only => [:new, :edit, :index, :show, :update_view, :manage]
  # before_filter :require_ownership_or_moderator, :only => [:create, :edit, :update, :destroy, :manage]

  uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:new, :edit, :update, :create ])
  uses_tiny_mce(:options => AppConfig.simple_mce_options, :only => [:show])
  
  def index
    
  end
  
  def popular
    @tags = popular_tags(100, ' count DESC')
    @pages, @tracks = paginate :tracks, :order => 'views DESC', :per_page => 20
  end
  
  def recent
    @tags = popular_tags(100, ' count DESC')
    @pages, @tracks = paginate :tracks, :order => 'created_at DESC', :per_page => 20
  end
  
  def show
    @track = Track.find(params[:id]) if params[:id]
  end
  
  def new
    @track = Track.new
  end
  
  def create
    @user = current_user

    @track = Track.new(params[:track])
    @track.user = @user

    respond_to do |format|
      if @track.save
        @track.tag_with(params[:tag_list] || '') 
        #start the garbage collector
        GC.start        
        flash[:notice] = 'Track was successfully created.'
        
        format.html { 
          render :action => 'inline_new', :layout => false and return if params[:inline]
          redirect_to user_track_url(:id => @track, :user_id => @track.user) 
        }
        format.js {
          responds_to_parent do
            render :update do |page|
              page << "upload_image_callback('#{@track.public_filename()}', '#{@track.display_name}', '#{@track.id}');"
            end
          end                
        }
      else
        format.html { 
          render :action => 'inline_new', :layout => false and return if params[:inline]                
          render :action => "new" 
        }
        format.js {
          responds_to_parent do
            render :update do |page|
              page.alert('Sorry, there was an error uploading the track.')
            end
          end                
        }
      end
    end
  end

  def require_ownership_or_moderator
    @user ||= User.find(params[:user_id] || params[:id] )
    unless admin? || moderator? || (@user && (@user.eql?(current_user)))
      redirect_to :controller => 'sessions', :action => 'new' and return false
    end
    return @user
  end
end
