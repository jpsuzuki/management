class CreateWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :works do |t|
      t.time :start
      t.time :finish
      t.date :day
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
