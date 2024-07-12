export type PropsPageChat = {};

export default class PageChat extends HTMLElement {
  constructor(props: PropsPageChat) {
    super();

    this.innerHTML = "Chat";
  }

  onLoad() {
    const accessToken = localStorage.getItem("accessToken");

    console.log(accessToken);
  }
}

customElements.define("page-chat", PageChat);
