# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_04_172555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

# Could not dump table "ingredients" because of following StandardError
#   Unknown type 'ingredient_data_type' for column 'data_type'

  create_table "ingredients_nutrients", force: :cascade do |t|
    t.integer "food_data_central_id"
    t.decimal "amount"
    t.decimal "gram_weight"
    t.integer "nutrient_id"
    t.integer "ingredient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ingredient_id"], name: "index_ingredients_nutrients_on_ingredient_id"
    t.index ["nutrient_id"], name: "index_ingredients_nutrients_on_nutrient_id"
  end

  create_table "ingredients_recipes", force: :cascade do |t|
    t.integer "ingredient_id"
    t.integer "recipe_id"
    t.string "measurement"
    t.float "gram_weight"
    t.float "servings", default: 1.0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ingredient_id"], name: "index_ingredients_recipes_on_ingredient_id"
    t.index ["recipe_id"], name: "index_ingredients_recipes_on_recipe_id"
  end

  create_table "meal_plan_days", force: :cascade do |t|
    t.datetime "date"
    t.integer "meal_plan_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "meal_plan_days_recipes", id: false, force: :cascade do |t|
    t.bigint "meal_plan_day_id", null: false
    t.bigint "recipe_id", null: false
    t.index ["meal_plan_day_id"], name: "index_meal_plan_days_recipes_on_meal_plan_day_id"
    t.index ["recipe_id"], name: "index_meal_plan_days_recipes_on_recipe_id"
  end

  create_table "meal_plans", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_meal_plans_on_user_id"
  end

  create_table "meals", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_meals_on_user_id"
  end

  create_table "nutrients", force: :cascade do |t|
    t.integer "food_data_central_id"
    t.integer "number"
    t.string "name"
    t.integer "rank"
    t.string "unit_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "short_description"
    t.float "servings", default: 1.0, null: false
    t.integer "cook_time_in_minutes"
    t.integer "prep_time_in_minutes"
    t.text "directions"
    t.boolean "private"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "recipes_tags", id: false, force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_recipes_tags_on_recipe_id"
    t.index ["tag_id"], name: "index_recipes_tags_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_favorite_recipes", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_user_favorite_recipes_on_recipe_id"
    t.index ["user_id"], name: "index_user_favorite_recipes_on_user_id"
  end

  create_table "user_recipe_ratings", force: :cascade do |t|
    t.integer "rating"
    t.integer "recipe_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_user_recipe_ratings_on_recipe_id"
    t.index ["user_id"], name: "index_user_recipe_ratings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
