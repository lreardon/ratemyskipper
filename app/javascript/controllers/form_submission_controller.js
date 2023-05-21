import { Controller } from "@hotwired/stimulus"
// import { AbortController } from "@hotwired/stimulus"

// Connects to data-controller="form-submission"
export default class extends Controller {
	search_skippers() {
		let query_length = document.getElementById('searchbar-input').value.length
		if (query_length > 0 && query_length < 3) {
			console.log(document.getElementById('searchbar-input').value)
			return
		}

		clearTimeout(this.timeout)
		this.timeout = setTimeout(() => {
			this.element.requestSubmit()
		}, 100)
	}

	search_users() {
		let query_length = document.getElementById('searchbar-input').value.length
		if (query_length == 0) {
			document.getElementById('search_results').replaceChildren()
			return
		} else if (query_length < 3) {
			return
		}

		clearTimeout(this.timeout)
		this.timeout = setTimeout(() => {
			this.element.requestSubmit()
		}, 100)
	}
}
