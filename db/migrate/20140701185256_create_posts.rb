class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string   :source
      t.integer  :tid       , :limit => 8
      t.datetime :published
      t.datetime :updated
      t.datetime :read
      t.datetime :clicked
      t.string   :text
      t.integer  :nfavorite
      t.integer  :nretweet
      t.integer  :score
      t.text     :json
      t.timestamps
    end
  end
end
