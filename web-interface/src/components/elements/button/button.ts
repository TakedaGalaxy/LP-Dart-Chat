import "./button.scss";

export type PropsElementButton = {
  type: "submit" | "primary" | "secondary";
  text?: string;
  onClick?: () => void;
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

    if (props.onClick !== undefined)
      button.addEventListener("click", props.onClick);

    this.appendChild(button);
  }
}

customElements.define("element-button", ElementButton);
