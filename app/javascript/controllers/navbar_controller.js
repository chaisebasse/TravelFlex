import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {

  connect() {
    window.addEventListener("scroll", function(e) {
      if (window.scrollY >= 70) {
        document.querySelector('.navbar').style.backgroundColor = "white";
      } else if (window.scrollY < 70){
        document.querySelector('.navbar').style.backgroundColor = "transparent";
      }
    });
  }
}
