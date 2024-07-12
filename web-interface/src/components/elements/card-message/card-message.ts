import "./card-message.scss";

export type PropsElementCardMessage = {
  text: string;
  success?: true;
  error?: true;
}

export default class ElementCardMessage extends HTMLElement {
  constructor(props: PropsElementCardMessage) {
    super();

    this.className = `${props.success ? "success" : ""} ${props.error ? "error" : ""}`;

    const p = document.createElement("p");

    p.innerHTML = props.text;

    this.appendChild(p);
  }
}

customElements.define('element-card-message', ElementCardMessage);