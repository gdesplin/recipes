class CreateMeals < ActiveRecord::Migration[6.0]

  def change
    create_table :meals do |t|
      t.integer :user_id
      t.index :user_id
      t.string :title
      t.string :type

      t.timestamps
    end
  end

end
