class CreateMealPlans < ActiveRecord::Migration[6.0]

  def change
    create_table :meal_plans do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :user_id
      t.index :user_id

      t.timestamps
    end
  end

end
