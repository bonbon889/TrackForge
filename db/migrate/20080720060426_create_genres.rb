class CreateGenres < ActiveRecord::Migration
  def self.up
    create_table "genres", :force => true do |t|
      t.integer  "code",          :limit => 255
      t.string   "name"
      t.boolean  "main",                         :default => true
      t.integer  "position",                     :default => 0
      t.integer  "tracks_count",                 :default => 0
      t.integer  "parent_id",
      t.timestamps
    end
  end

  def self.down
  end
end
