class CreateIngredientsRecipes < ActiveRecord::Migration[6.0]

  def change
    create_table :ingredients_recipes do |t|
      t.integer :ingredient_id
      t.index :ingredient_id
      t.integer :recipe_id
      t.index :recipe_id
      t.string :measurement
      t.float :gram_weight
      t.float :servings, default: 1.0, null: false
      t.timestamps
    end
  end

end
