import { router } from "../../../main";
import ElementDivider from "../../divider/divider";
import ElementButton from "../../elements/button/button";
import ElementInput from "../../elements/input/input";
import ElementTitle from "../../elements/title/title";
import StructureCard from "../../structures/card/card";
import StructureCenterDisplay from "../../structures/center-display/center-display";
import StructureContainer from "../../structures/container/container";
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
      new StructureCenterDisplay({
        children: new StructureContainer({
          align: "center",
          childrens: [
            new StructureCard({
              childrens: [
                new StructureForm<FormSigin>({
                  inputsName: ["name", "password"],
                  onSubmit: async (data) => {
                    console.log(data);
                    return "ok";
                  },
                  childrens: [
                    new ElementTitle({
                      text: "Criar Conta !",
                      align: "center",
                      level: "h2",
                    }),
                    new ElementInput({
                      type: "text",
                      name: "name",
                      label: "Nome",
                    }),
                    new ElementInput({
                      type: "password",
                      name: "password",
                      label: "Senha",
                    }),
                    new ElementDivider({
                      transparent: true,
                    }),
                    new ElementButton({
                      text: "Já tenho conta",
                      type: "submit",
                      onClick: () => router.setPage("log-in"),
                    }),
                    new ElementButton({ text: "Criar", type: "submit" }),
                  ],
                }),
              ],
            }),
          ],
        }),
      })
    );
  }
}

customElements.define("page-sign-in", PageSignIn);
