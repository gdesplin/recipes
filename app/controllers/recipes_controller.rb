class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def edit
  end

  def create
    @recipe = current_user.recipes.new(safe_params)
    if @recipe.save
      redirect_to @recipe
    else
      render :new
    end
  end

  def update
  end

  def destroy
  end

  private

  def safe_params
    params.require(:recipe).permit(%i[
      title
      short_description
      servings
      cook_time_in_minutes
      prep_time_in_minutes
      directions
      private
    ] + [
      ingredients_attributes: %i[
        name
        measurment_type
        amount
        food_data_central_id
      ] + [
        nutrient_attributes: %i[
          food_data_central_id
          number
          name
          rank
          unit_name
        ],
      ],
    ])
  end

end
