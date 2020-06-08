class Recipe < ApplicationRecord

  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes
  has_many :tags, through: :ingredients_tags
  belongs_to :user

  validates :title, presence: true, uniqueness: true
  validates :directions, :servings, presence: true

  accepts_nested_attributes_for :ingredients, :tags

  attr_accessor :servings_change

  def nutrients_data
    nutrients_data ||= {}
    self.ingredients_recipes.each do |ingredient_recipe|
      ingredient_recipe.ingredient.ingredients_nutrients.each do |ingredient_nutrient|
        if ingredient_nutrient.amount&.positive?
          nutrients_data[ingredient_nutrient.nutrient.name] ||= { amount: 0, unit_name: ingredient_nutrient.nutrient.unit_name }
          nutrients_data[ingredient_nutrient.nutrient.name][:amount] += ingredient_nutrient.amount * ingredient_recipe.servings * servings_change
        end
      end
    end
    nutrients_data
  end

end
