class CreateUserFriends < ActiveRecord::Migration[5.2]
  def change
    create_table :user_friends do |t|
      t.belongs_to :user
      t.integer :friend_id, null: false
      t.datetime
    end
  end
end
