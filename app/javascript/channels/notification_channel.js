import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
    const notification = document.getElementById("notifications")
    notification.innerHTML = data.html + notification.innerHTML
  }
});
