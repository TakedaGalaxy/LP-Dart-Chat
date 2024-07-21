import "./chat.scss";
import { router } from "../../../main";
import StructureContainer from "../../structures/container/container";
import ChatConnection from "../../../api/websocket";
import ElementChatBox from "../../elements/chat-box/chat-box";
import ElementUserBarInput from "../../elements/user-bar-input/user-bar-input";
import ElementUsersOnline from "../../elements/users-online/users-online";
import ElementTitle from "../../elements/title/title";

export type PropsPageChat = {};

export default class PageChat extends HTMLElement {

  private readonly chatConnection: ChatConnection;

  constructor(props: PropsPageChat) {
    super();

    this.chatConnection = new ChatConnection("wss://localhost/api/websocket/chat");
    this.chatConnection.callbackOnClose = () => {
      router.setPage("log-in");
    }

    const elementChatBox = new ElementChatBox({});

    this.chatConnection.callbackOnMessage = (userName, message) => elementChatBox.addMessage(userName, message);
    this.chatConnection.callbackOnFile = (userName, file) => { elementChatBox.addImg(userName, file) };

    const elementUserBarInput = new ElementUserBarInput({
      onInput: (text) => {
        this.chatConnection.sendUserInput(text);
      },
      onSubmitInput: (text) => {
        this.chatConnection.sendUserInput("");
        this.chatConnection.sendMessage(text);
      },
      onSubmitFile: (file) => {
        this.chatConnection.sendFile(file);
      }
    });

    const elementUsersOnline = new ElementUsersOnline({});

    this.chatConnection.callbackOnLogIn = (userName) => elementUsersOnline.addUser(userName);
    this.chatConnection.callbackOnUsersOnline = (users) => users.forEach((userName) => elementUsersOnline.addUser(userName));
    this.chatConnection.callbackOnLogOut = (userName) => elementUsersOnline.removeUser(userName);
    this.chatConnection.callbackOnUserInput = (userName, input) => elementUsersOnline.updateUserInput(userName, input);;

    this.appendChild(
      new StructureContainer({
        align: "center",
        childrens: [
          new ElementTitle({ align: "center", level: "h1", text: "Dart Chat" }),
          elementChatBox,
          elementUserBarInput,
          new ElementTitle({ align: "center", level: "h2", text: "Usuarios Online" }),
          elementUsersOnline,
        ]
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
