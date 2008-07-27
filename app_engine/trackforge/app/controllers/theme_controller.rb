class ThemeController < BaseController
  self.logger = nil
  # caches_page :stylesheets, :javascript, :images
  session :off

  def stylesheets
    render_theme_item(:stylesheets, params[:filename], 'text/css; charset=utf-8')
  end

  def javascript
    render_theme_item(:javascript, params[:filename], 'text/javascript; charset=utf-8')
  end

  def images
    render_theme_item(:images, params[:filename])
  end

  def error
    render :nothing => true, :status => 404
  end

  private

  def render_theme_item(type, file, mime = nil)
    #puts "Loading #{file}"
    mime ||= mime_for(file)
    if file.split(%r{[\\/]}).include?("..")
      return (render :text => "Not Found", :status => 404)
    end

    src = "#{RAILS_ROOT}/app_themes/#{AppConfig.theme}" + "/#{type}/#{file}"
    return (render :text => "Not Found", :status => 404) unless File.exists? src

    if perform_caching
      dst = "#{page_cache_directory}/#{type}/theme/#{file}"
      FileUtils.makedirs(File.dirname(dst))
      FileUtils.cp(src, "#{dst}.#{$$}")
      FileUtils.ln("#{dst}.#{$$}", dst) rescue nil
      FileUtils.rm("#{dst}.#{$$}", :force => true)
    end

    send_file(src, :type => mime, :disposition => 'inline', :stream => true)
  end


  def send_file_cached(path, options = {})
    unloaded = false
    begin
      since = request.env['HTTP_IF_MODIFIED_SINCE']
      since = Time.httpdate(since) rescue Time.parse(since)
    rescue
      unloaded = true
    end
    modified = File.mtime(path)
    headers['ETag'] = modified.to_i.to_s
    headers.delete("Cache-Control")
    if unloaded or (since &lt; modified)
      if options[:expires_in]
        expires_in options[:expires_in]
        # make IE behave
        if (request.env['HTTP_USER_AGENT'] || "").include? "MSIE" 
          headers['Cache-Control'] =
            "post-check=#{options[:expires_in]}, " +
            "pre-check=#{options[:expires_in]}" 
        end
        options.delete(:expires_in)
      end
      headers['Last-Modified'] = CGI::rfc1123_date(modified)
      send_file path, options
    else
      render :nothing => true, :status => '304 Not Modified'
    end
  end



  def mime_for(filename)
    case filename && filename.downcase
    when /\.js$/
      'text/javascript'
    when /\.css$/
      'text/css'
    when /\.gif$/
      'image/gif'
    when /(\.jpg|\.jpeg)$/
      'image/jpeg'
    when /\.png$/
      'image/png'
    when /\.swf$/
      'application/x-shockwave-flash'
    else
      'application/binary'
    end
  end


end