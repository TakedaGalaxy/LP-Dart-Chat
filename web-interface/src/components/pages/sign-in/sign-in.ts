export type PropsPageSignIn = {};

export default class PageSignIn extends HTMLElement {
  constructor(props: PropsPageSignIn) {
    super();

    this.innerHTML = "Sign In";
  }
}

customElements.define("page-sign-in", PageSignIn);
