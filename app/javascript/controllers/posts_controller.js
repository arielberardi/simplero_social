import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleForm(event) {
    event.preventDefault()
    event.stopPropagation()

    const postID = event.params["id"]

    const form = document.getElementById(`post-form-${postID}`)
    const body = document.getElementById(`post-body-${postID}`)
    const footer = document.getElementById(`post-footer-${postID}`)

    form.classList.toggle("hidden")
    body.classList.toggle("hidden")
    footer.classList.toggle("hidden")
  }
}
