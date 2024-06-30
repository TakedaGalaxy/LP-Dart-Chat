import "./divider.scss";

export type PropsElementDivider = {
  transparent?: true;
};

export default class ElementDivider extends HTMLElement {
  constructor(props: PropsElementDivider) {
    super();

    const hr = document.createElement("hr");

    if (props.transparent) hr.className = "transparent";

    this.appendChild(hr);
  }
}

customElements.define("element-divider", ElementDivider);
