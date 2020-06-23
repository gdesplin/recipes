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
    recipe = Recipe.includes(
      ingredients_recipes: [
        ingredient: [
          ingredients_nutrients: [:nutrient],
        ],
      ],
    )
      .find(params[:id])
    @recipe_form = RecipeIngredientsNutrientsForm.new(recipe: recipe).load
  end

  def create
    @recipe_form = RecipeIngredientsNutrientsForm.new(safe_params).load
    if @recipe_form.save
      redirect_to @recipe_form.recipe
    else
      render :new
    end
  end

  def update
    recipe = Recipe.includes(
      ingredients_recipes: [
        ingredient: [
          ingredients_nutrients: [:nutrient],
        ],
      ],
    )
      .find(params[:id])
    recipe.assign_attributes(safe_params[:recipe_attributes])
    @recipe_form = RecipeIngredientsNutrientsForm.new(recipe: recipe, ingredients: safe_params[:ingredients]).load
    if @recipe_form.save
      puts "saved"
      redirect_to @recipe_form.recipe
    else
      puts "not saved?"
      render :edit
    end
  end

  private

  def safe_params
    params.require(:recipe_ingredients_nutrients_form).permit(%i[
    ] + [
      recipe_attributes: %i[
        title
        short_description
        servings
        cook_time_in_minutes
        prep_time_in_minutes
        directions
        private
      ] + [
        ingredients_recipes_attributes: %i[
          _destroy
          servings
          id
        ],
      ],
    ] + [
      ingredients: %i[
        name
        measurement_and_gram_weight
        brand_owner
        data_type
        servings
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
