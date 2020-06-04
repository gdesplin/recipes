class CreateIngredientsNutrients < ActiveRecord::Migration[6.0]

  def change
    create_table :ingredients_nutrients do |t|
      t.integer :food_data_central_id
      t.decimal :amount
      t.decimal :gram_weight
      t.integer :nutrient_id
      t.index :nutrient_id
      t.integer :ingredient_id
      t.index :ingredient_id

      t.timestamps
    end
  end

end
