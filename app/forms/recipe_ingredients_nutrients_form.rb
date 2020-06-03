class RecipeIngredientsNutrientsForm

  include ActiveModel::Model

  attr_accessor(
    :recipe,
    :ingredients,
    :user_id,
    :title,
    :short_description,
    :servings,
    :cook_time_in_minutes,
    :prep_time_in_minutes,
    :directions,
    :private,
  )

  def load
    self.recipe = Recipe.new(
      title: title,
      short_description: short_description,
      servings: servings,
      cook_time_in_minutes: cook_time_in_minutes,
      prep_time_in_minutes: prep_time_in_minutes,
      directions: directions,
      user_id: user_id,
    )
    self.ingredients = ingredients || recipe.ingredients
    self
  end

  def save
    recipe.save!
    ingredients.each do |ingredient|
      new_ingredient = Ingredient.create_with(name: ingredient[:name])
        .find_or_initialize_by(food_data_central_id: ingredient[:food_data_central_id])
      if new_ingredient.new_record?
        new_ingredient.save!
        save_nutrients(ingredient[:nutrients], new_ingredient)
      end
      recipe.ingredients_recipes.create!(
        ingredient: new_ingredient,
        measurment_type: ingredient[:measurment_type],
        amount: ingredient[:amount],
      )
    end
  end

  def save_nutrients(nutrients, ingredient)
    puts "saving nutrients"
    nutrients.each do |nutrient|
      puts "nutrient **********************"
      puts nutrient.inspect
      new_nutrient = Nutrient.create_with(
        name: nutrient[:name],
        number: nutrient[:number],
        rank: nutrient[:rank],
        unit_name: nutrient[:unit_name],
      ).find_or_create_by(food_data_central_id: nutrient[:food_data_central_id])
      puts "new_nutrient"
      puts new_nutrient
      ingredient.ingredients_nutrients.create!(
        nutrient: new_nutrient,
        amount: nutrient[:amount],
        food_data_central_id: nutrient[:food_nutrient_id],
      )
    end
  end

end
