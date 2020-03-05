class CreateUserFavoriteRecipes < ActiveRecord::Migration[6.0]

  def change
    create_table :user_favorite_recipes do |t|
      t.integer :recipe_id
      t.index :recipe_id
      t.integer :user_id
      t.index :user_id

      t.timestamps
    end
  end

end
