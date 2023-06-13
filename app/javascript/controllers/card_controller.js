import { Controller } from "@hotwired/stimulus"
// app/javascript/controllers/card_controller.js
export default class extends Controller {
  static targets = ["card", "cardBg"]

  connect() {
    console.log("coucou")
    this.mouseX = 0;
    this.mouseY = 0;
    this.height = this.element.clientHeight;
    this.width = this.element.clientWidth;
  }

  updatePosition(event) {
    const card = this.cardTarget;
    const cardBg = this.cardBgTarget;
    this.mouseX = event.pageX - this.element.offsetLeft - this.width / 2;
    this.mouseY = event.pageY - this.element.offsetTop - this.height / 2;

    const angleX = (this.mouseX / this.width) * 30;
    const angleY = (this.mouseY / this.height) * -30;
    card.style.transform = `rotateY(${angleX}deg) rotateX(${angleY}deg)`;

    const posX = (this.mouseX / this.width) * -40;
    const posY = (this.mouseY / this.height) * -40;
    cardBg.style.transform = `translateX(${posX}px) translateY(${posY}px)`;
  }

  resetPosition() {
    const card = this.cardTarget;
    const cardBg = this.cardBgTarget;
    card.style.transform = `rotateY(0deg) rotateX(0deg)`;
    cardBg.style.transform = `translateX(0px) translateY(0px)`;
  }

  onMousemove(event) {
    this.updatePosition(event);
  }

  onMouseout() {
    this.resetPosition();
  }
}
