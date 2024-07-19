import { router } from "../../../main";
import StructureCenterDisplay from "../../structures/center-display/center-display";
import StructureContainer from "../../structures/container/container";

export type PropsPageChat = {};

type Commands = "message" | "userInput" | "usersOnline" | "img";


export default class PageChat extends HTMLElement {
  sendCommand?: (type: Commands, data: string) => void;
  addMessage: (user: string, message: string) => void;
  addUser: (user: string) => void;
  removeUser: (user: string) => void;
  updateUserInput: (user: string, input: string) => void;

  constructor(props: PropsPageChat) {
    super();

    const onlineUsers = document.createElement("div");

    this.addUser = (user: string) => {
      const userCard = document.createElement("div");
      const titleUser = document.createElement("h3");
      titleUser.innerHTML = user;

      const userInput = document.createElement("p");
      userInput.id = "User" + user;

      userCard.append(titleUser);
      userCard.append(userInput);

      onlineUsers.append(userCard);
    };

    this.updateUserInput = (user: string, input: string) => {
      const element = onlineUsers.querySelector(`#User${user}`);
      if (element !== undefined)
        element.innerHTML = input;
    }

    const chatText = document.createElement("div");

    this.addMessage = (user: string, message: string) => {
      const p = document.createElement("div");
      p.innerHTML = `${user} : ${message}`;
      chatText.append(p);
    }

    const containerSendComsendCommand = document.createElement("div");
    containerSendComsendCommand.className = "container-send-message";

    const inputText = document.createElement("input");
    inputText.type = "text";

    const buttonSend = document.createElement("button");
    buttonSend.innerHTML = "enviar";

    containerSendComsendCommand.append(inputText);
    containerSendComsendCommand.append(buttonSend);
    containerSendComsendCommand.append(onlineUsers);

    buttonSend.addEventListener("click", () => {
      const { value } = inputText;

      if (value === "" || value === undefined) return;

      inputText.value = "";

      console.log("Enviando", value);

      if (this.sendCommand !== undefined)
        this.sendCommand("message", value);
    })

    inputText.addEventListener("input", (event) => {
      const { value } = event.target as any;


      if (this.sendCommand !== undefined)
        this.sendCommand("userInput", value);
    })


    this.appendChild(new StructureCenterDisplay({
      children: new StructureContainer({
        align: "center",
        childrens: [
          chatText,
          containerSendComsendCommand
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

      socket.send(JSON.stringify({ accessToken, command: "logIn" }));
      socket.send(JSON.stringify({ accessToken, command: "usersOnline" }));

      this.sendCommand = (type: Commands, data: string) => socket.send(JSON.stringify({ accessToken, command: type, data }));
    });

    socket.addEventListener('message', (event) => {
      console.log('Received: ' + event.data);

      try {
        const { command, data } = JSON.parse(event.data);

        switch (command) {
          case "message":
            (() => {
              const { userName, message } = data;
              this.addMessage(userName, message);

            })()
            break;

          case "usersOnline":
            (data as Array<string>).forEach((user) => { this.addUser(user) });
            break;

          case "userInput":
            (() => {
              const { userName, input } = data;
              this.updateUserInput(userName, input);
            })()
            break;

          default:
            console.error("Command not found! ", data);
        }
      } catch (error) {
        console.error(error);
      }
    });

    socket.addEventListener('close', (event) => {
      console.log('Disconnected from WebSocket');
      this.sendCommand = undefined;
      router.setPage("log-in");
    });
  }

  coonnectListUsers() {

  }

  logOut() {

  }
}

customElements.define("page-chat", PageChat);
