class CreateRecipesTags < ActiveRecord::Migration[6.0]

  def change
    create_join_table :recipes, :tags do |t|
      t.index :recipe_id
      t.index :tag_id
      t.timestamps
    end
  end

end
