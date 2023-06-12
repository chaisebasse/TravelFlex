import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loader"
export default class extends Controller {
  static targets = ['loader', 'loader2']

  connect() {

  }

  loading(evt) {
    evt.target.remove()
    this.loaderTarget.classList.remove('d-none')
    this.loader2Target.classList.add('banner-padding')
    this.loader2Target.classList.remove('bck-img')
  }
}
