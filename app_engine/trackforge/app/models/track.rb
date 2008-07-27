class Track < ActiveRecord::Base
  named_scope :featured, :conditions => 'featured = true', :order => 'created_at desc', :limit => 1
  named_scope :latest, :order => 'created_at desc'
  named_scope :most_played, :order => 'views desc'

  belongs_to :user #, :counter_cache => true
  belongs_to :license
  
  acts_as_taggable
  #acts_as_activity :user, :if => Proc.new{|record| record.parent.nil?}
  acts_as_commentable
  
  has_attachment prepare_options_for_attachment_fu(AppConfig.audio['attachment_fu_options'])  
  
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :size
  validates_presence_of :content_type
  validates_presence_of :filename
  validates_presence_of :user, :if => Proc.new{|record| record.parent.nil? }
  validates_inclusion_of :content_type, :in => attachment_options[:content_type], :message => "is not allowed", :allow_nil => true
  validates_inclusion_of :size, :in => attachment_options[:size], :message => " is too large", :allow_nil => true

  attr_protected :user_id
  
  def to_param
    id.to_s << "-" << (name ? name.downcase.gsub(/[^a-z1-9]+/i, '-') : '' )
  end
  
  def slug
    name.gsub(/[^a-z1-9]+/i, '-').downcase
  end
  
end
