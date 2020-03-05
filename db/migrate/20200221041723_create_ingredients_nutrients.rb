class CreateIngredientsNutrients < ActiveRecord::Migration[6.0]

  def change
    create_join_table :ingredients, :nutrients do |t|
      t.string :type
      t.integer :food_data_central_id
      t.decimal :amount
      t.index :nutrient_id
      t.index :ingredient_id

      t.timestamps
    end
  end

end
