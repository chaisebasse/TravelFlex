import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loader"
export default class extends Controller {
  static targets = ['loader']

  connect() {

  }

  loading(evt) {
    evt.target.remove()
    this.loaderTarget.classList.remove('d-none')
  }
}
