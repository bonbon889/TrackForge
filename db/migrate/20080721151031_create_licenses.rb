class CreateLicenses < ActiveRecord::Migration
  def self.up
    create_table :licenses, :force => true do |t|
      t.string :name, :description, :detail_url, :license_url
      t.text   :full_description
      t.string 
      t.timestamps
    end
  end

  def self.down
    drop_table :licenses
  end
end
