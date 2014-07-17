class AddIndicesToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :source
    add_index :posts, :tid
    add_index :posts, :read
  end
end
