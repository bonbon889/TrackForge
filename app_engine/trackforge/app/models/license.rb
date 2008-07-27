class License < ActiveRecord::Base

  def self.to_select
    find(:all).collect { |l| [l.name, l.id]}
  end

end