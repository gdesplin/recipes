class AddDataTypeToIngredients < ActiveRecord::Migration[6.0]

  def up
    execute <<-SQL
      CREATE TYPE ingredient_data_type AS ENUM ('branded', 'survey', 'legacy');
    SQL
    add_column :ingredients, :data_type, :ingredient_data_type
  end

  def down
    remove_column :ingredients, :data_type
    execute <<-SQL
      DROP TYPE ingredient_data_type;
    SQL
  end

end
