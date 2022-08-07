import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['modal']

  submitEnd(event) {
    if (event.detail.success) {
      this.hideModal();
    }
  }

  hideModal() {
    this.element.remove();
  }

  // Closes the modal with Escape key pressed
  closeWithKeyboard(e) {
    if (e.code == "Escape") {
      this.hideModal();
    }
  }

  // Closes the modal if is clicked outside of the modal
  closeWithClick(e) {
    if (e && this.modalTarget.contains(e.target)) {
      return;
    }

    this.hideModal();
  }
}
