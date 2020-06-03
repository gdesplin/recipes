class RecipesController < ApplicationController

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.includes(
      ingredients_recipes: [
        ingredient: [
          ingredients_nutrients: [:nutrient],
        ],
      ],
    )
      .find(params[:id])
    @recipe.servings_change = params[:servings_change]&.to_f || @recipe.servings
  end

  def destroy
  end

  def new
    @recipe_form = RecipeIngredientsNutrientsForm.new.load
  end

  def edit
  end

  def create
    puts "safe_params"
    puts safe_params
    puts "safe_params"
    @recipe_form = RecipeIngredientsNutrientsForm.new(safe_params).load
    if @recipe_form.save
      redirect_to @recipe_form.recipe
    else
      render :new
    end
  end

  def update
  end

  private

  def safe_params
    params.require(:recipe_ingredients_nutrients_form).permit(%i[
      title
      short_description
      servings
      cook_time_in_minutes
      prep_time_in_minutes
      directions
      private
    ] + [
      ingredients: %i[
        name
        measurement_type
        amount
        food_data_central_id
      ] + [
        nutrients: %i[
          food_data_central_id
          number
          name
          rank
          unit_name
          amount
          food_nutrient_id
        ],
      ],
    ]).merge(user_id: current_user.id)
  end

end
