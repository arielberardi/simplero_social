import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.animateClasses = this.data.get('animationClass').split(' ');
    setTimeout(() => this.close(), 2500);
  }

  close() {
    this.element.classList.add(...this.animateClasses);
    setTimeout(() => this.element.remove(), 0.5 * 1000);
  }
}
