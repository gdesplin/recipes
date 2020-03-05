class CreateIngredientsRecipes < ActiveRecord::Migration[6.0]

  def change
    create_join_table :ingredients, :recipes do |t|
      t.index :ingredient_id
      t.index :recipe_id
      t.timestamps
    end
  end

end
