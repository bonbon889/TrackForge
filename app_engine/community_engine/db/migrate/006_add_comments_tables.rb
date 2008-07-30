class AddCommentsTables < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true do |t|
      t.column :title, :string
      t.column :comment, :string
      t.column :created_at, :datetime
      t.column :commentable_id, :integer
      t.column :commentable_type, :string
      t.column :user_id, :integer
      t.column :recipient_id, :integer
    end

    add_index :comments, ["user_id"], :name => "fk_comments_user"
  end

  def self.down
    drop_table :comments
  end
end
