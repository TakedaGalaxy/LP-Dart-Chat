import "./container.scss";

export type PropsStructureContainer = {
  childrens: Array<HTMLElement>;
  align: "start" | "center" | "end";
};

export default class StructureContainer extends HTMLElement {
  constructor(props: PropsStructureContainer) {
    super();
    const content = document.createElement("div");
    content.className = `content align-${props.align}`;

    props.childrens.forEach((children) => content.appendChild(children));

    this.appendChild(content);
  }
}

customElements.define("structure-container", StructureContainer);
