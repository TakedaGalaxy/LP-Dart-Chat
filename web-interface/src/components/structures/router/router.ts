export type PropsStructureRouter = {};

export default class StructureRouter extends HTMLElement {
  pages: Map<string, { element: HTMLElement, onLoad: () => void }>;

  constructor(props: PropsStructureRouter) {
    super();

    this.pages = new Map<string, { element: HTMLElement, onLoad: () => void }>();
  }

  addPage(name: string, page: HTMLElement, onLoad: () => void) {
    this.pages.set(name, { element: page, onLoad });
  }

  setPage(name: string) {
    const page = this.pages.get(name);

    if (page === undefined) {
      console.error("Page not found !");
      return;
    }

    this.innerHTML = "";
    this.appendChild(page.element);
    
    page.onLoad();
  }
}

customElements.define("structure-router", StructureRouter);
