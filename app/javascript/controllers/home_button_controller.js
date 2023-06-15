import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-button"
export default class extends Controller {
  connect() {
    console.log (hello)
  }

  removeButton() {
    const button = document.querySelector(".input-home");button.addEventListener("click",(event) =>{
      console.log("hello")
    })
  }
}
