import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-submission"
export default class extends Controller {
  show_friends () {
    document.getElementById('friends').classList.remove('hidden')
    document.getElementById('friend-requests').classList.add('hidden')
  }

  show_friend_requests () {
    document.getElementById('friends').classList.add('hidden')
    document.getElementById('friend-requests').classList.remove('hidden')
  }
}
