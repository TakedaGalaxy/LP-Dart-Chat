import "./chat.scss";
import { router } from "../../../main";
import StructureContainer from "../../structures/container/container";
import ChatConnection from "../../../api/websocket";
import { fileToStringBase64 } from "../../../utils/functions";
import ElementChatBox from "../../elements/chat-box/chat-box";
import StructureCenterDisplay from "../../structures/center-display/center-display";

export type PropsPageChat = {};

export default class PageChat extends HTMLElement {

  private readonly chatConnection: ChatConnection;

  constructor(props: PropsPageChat) {
    super();

    this.chatConnection = new ChatConnection("wss://localhost/api/websocket/chat");

    const elementChatBox = new ElementChatBox({});

    this.chatConnection.callbackOnMessage = (userName, message) => elementChatBox.addMessage(userName, message);
    this.chatConnection.callbackOnFile = (userName, file) => { elementChatBox.addImg(userName, file) };

    const inputText = document.createElement("input");
    inputText.addEventListener("input", (event) => {
      const { value } = event.target as any;
      this.chatConnection.sendUserInput(value);

    });

    const buttonSend = document.createElement("button");
    buttonSend.innerHTML = "Enviar";
    buttonSend.addEventListener("click", () => {
      const { value } = inputText;

      if (value === undefined || value === "") return;

      inputText.value = "";
      this.chatConnection.sendUserInput("");
      this.chatConnection.sendMessage(value);
    });

    const buttonSendFile = document.createElement("button");
    buttonSendFile.innerText = "Enviar Imagem";
    buttonSendFile.addEventListener("click", () => {
      const inputImg = document.createElement("input");
      inputImg.type = 'file';
      inputImg.accept = 'image/*';

      inputImg.addEventListener('change', (event) => {
        const arquivo = inputImg.files ? inputImg.files[0] : null;
        if (arquivo)
          this.chatConnection.sendFile(arquivo);
      });

      //document.body.appendChild(inputImagem);
      inputImg.click();
    });

    const containerInput = document.createElement("div");
    containerInput.appendChild(inputText);
    containerInput.appendChild(buttonSend);
    containerInput.appendChild(buttonSendFile);

    const containerUsersOnline = document.createElement("div");
    const createUser = (userName: string) => {
      if (containerUsersOnline.querySelector(`#User${userName}`) != null) return;

      const name = document.createElement("h3");
      name.innerText = userName;

      const input = document.createElement("p");
      input.id = `User${userName}`;

      const userCard = document.createElement("div");
      userCard.id = `UserCard${userName}`
      userCard.append(name);
      userCard.append(input);

      containerUsersOnline.append(userCard);
    }

    const removeUser = (userName: string) => {
      const element = containerUsersOnline.querySelector(`#UserCard${userName}`);
      if (element == null) return;
      element.remove();
    }

    const updateUserInput = (userName: string, input: string) => {
      const element = containerUsersOnline.querySelector(`#User${userName}`);
      if (input == null) return;
      element.innerHTML = input;
    }

    this.chatConnection.callbackOnLogIn = createUser;
    this.chatConnection.callbackOnUsersOnline = (users) => users.forEach(createUser);
    this.chatConnection.callbackOnLogOut = removeUser
    this.chatConnection.callbackOnUserInput = updateUserInput;

    this.appendChild(
      new StructureCenterDisplay({
        children:
          new StructureContainer({
            align: "center",
            childrens: [
              elementChatBox,
              containerInput,
              containerUsersOnline
            ]
          })
      })
    );
  }

  onLoad() {
    const accessToken = localStorage.getItem("accessToken");

    if (accessToken === null) {
      router.setPage("log-in");
      console.error("Não esta logado");
      return;
    }

    this.chatConnection.connect(accessToken);
  }
}

customElements.define("page-chat", PageChat);
