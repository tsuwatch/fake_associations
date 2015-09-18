class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :follower_id
      t.integer :followed_id
    end
  end
end
