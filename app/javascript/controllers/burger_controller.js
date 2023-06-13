import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["heroImage", "heroText"];

  connect() {
    this.showMenu = false;
    this.del = 3;
    this.i = 1;
    this.tl = gsap.timeline({ repeat: -1, yoyo: true, ease: "expo.out" });

    this.setupAnimation();
  }

  setupAnimation() {
    gsap.set(this.heroTextTargets, {
      clipPath: "polygon(0% 0%, 100% 0%, 100% 100%, 0% 100%)"
    });

    gsap.set(this.heroTextTargets, {
      clipPath: "polygon(0% 0%, 0% 0%, 0% 100%, 0% 100%)"
    });

    while (this.i < 5) {
      this.tl.to(`#hero-${this.i} h2`, 0.9, {
        clipPath: "polygon(0% 0%, 0% 0%, 0% 100%, 0% 100%)",
        delay: this.del
      })
        .to(
          `#hero-${this.i} h1`,
          0.9,
          {
            clipPath: "polygon(0% 0%, 0% 0%, 0% 100%, 0% 100%)"
          },
          "-=0.3"
        )
        .to(
          `#hero-${this.i} h3`,
          0.9,
          {
            clipPath: "polygon(0% 0%, 0% 0%, 0% 100%, 0% 100%)"
          },
          "-=0.3"
        )
        .to(
          `#hero-${this.i} .hi-${this.i}`,
          0.7,
          {
            clipPath: "polygon(0% 0%, 0% 0%, 0% 100%, 0% 100%)"
          },
          "-=1"
        )
        .to(`#hero-${this.i + 1} h2`, 0.9, {
          clipPath: "polygon(0% 0%, 100% 0%, 100% 100%, 0% 100%)"
        })
        .to(
          `#hero-${this.i + 1} h1`,
          0.9,
          {
            clipPath: "polygon(0% 0%, 100% 0%, 100% 100%, 0% 100%)"
          },
          "-=0.3"
        )
        .to(
          `#hero-${this.i + 1} h3`,
          0.9,
          {
            clipPath: "polygon(0% 0%, 100% 0%, 100%         100%, 0% 100%)"
          },
          "-=0.3"
        );

        this.i++;
      }
    }
  }
