import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["polaroid", "modal", "imageUploader"];

  connect() {
    this.renderPolaroids();
    this.makeDraggable();
  }

  renderPolaroids() {
    this.polaroidTargets.forEach((polaroid) => {
      const idx = polaroid.dataset.index;
      const URL = polaroid.dataset.url;
      const text = polaroid.dataset.text;

      polaroid.innerHTML = `
        <img src="${URL}" />
        <p>${text}</p>
        <button class="btn btn-danger btn-xs glyphicon glyphicon-trash"
          data-action="click->polaroid#removePolaroid" data-index="${idx}"></button>
      `;
    });
  }

  toggleAddingMode() {
    this.modalTarget.innerHTML = `
      <div class="background-modal" />
      <div class="polaroid-modal">
        <img src="http://i50.photobucket.com/albums/f319/bbisnotillidan/upload_subtle_zpsqbjafkdf.jpg"/>
        <input class="image-uploader" id="image-uploader" type="file" data-target="polaroid.imageUploader" />
        <p>Click to upload</p>
        <button class="btn btn-info btn-xs glyphicon glyphicon-ok"
          data-action="click->polaroid#add"></button>
        <button class="btn btn-danger btn-xs glyphicon glyphicon-remove"
          data-action="click->polaroid#close"></button>
      </div>
    `;

    this.isInAddingMode = !this.isInAddingMode;
  }

  add() {
    const URL = this.modalTarget.querySelector("img").src;
    const text = this.modalTarget.querySelector("p").textContent;
    const idx = this.polaroidTargets.length;

    this.polaroidTargets.forEach((polaroid) => {
      polaroid.innerHTML = "";
    });

    const newPolaroid = document.createElement("div");
    newPolaroid.className = "polaroid";
    newPolaroid.dataset.target = "polaroid";
    newPolaroid.dataset.url = URL;
    newPolaroid.dataset.text = text;
    newPolaroid.dataset.index = idx;
    newPolaroid.innerHTML = `
      <img src="${URL}" />
      <p>${text}</p>
      <button class="btn btn-danger btn-xs glyphicon glyphicon-trash"
        data-action="click->polaroid#removePolaroid" data-index="${idx}"></button>
    `;

    this.element.appendChild(newPolaroid);

    this.modalTarget.innerHTML = "";
    this.isInAddingMode = !this.isInAddingMode;
  }

  close() {
    this.modalTarget.innerHTML = "";
    this.isInAddingMode = !this.isInAddingMode;
  }

  removePolaroid(event) {
    const index = event.target.dataset.index;
    const polaroid = this.element.querySelector(`[data-index="${index}"]`);

    polaroid.remove();
  }

  makeDraggable() {
    this.polaroidsContainerTargets.forEach((container) => {
      container.querySelectorAll(".polaroid").forEach((polaroid) => {
        polaroid.addEventListener("mousedown", this.startDrag);
      });
    });
  }

  startDrag(event) {
    const polaroid = event.currentTarget;
    const offsetX = event.clientX - polaroid.getBoundingClientRect().left;
    const offsetY = event.clientY - polaroid.getBoundingClientRect().top;

    const moveHandler = (e) => {
      polaroid.style.left = e.clientX - offsetX + "px";
      polaroid.style.top = e.clientY - offsetY + "px";
    };

    const stopDrag = () => {
      document.removeEventListener("mousemove", moveHandler);
      document.removeEventListener("mouseup", stopDrag);
    };

    document.addEventListener("mousemove", moveHandler);
    document.addEventListener("mouseup", stopDrag);
  }
}
