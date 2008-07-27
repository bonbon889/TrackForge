class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks, :force => true do |t|
      t.column :name,            :string, :limit => 255
      t.column :description,     :text
      t.column :attribution,     :text
      t.column :url,             :string
      t.column :parent_id,       :integer
      t.column :thumbnail,       :string 
      t.column :filename,        :string, :limit => 255
      t.column :content_type,    :string, :limit => 255
      t.column :size,            :integer
      t.column :width,           :integer
      t.column :height,          :integer
      t.column :attachment_type,            :string
      t.column :user_id,         :integer
      t.column :comments_count,  :integer, :default => 0
      t.column :primary_genre_id,  :integer
      t.column :secondary_genre_id,  :integer
      t.column :license_id,      :integer
      t.column :track_type_id,   :integer
      t.column :views,           :integer, :default => 0
      t.column :downloads,           :integer, :default => 0
      t.column :cached_tag_list, :string
      t.column :featured,        :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
