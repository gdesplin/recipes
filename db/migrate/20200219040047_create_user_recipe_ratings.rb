class CreateUserRecipeRatings < ActiveRecord::Migration[6.0]

  def change
    create_table :user_recipe_ratings do |t|
      t.integer :rating
      t.integer :recipe_id
      t.index :recipe_id
      t.integer :user_id
      t.index :user_id

      t.timestamps
    end
  end

end
