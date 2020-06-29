class Recipe < ApplicationRecord

  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes
  has_many :tags, through: :ingredients_tags
  belongs_to :user
  has_many_attached :images

  validates :title, presence: true, uniqueness: true
  validates :directions, :servings, presence: true

  accepts_nested_attributes_for :ingredients, :tags
  accepts_nested_attributes_for :ingredients_recipes, allow_destroy: true

  attr_accessor :servings_change

  def nutrients_data(show_more = nil)
    nutrients_data ||= {}
    self.ingredients_recipes.each do |ingredient_recipe|
      ingredient_recipe.ingredient.ingredients_nutrients.each do |ingredient_nutrient|
        amount = ingredient_nutrient.amount * ingredient_recipe.servings / servings
        amount *= (ingredient_recipe.gram_weight * 0.01) if ingredient_recipe.ingredient.data_type == "survey"
        amount = amount.floor(2)
        next unless amount.positive?
        nutrients_data[ingredient_nutrient.nutrient.name] ||= { amount: 0, total_amount: 0, unit_name: ingredient_nutrient.nutrient.unit_name, rank: ingredient_nutrient.nutrient.rank}
        nutrients_data[ingredient_nutrient.nutrient.name][:amount] += amount
        nutrients_data[ingredient_nutrient.nutrient.name][:total_amount] += amount * servings_change
      end
    end
    nutrients_data = nutrients_data.sort_by { |k, v| v[:rank] }
    return nutrients_data if show_more
    array_end = 10 > nutrients_data.length ? nutrients_data.length : 10
    nutrients_data[0..array_end]
  end

end
