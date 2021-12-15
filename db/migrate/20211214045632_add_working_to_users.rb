class AddWorkingToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :working, :integer
  end
end
