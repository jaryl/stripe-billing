import { Controller } from "@hotwired/stimulus"
import Stripe from "@stripe/stripe-js/pure"

export default class extends Controller {
  static targets = ["payment", "submit", "errors"];
  static values = {};

  initialize() {
    this.returnUrl = this.element.dataset.stripeReturnUrl;

    (async () => {
      this.stripe = await Stripe.loadStripe(this.element.dataset.stripePublishableKey);
      this.#setup();
    })();
  }

  #setup() {
    if (!this.hasPaymentTarget) return;

    const appearance = { theme: 'stripe' };
    const clientSecret = this.element.dataset.stripeClientSecret;

    this.elements = this.stripe.elements({ appearance, clientSecret });
    const paymentElement = this.elements.create("payment");

    paymentElement.mount(this.paymentTarget);
    this.submitTarget.disabled = false;
  }

  async makePayment(e) {
    const { error } = await this.stripe.confirmPayment({
      elements: this.elements,
      confirmParams: { return_url: this.returnUrl },
    });

    this.errorsTarget.classList.remove("invisible");
    const selector = this.errorsTarget.dataset.selector;
    alert(selector)

    if (error.type === "card_error" || error.type === "validation_error") {
      this.errorsTarget.querySelector(selector).textContent = error.message;
    } else {
      this.errorsTarget.querySelector(selector).textContent = "An unexpected error occured.";
    }
  }
}
