class CreateNutrients < ActiveRecord::Migration[6.0]

  def change
    create_table :nutrients do |t|
      t.integer :food_data_central_id
      t.integer :number
      t.string :name
      t.integer :rank
      t.string :unit_name

      t.timestamps
    end
  end

end
