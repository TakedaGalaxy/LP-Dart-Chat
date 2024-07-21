import "./chat.scss";
import { router } from "../../../main";
import StructureCenterDisplay from "../../structures/center-display/center-display";
import StructureContainer from "../../structures/container/container";

export type PropsPageChat = {};

function fileToStringBase64(arquivo: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => {
      resolve(reader.result as string);
    };
    reader.onerror = () => {
      reject(reader.error);
    };
    reader.readAsDataURL(arquivo); // Base64
  });
}

function stringbase64ToFile(stringBase64: string): File {
  const [header, base64] = stringBase64.split(',');
  const mimeMatch = header.match(/data:([^;]+);base64/);
  const mimeType = mimeMatch ? mimeMatch[1] : '';
  const byteCharacters = atob(base64);
  const byteNumbers = new Array(byteCharacters.length);

  for (let i = 0; i < byteCharacters.length; i++) {
    byteNumbers[i] = byteCharacters.charCodeAt(i);
  }

  const byteArray = new Uint8Array(byteNumbers);
  const fileName = `download.${mimeType.split('/')[1]}`; // Usa a extensão do tipo MIME para o nome do arquivo
  return new File([byteArray], fileName, { type: mimeType });
}

class ChatConnection {
  private readonly url: string;

  callbackOnMessage: (userName: string, message: String) => void = (_, __) => { };
  callbackOnUserInput: (userName: string, input: String) => void = (_, __) => { };
  callbackOnUsersOnline: (users: Array<string>) => void = (_) => { };
  callbackOnLogIn: (userName: string) => void = (_) => { };
  callbackOnLogOut: (userName: string) => void = (_) => { };
  callbackOnFile: (userName: string, file: string) => void = () => { };
  callbackOnClose: () => void = () => { };

  private sendData?: (data: Object) => void;

  constructor(url: string) {
    this.url = url;
  }

  connect(accessToken: string) {
    const socket = new WebSocket(this.url);

    socket.addEventListener('open', (event) => {
      this.sendData = (data: Object) => {
        socket.send(JSON.stringify({ accessToken, ...data }));
      }

      this.sendData({ command: "logIn" });
      this.sendData({ command: "usersOnline" });
    });

    socket.addEventListener('message', (event) => {
      const { command, data } = JSON.parse(event.data);

      switch (command) {
        case "message":
          (() => {
            const { userName, message } = data;
            this.callbackOnMessage(userName, message);
          })()
          break;

        case "usersOnline":
          (() => {
            this.callbackOnUsersOnline(data);
          })();
          break;

        case "logIn":
          (() => {
            const { userName } = data;
            this.callbackOnLogIn(userName);
          })()
          break;

        case "userInput":
          (() => {
            const { userName, input } = data;
            this.callbackOnUserInput(userName, input);
          })()
          break;

        case "logOut":
          (() => {
            const { userName } = data;
            this.callbackOnLogOut(userName);
          })()
          break;

        case "file":
          (() => {
            const { userName, file } = data;

            this.callbackOnFile(userName, file);
          })();

        default:
      }
    });

    socket.addEventListener('close', (event) => {
      this.sendData = undefined;
      this.callbackOnClose();
    });
  }

  disconnect() { }

  sendMessage(message: string) {
    if (this.sendData === undefined) return;

    this.sendData({
      command: "message",
      data: message
    });
  }

  sendUserInput(input: string) {
    if (this.sendData === undefined) return;

    this.sendData({
      command: "userInput",
      data: input
    })
  }

  sendFile(file: File) {
    if (this.sendData === undefined) return;

    fileToStringBase64(file)
      .then((data) => {
        this.sendData({ command: "file", data });
      })
      .catch((error) => console.error(error))
  }
}


export default class PageChat extends HTMLElement {

  private readonly chatConnection: ChatConnection;

  constructor(props: PropsPageChat) {
    super();

    this.chatConnection = new ChatConnection("wss://localhost/api/websocket/chat");


    const containerChat = document.createElement("div");
    containerChat.id = "Container-Chat"

    const observer = new MutationObserver(() => {
      containerChat.scrollTop = containerChat.scrollHeight;
    });

    observer.observe(containerChat, { childList: true });

    this.chatConnection.callbackOnMessage = (userName, message) => {
      const p = document.createElement("p");

      p.innerText = `${userName} : ${message}`

      containerChat.appendChild(p);
      return;
    };
    this.chatConnection.callbackOnFile = (userName, stringFile) => {
      const file = stringbase64ToFile(stringFile);

      if (file.type.startsWith("image/")) {
        const p = document.createElement("p");
        p.innerText = userName;

        const img = document.createElement("img");
        img.src = stringFile;

        const containerImg = document.createElement("div");
        containerImg.append(p);
        containerImg.append(img);

        containerChat.append(containerImg);
      }
    }

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
      new StructureContainer({
        align: "center",
        childrens: [
          containerChat,
          containerInput,
          containerUsersOnline
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
