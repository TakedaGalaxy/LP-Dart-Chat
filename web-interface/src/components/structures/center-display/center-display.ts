import "./center-display.scss";

export type PropsStructureCenterDisplay = {
  children: HTMLElement;
};

export default class StructureCenterDisplay extends HTMLElement {
  constructor(props: PropsStructureCenterDisplay) {
    super();

    this.appendChild(props.children);
  }
}

customElements.define("structure-center-display", StructureCenterDisplay);
