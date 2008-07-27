module BlockHelper
  
  def content_block(id = "", css_class = "red", &block)
    body = capture(&block) if block_given?
    render :file => "shared/_container.html.haml", :locals => {:id => id, :css_class => css_class, :body => body}
  end
  
  def sidebar_block(id = "", css_class = "red", &block)
    body = capture(&block) if block_given?
    render :file => "shared/_side_bar.html.haml", :locals => {:id => id, :css_class => css_class, :body => body}
  end
  
end