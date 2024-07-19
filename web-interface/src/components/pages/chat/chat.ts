import { router } from "../../../main";
import StructureCenterDisplay from "../../structures/center-display/center-display";
import StructureContainer from "../../structures/container/container";

export type PropsPageChat = {};

export default class PageChat extends HTMLElement {
  sendMessage?: (data: string) => void
  addMessage: (user: string, message: string) => void

  constructor(props: PropsPageChat) {
    super();

    const chatText = document.createElement("div");

    this.addMessage = (user: string, message: string) => {
      const p = document.createElement("div");

      p.innerHTML = `${user} : ${message}`;

      chatText.append(p);
    }

    const containerSendMessage = document.createElement("div");
    containerSendMessage.className = "container-send-message";
    const inputText = document.createElement("input");
    inputText.type = "text";
    const buttonSend = document.createElement("button");
    buttonSend.innerHTML = "enviar";

    containerSendMessage.append(inputText)
    containerSendMessage.append(buttonSend)

    buttonSend.addEventListener("click", () => {
      const { value } = inputText;

      inputText.value = "";

      console.log("Enviando", value);

      if (this.sendMessage !== undefined)
        this.sendMessage(value);
    })


    this.appendChild(new StructureCenterDisplay({
      children: new StructureContainer({
        align: "center",
        childrens: [
          chatText,
          containerSendMessage
        ]
      })
    }));
  }

  onLoad() {
    const accessToken = localStorage.getItem("accessToken");

    if (accessToken === null) {
      router.setPage("log-in");
      console.error("Não esta logado");
      return;
    }

    this.connectChat(accessToken);
  }

  connectChat(accessToken: string) {
    console.log("Tentando conexão !");

    const socket = new WebSocket('ws://localhost:80/api/websocket/chat');

    socket.addEventListener('open', (event) => {
      console.log('Connected to WebSocket');

      socket.send(JSON.stringify({ accessToken }));

      this.sendMessage = (data: string) => socket.send(JSON.stringify({ accessToken, message: data }));
    });

    socket.addEventListener('message', (event) => {
      console.log('Received: ' + event.data);

      try {
        const { user, message } = JSON.parse(event.data);

        this.addMessage(user, message);
      } catch (_) {

      }
    });

    socket.addEventListener('close', (event) => {
      console.log('Disconnected from WebSocket');
      this.sendMessage = undefined;
      router.setPage("log-in");
    });
  }

  coonnectListUsers() {

  }

  logOut() {

  }
}

customElements.define("page-chat", PageChat);
