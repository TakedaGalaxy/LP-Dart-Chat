import "./card.scss";

export type PropsStructureCard = {
  childrens: Array<HTMLElement>;
};

export default class StructureCard extends HTMLElement {
  constructor(props: PropsStructureCard) {
    super();

    props.childrens.forEach((children) => this.appendChild(children));
  }
}

customElements.define("structure-card", StructureCard);
