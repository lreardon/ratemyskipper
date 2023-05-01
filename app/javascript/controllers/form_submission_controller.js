import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-submission"
export default class extends Controller {
  search () {
    if (document.getElementById('searchbar-input').value == '') {
      document.getElementById('search_results').replaceChildren()
      return
    }
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 100)
  }
}
