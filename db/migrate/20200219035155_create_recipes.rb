class CreateRecipes < ActiveRecord::Migration[6.0]

  def change
    create_table :recipes do |t|
      t.integer :user_id
      t.index :user_id
      t.string :title
      t.string :short_description
      t.float :servings
      t.integer :cook_time_in_minutes
      t.integer :prep_time_in_minutes
      t.text :directions
      t.boolean :private

      t.timestamps
    end
  end

end
