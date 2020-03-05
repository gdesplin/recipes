class CreateMealPlanDaysRecipes < ActiveRecord::Migration[6.0]

  def change
    create_join_table :meal_plan_days, :recipes do |t|
      t.index :meal_plan_day_id
      t.index :recipe_id
    end
  end

end
