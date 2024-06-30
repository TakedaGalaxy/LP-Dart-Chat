import "./form.scss"

export type PropsStructureForm<T> = {
  childrens: Array<HTMLElement>;
  inputsName: Array<keyof T>;
  onSubmit: (data: Map<keyof T, any>) => Promise<string>;
};

export default class StructureForm<T> extends HTMLElement {
  constructor(props: PropsStructureForm<T>) {
    super();

    const form = document.createElement("form");

    props.childrens.forEach((children) => form.appendChild(children));

    form.addEventListener("submit", async (event) => {
      event.preventDefault();

      const data = new Map<keyof T, any>();

      props.inputsName.forEach((inputName) => {
        const { value } = (event.target as any)[inputName];
        data.set(inputName, value);
      });

      try {
        const response = await props.onSubmit(data);
        console.log(response);
      } catch (e) {
        console.error(e);
      }
    });

    this.appendChild(form);
  }
}

customElements.define("structure-form", StructureForm);
