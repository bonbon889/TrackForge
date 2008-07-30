class Genre < ActiveRecord::Base
  named_scope :primaries, :conditions => {:main => true}
  
  def slug
    #CGI::escape(name)
    n = name
    n = n.gsub(/[\?]/, '-')
    n = n.gsub(/[\/]/, '%2f')
    n = n.gsub(/[\.]/, '-')
    n = n.gsub(/[\;]/, '-')
  end
    
  
end
