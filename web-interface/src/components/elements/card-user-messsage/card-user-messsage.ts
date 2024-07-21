import "./card-user-messsage.scss";

export type PropsElementCardUserMessage = {
  className?: string;
  userName: string,
  children: Element
}

export default class ElementCardUserMessage extends HTMLElement {
  constructor(props: PropsElementCardUserMessage) {
    super();
    this.className = props.className ?? "";

    const name = document.createElement("h3");
    name.innerText = props.userName;

    const containerChildren = document.createElement("div");
    containerChildren.className = "container-children";

    containerChildren.append(props.children);

    this.append(name);
    this.append(containerChildren);
  }
}

customElements.define('element-card-user-message', ElementCardUserMessage);
