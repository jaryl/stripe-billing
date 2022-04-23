import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    action: { type: String, default: "replace" },
    href: String,
  };

  connect() {
    Turbo.visit(this.hrefValue, { action: this.actionValue });
  }
}
