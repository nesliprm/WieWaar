import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="refresh"
export default class extends Controller {
  static values = { interval: { type: Number, default: 60 } }

  connect() {
    this.timer = setInterval(() => this.refresh(), this.intervalValue * 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  refresh() {
    Turbo.visit(window.location.href, { action: "replace" })
  }
}
