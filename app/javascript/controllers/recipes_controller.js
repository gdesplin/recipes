import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["searchTerm", "searchResultsList", "searchResults", "ingredientsList", "addedIngredients"]
  connect() {
    self = this
    console.log("Hello, Stimulus!", self.element)
    self.targets.addedIngredients = []
    self.targets.searchResults = []
  }
  search(event) {
    event.preventDefault()
    event.stopImmediatePropagation()
    self.searchResultsListTarget.innerHTML =`<li>Loading</li>`
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
    const ingredientFdcId = event.currentTarget.getAttribute("value")
    const ingredient = self.targets.searchResults.find(ingredient => ingredient.fdcId === parseInt(ingredientFdcId))
    self.targets.addedIngredients.push(ingredient)
    self.updateIngredientList()
  }

  updateIngredientList() {
    if (!self.targets.addedIngredients.length) {
      return
    }
    let addedIngredientsHTML = ""
    self.targets.addedIngredients.forEach((ingredient) => {
      addedIngredientsHTML += addIngredientTemplate(ingredient)
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
  return `
    <div data-fdcId="${result.fdcId}" class="mb-2">
      <button class="btn btn-primary" data-action="click->recipes#addIngredient" value="${result.fdcId}">Add</button>
      ${result.description}
    </div>
  `
}

function addIngredientTemplate(ingredient) {
  let html = `
    <div class="list-group-item">
      <div class="list-group list-group-horizontal">
        <li class="list-group-item">${ingredient.description}</li>
        <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][name]]" value="${ingredient.description}">
        <input type="hidden" name="recipe_ingredients_nutrients_form[ingredients[][food_data_central_id]]" value="${ingredient.fdcId}">
        <li class="list-group-item">Measurment: <input type="text" name="recipe_ingredients_nutrients_form[ingredients[][measurment_type]]" placeholder="ie. 'tsp' or 'whole'"></input></li>
        <li class="list-group-item">Amount: <input type="text" name="recipe_ingredients_nutrients_form[ingredients[][amount]]"></input></li>
  `
  console.log(ingredient);
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
  console.log(html)
  return html
}