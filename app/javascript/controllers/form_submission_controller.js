import { Controller } from "@hotwired/stimulus"
// import { AbortController } from "@hotwired/stimulus"

// Connects to data-controller="form-submission"
export default class extends Controller {
	search_skippers() {
		clearTimeout(this.timeout)
		this.timeout = setTimeout(() => {
			this.element.requestSubmit()
		}, 100)
	}

	search_users() {
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
