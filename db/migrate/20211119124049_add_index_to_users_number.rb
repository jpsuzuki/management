class AddIndexToUsersNumber < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :number, unique: true
  end
end
