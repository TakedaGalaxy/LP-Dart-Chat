export type PropsElementButton = {
  type: "submit" | "primary" | "secondary";
  text?: string;
};

export default class ElementButton extends HTMLElement {
  constructor(props: PropsElementButton) {
    super();

    const button = document.createElement("button");

    switch (props.type) {
      case "submit":
        button.type = "submit";
        break;
      case "primary":
        button.type = "button";
        break;
      case "secondary":
        button.type = "button";
        break;
    }

    if (props.text !== undefined) {
      const span = document.createElement("span");
      span.innerHTML = props.text;
      button.appendChild(span);
    }

    this.appendChild(button);
  }
}

customElements.define("element-button", ElementButton);
