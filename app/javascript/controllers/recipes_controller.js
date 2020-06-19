import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["searchTerm", "searchResultsList", "searchResults", "ingredientsList", "addedIngredients"]
  connect() {
    self = this
    self.targets.addedIngredients = []
    self.targets.searchResults = []
  }
  search(event) {
    event.preventDefault()
    event.stopImmediatePropagation()
    self.searchResultsListTarget.innerHTML = 
    `<div class="spinner-border" role="status">
      <span class="sr-only">Loading...</span>
    </div>`
    fetch(`https://api.nal.usda.gov/fdc/v1/foods/search?api_key=eiQ7AFUmqPEr6SyLF4uviQdiOhkrQZEgDrmlajbZ&query=${self.searchTermTarget.value}&pageSize=10&pageNumber=1`)
    .then(response => response.json())
    .then(json => {
      if (json.foods.length == 0) { return }

      let searchResultsHtml = ""
      self.targets.searchResults = []
      let fdcIds = json.foods.map(food => food.fdcId)
      fetch(`https://api.nal.usda.gov/fdc/v1/foods/?fdcIds=${fdcIds}&api_key=eiQ7AFUmqPEr6SyLF4uviQdiOhkrQZEgDrmlajbZ`)
      .then(responseDetail => responseDetail.json())
      .then(jsonDetail => {
        self.targets.searchResults = jsonDetail
        self.updateResultsList()
      })
    })
  }
  addIngredient() {
    const ingredientFdcId = parseInt(event.currentTarget.getAttribute("value"))
    const ingredient = self.targets.searchResults.find(ingredient => ingredient.fdcId === ingredientFdcId)
    self.targets.addedIngredients.push(ingredient)
    self.updateIngredientList()
  }

  removeIngredient() {
    const ingredientFdcId = parseInt(event.currentTarget.getAttribute("value"))
    self.targets.addedIngredients = _.reject(self.targets.addedIngredients, function(ingredient) { return ingredient.fdcId === ingredientFdcId; });
    self.updateIngredientList()
  }

  updateIngredientList() {
    if (!self.targets.addedIngredients.length) {
      return
    }
    let addedIngredientsHTML = ""
    self.targets.addedIngredients.forEach((ingredient) => {
      if (ingredient.dataType === "Branded") {
        addedIngredientsHTML += addIngredientBrandedTemplate(ingredient)
      } else {
        addedIngredientsHTML += addIngredientSurveyTemplate(ingredient)
      }
      self.targets.searchResults = self.targets.searchResults.filter(result => result.fdcId !== ingredient.fdcId);
      self.updateResultsList()
    })
    self.ingredientsListTarget.innerHTML = addedIngredientsHTML;
  }

  updateResultsList() {
    if (!self.targets.searchResults.length) {
      return
    }
    let searchResultsHTML = ""
    self.targets.searchResults.forEach((result) => {
      searchResultsHTML += resultTemplate(result)
    })
    self.searchResultsListTarget.innerHTML = searchResultsHTML;
  }
}


function resultTemplate(result) {
  if ("brandOwner" in result) {
    var description = `${[result.description, result.brandOwner].join(": ")}`
  } else {
    var description = result.description
  }
  return `
    <div data-fdcId="${result.fdcId}" class="mb-2">
      <button class="btn btn-primary" data-action="click->recipes#addIngredient" value="${result.fdcId}">Add</button>
      ${description}
    </div>
  `
}

function addIngredientSurveyTemplate(ingredient) {
  let html = `
    <div class="list-group-item">
      <button type="button" class="close ml-2 text-danger" aria-label="Remove" data-action="click->recipes#removeIngredient" value="${ingredient.fdcId}">
        <span aria-hidden="true">&times;</span>
      </button>
      <div class="list-group list-group-horizontal">
        <li class="list-group-item flex-fill">${ingredient.description}</li>
        <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][name]]" value="${ingredient.description}">
        <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][food_data_central_id]]" value="${ingredient.fdcId}">
        <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][data_type]]" value="survey">
        <li class="list-group-item flex-fill">Servings: <input type="number" name="recipe_ingredients_nutrients_form[ingredients[][servings]]"></input></li>
        <li class="list-group-item flex-fill">
          <select name="recipe_ingredients_nutrients_form[ingredients[][measurement_and_gram_weight]]">
  `
  ingredient.foodPortions.forEach((foodPortion) => {
    if  (ingredient.dataType === "Survey (FNDDS)") {
      var value = {gram_weight: foodPortion.gramWeight, measurement: foodPortion.portionDescription}
    } else {
      var value = {gram_weight: foodPortion.gramWeight, measurement: foodPortion.modifier}
    }
    html += `
      <option value='${JSON.stringify(value)}'>${value.measurement}</option>
    `
  })
  html += `
    </select>
  `
  ingredient.foodNutrients.forEach((foodNutrient) => {
    html += `
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][food_data_central_id]]]" value="${foodNutrient.nutrient.id}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][name]]]" value="${foodNutrient.nutrient.name}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][number]]]" value="${foodNutrient.nutrient.number}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][rank]]]" value="${foodNutrient.nutrient.rank}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][unit_name]]]" value="${foodNutrient.nutrient.unitName}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][amount]]]" value="${foodNutrient.amount}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][food_nutrient_id]]]" value="${foodNutrient.id}">
    `
  })
  html += `
      </div>
    </div>
  `
  return html
}

function addIngredientBrandedTemplate(ingredient) {
  let gram_weight_and_measurement = {gram_weight: ingredient.servingSize, measurement: ingredient.householdServingFullText}
  let html = `
    <div class="list-group-item">
      <button type="button" class="close ml-2 text-danger" aria-label="Remove" data-action="click->recipes#removeIngredient" value="${ingredient.fdcId}">
        <span aria-hidden="true">&times;</span>
      </button>
      <div class="list-group list-group-horizontal">
        <li class="list-group-item flex-fill">${ingredient.description}: ${ingredient.brandOwner}</li>
        <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][name]]" value="${ingredient.description}">
        <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][brand_owner]]" value="${ingredient.brandOwner}">
        <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][data_type]]" value="branded">
        <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][food_data_central_id]]" value="${ingredient.fdcId}">
        <li class="list-group-item flex-fill">Servings: <input type="number" name="recipe_ingredients_nutrients_form[ingredients[][servings]]"></input></li>
        <li class="list-group-item flex-fill">${ingredient.householdServingFullText}, grams: ${ingredient.servingSize}</li>
        <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][measurement_and_gram_weight]]" value='${JSON.stringify(gram_weight_and_measurement)}'>
  `
  ingredient.foodNutrients.forEach((foodNutrient) => {
    html += `
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][food_data_central_id]]]" value="${foodNutrient.nutrient.id}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][name]]]" value="${foodNutrient.nutrient.name}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][number]]]" value="${foodNutrient.nutrient.number}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][rank]]]" value="${foodNutrient.nutrient.rank}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][unit_name]]]" value="${foodNutrient.nutrient.unitName}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][amount]]]" value="${foodNutrient.amount}">
      <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][nutrients[][food_nutrient_id]]]" value="${foodNutrient.id}">
    `
  })
  html += `
      </div>
    </div>
  `
  return html
}
