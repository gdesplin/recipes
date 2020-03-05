import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["searchTerm", "searchResults"]
  connect() {
    console.log("Hello, Stimulus!", this.element)
  }
  search() {
    this.searchResultsTarget.innerHTML =`<li>Loading</li>`
    fetch(`https://api.nal.usda.gov/fdc/v1/search?api_key=eiQ7AFUmqPEr6SyLF4uviQdiOhkrQZEgDrmlajbZ&generalSearchInput=${this.searchTermTarget.value}`)
    .then(response => response.json())
    .then(json => {
      if (json.foods.length == 0) { return }
      let searchResultsHtml = ""
      json.foods.slice(0,9).forEach((resultJSON) => {
        fetch(`https://api.nal.usda.gov/fdc/v1/${resultJSON.fdcId}?api_key=eiQ7AFUmqPEr6SyLF4uviQdiOhkrQZEgDrmlajbZ`)
        .then(responseDetail => responseDetail.json())
        .then(jsonDetail => {
          searchResultsHtml += resultTemplate(jsonDetail)
          this.searchResultsTarget.innerHTML = searchResultsHtml;
        })
      })
    })
  }
}

function resultTemplate(result) {
  return `
    <li data-fdcId="${result.fdcId}">
      ${result.description}
    </li>
  `
}