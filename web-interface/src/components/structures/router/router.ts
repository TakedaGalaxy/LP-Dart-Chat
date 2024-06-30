export type PropsStructureRouter = {};

export default class StructureRouter extends HTMLElement {
  pages: Map<string, HTMLElement>;

  constructor(props: PropsStructureRouter) {
    super();

    this.pages = new Map<string, HTMLElement>();
  }

  addPage(name: string, page: HTMLElement) {
    this.pages.set(name, page);
  }

  setPage(name: string) {
    const page = this.pages.get(name);

    if (page === undefined) {
      console.error("Page not found !");
      return;
    }

    this.innerHTML = "";
    this.appendChild(page);
  }
}

customElements.define("structure-router", StructureRouter);
