export type PropsPageChat = {};

export default class PageChat extends HTMLElement {
  constructor(props: PropsPageChat) {
    super();

    this.innerHTML = "Chat";
  }
}

customElements.define("page-Chat", PageChat);
