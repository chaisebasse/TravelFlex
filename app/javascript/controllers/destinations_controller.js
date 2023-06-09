import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  selectElement(event) {
    const destinationChoice = event.target.dataset.destinationChoice;
    sessionStorage.setItem('destinationChoice', destinationChoice);
    const query = JSON.parse(sessionStorage.getItem('query')) || {};
    query.destination_choice = destinationChoice;
    sessionStorage.setItem('query', JSON.stringify(query));
  }
}
