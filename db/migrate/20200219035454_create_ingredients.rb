class CreateIngredients < ActiveRecord::Migration[6.0]

  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :food_data_central_id

      t.timestamps
    end
  end

end
