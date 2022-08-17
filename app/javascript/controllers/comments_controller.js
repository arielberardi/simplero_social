import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleForm(event) {
    event.preventDefault()
    event.stopPropagation()

    const commentID = event.params["id"]

    const form = document.getElementById(`comment-form-${commentID}`)
    const body = document.getElementById(`comment-body-${commentID}`)
    const footer = document.getElementById(`comment-footer-${commentID}`)

    form.classList.toggle("hidden")
    body.classList.toggle("hidden")
    footer.classList.toggle("hidden")
  }

  toggleReplyForm(event) {
    event.preventDefault()
    event.stopPropagation()

    const commentID = event.params["id"]
    const form = document.getElementById(`reply-form-${commentID}`)

    form.classList.toggle("hidden")
  }
}
