export type PropsElementTitle = {
  level: "h1" | "h2" | "h3" | "h4" | "h5" | "h6";
  text: string;
  align: "left" | "center" | "right";
};

export default class ElementTitle extends HTMLElement {
  constructor(props: PropsElementTitle) {
    super();

    const h = document.createElement(props.level);

    h.innerHTML = props.text;
    h.style.textAlign = props.align;

    this.appendChild(h);
  }
}

customElements.define("element-title", ElementTitle);
