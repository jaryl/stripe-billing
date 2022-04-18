import { Controller } from "@hotwired/stimulus"
import Stripe from "@stripe/stripe-js/pure"

export default class extends Controller {
  static targets = ["payment", "submit", "errors"];
  static values = {};

  initialize() {
    this.returnUrl = this.element.dataset.stripeReturnUrl;
    this.ready = false;
    this.operations = [];

    (async() => {
      this.stripe = await Stripe.loadStripe(this.element.dataset.stripePublishableKey);
      this.#ready();
    })();
  }

  paymentTargetConnected() {
    const mountPaymentElement = () => {
      const appearance = { theme: 'stripe' };
      const clientSecret = this.paymentTarget.dataset.stripeClientSecret;

      this.elements = this.stripe.elements({ appearance, clientSecret });
      const paymentElement = this.elements.create("payment");

      paymentElement.mount(this.paymentTarget);
      this.submitTarget.disabled = false;
    };

    if (this.ready) {
      mountPaymentElement();
    } else {
      this.operations.push(mountPaymentElement);
    }
  }

  #ready() {
    this.ready = true;
    this.operations.forEach(operation => operation());
  }

  async makePayment(e) {
    const { error } = await this.stripe.confirmPayment({
      elements: this.elements,
      confirmParams: { return_url: this.returnUrl },
    });

    this.errorsTarget.classList.remove("invisible");
    const selector = this.errorsTarget.dataset.selector;

    if (error.type === "card_error" || error.type === "validation_error") {
      this.errorsTarget.querySelector(selector).textContent = error.message;
    } else {
      this.errorsTarget.querySelector(selector).textContent = "An unexpected error occured.";
    }
  }
}
