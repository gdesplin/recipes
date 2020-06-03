class Recipe < ApplicationRecord

  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes
  has_many :tags, through: :ingredients_tags
  belongs_to :user

  validates :title, presence: true, uniqueness: true
  validates :directions, presence: true

  accepts_nested_attributes_for :ingredients, :tags

  attr_accessor :servings_change

end
