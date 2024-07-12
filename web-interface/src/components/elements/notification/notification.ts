import "./notification.scss"

export type PropsElementNotification = {
}

export default class ElementNotification extends HTMLElement {
  constructor(props: PropsElementNotification) {
    super();
  }

  add(children: Element) {
    this.appendChild(children);

    setTimeout(() => {
      this.removeChild(children)
    }, 3500);
  }
}

customElements.define('element-notification', ElementNotification);