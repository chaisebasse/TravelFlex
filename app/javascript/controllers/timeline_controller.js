import { Controller } from "@hotwired/stimulus"

// file.js

export default class extends Controller {
  static targets = ['item'];

  connect() {
    this.callbackFunc();
    window.addEventListener('load', this.callbackFunc.bind(this));
    window.addEventListener('resize', this.callbackFunc.bind(this));
    window.addEventListener('scroll', this.callbackFunc.bind(this));
  }

  callbackFunc() {
    this.itemTargets.forEach((item) => {
      if (this.isItemInView(item)) {
        item.classList.add('show');
      }
    });
  }

  isItemInView(item) {
    const rect = item.getBoundingClientRect();
    return (
      rect.top >= 0 &&
      rect.left >= 0 &&
      rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
      rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );
  }
}
