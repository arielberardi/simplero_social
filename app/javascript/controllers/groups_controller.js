import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  setPrivacyInput(event) {
    event.preventDefault()
    event.stopPropagation()

    document.getElementById("group_privacy").value = event.params["privacy"]
  }
}
