import ElementDivider from "../../divider/divider";
import ElementButton from "../../elements/button/button";
import ElementInput from "../../elements/input/input";
import StructureForm from "../../structures/form/form";

export type FormSigin = {
  name: string;
  password: string;
};

export type PropsPageSignIn = {};
export default class PageSignIn extends HTMLElement {
  constructor(props: PropsPageSignIn) {
    super();
    
    this.appendChild(
      new StructureForm<FormSigin>({
        inputsName: ["name", "password"],
        onSubmit: async (data) => {
          console.log(data);
          return "ok";
        },
        childrens: [
          new ElementInput({ type: "text", name: "name", label: "Nome" }),
          new ElementInput({
            type: "password",
            name: "password",
            label: "Senha",
          }),
          new ElementDivider({
            transparent: true,
          }),
          new ElementButton({ text: "Sign-in", type: "submit" }),
        ],
      })
    );
  }
}

customElements.define("page-sign-in", PageSignIn);
