class DownloadsController < BaseController

  before_filter :login_required, :only => :download
  
  def download
    @track = Track.find(params[:id])
    redirect_to @track.public_filename
  end
  
end