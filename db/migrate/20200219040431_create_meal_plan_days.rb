class CreateMealPlanDays < ActiveRecord::Migration[6.0]

  def change
    create_table :meal_plan_days do |t|
      t.datetime :date
      t.integer :meal_plan_id

      t.timestamps
    end
  end

end
