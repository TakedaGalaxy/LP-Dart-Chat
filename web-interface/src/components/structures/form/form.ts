import { notification } from "../../../main";
import ElementCardMessage from "../../elements/card-message/card-message";
import "./form.scss"

export type PropsStructureForm<T> = {
  childrens: Array<HTMLElement>;
  inputsName: Array<keyof T>;
  onSubmit: (data: Map<keyof T, any>) => Promise<string>;
  onSuccess?: () => void;
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

        notification.add(new ElementCardMessage({
          text: response,
          success: true
        }));

        console.log(response);

        if (props.onSuccess !== undefined) props.onSuccess();

      } catch (e) {
        notification.add(new ElementCardMessage({
          text: `${e}`,
          error: true
        }));

        console.error(e);
      }
    });

    this.appendChild(form);
  }
}

customElements.define("structure-form", StructureForm);
