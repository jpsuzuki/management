class AddMoneyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :money, :integer,null: false,default: 955
  end
end
