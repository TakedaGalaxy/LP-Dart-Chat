export type PropsPageLogIn = {
}

export default class PageLogIn extends HTMLElement {
  constructor(props: PropsPageLogIn) {
    super();

    this.innerHTML = "Log In";
  }
}

customElements.define('page-log-in', PageLogIn);