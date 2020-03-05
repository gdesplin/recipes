Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  resources :recipes
  resources :user_favorite_recipes, only: %i[post update destroy]
  resources :user_recipe_rating, only: %i[post update destroy]
  root to: "recipes#index"
end
