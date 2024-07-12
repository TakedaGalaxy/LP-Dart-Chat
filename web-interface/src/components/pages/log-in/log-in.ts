import api from "../../../api/api";
import { router } from "../../../main";
import ElementDivider from "../../divider/divider";
import ElementButton from "../../elements/button/button";
import ElementInput from "../../elements/input/input";
import ElementTitle from "../../elements/title/title";
import StructureCard from "../../structures/card/card";
import StructureCenterDisplay from "../../structures/center-display/center-display";
import StructureContainer from "../../structures/container/container";
import StructureForm from "../../structures/form/form";

export type PropsPageLogIn = {
}

export type FormLogIn = {
  name: string,
  password: string
}

export default class PageLogIn extends HTMLElement {
  constructor(props: PropsPageLogIn) {
    super();

    this.appendChild(new StructureCenterDisplay({
      children: new StructureContainer({
        align: "center",
        childrens: [
          new StructureCard({
            childrens: [
              new StructureForm<FormLogIn>({
                inputsName: ["name", "password"],
                onSubmit: async (data) => {
                  const name = data.get("name");
                  const password = data.get("password");

                  const response = await api.logIn(name, password);

                  const { accessToken } = JSON.parse(response);

                  localStorage.setItem("accessToken", accessToken);

                  return "Entrou com sucesso !";
                },
                onSuccess: ()=>router.setPage("chat"),
                childrens: [
                  new ElementTitle({
                    align: 'center',
                    level: "h2",
                    text: "Fazer log in"
                  }),
                  new ElementInput({ label: "Nome", name: "name", type: "text" }),
                  new ElementInput({ label: "Senha", name: "password", type: "text" }),
                  new ElementDivider({
                    transparent: true,
                  }),
                  new ElementButton({ text: "Entrar", type: "submit" }),
                  new ElementButton({ text: "Criar conta", type: "primary", onClick: () => router.setPage("sign-in") })
                ]
              })
            ]
          })
        ]
      })
    }))

  }
}

customElements.define('page-log-in', PageLogIn);