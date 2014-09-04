class AddScoreDecayedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :score_decayed, :integer
    add_index  :posts, :score_decayed
    add_index  :posts, :published
  end
end
