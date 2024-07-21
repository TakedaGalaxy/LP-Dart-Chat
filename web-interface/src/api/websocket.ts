import { fileToStringBase64, stringbase64ToFile } from "../utils/functions";

export default class ChatConnection {
  private readonly url: string;

  callbackOnMessage: (userName: string, message: string) => void = (_, __) => { };
  callbackOnUserInput: (userName: string, input: string) => void = (_, __) => { };
  callbackOnUsersOnline: (users: Array<string>) => void = (_) => { };
  callbackOnLogIn: (userName: string) => void = (_) => { };
  callbackOnLogOut: (userName: string) => void = (_) => { };
  callbackOnFile: (userName: string, file: File) => void = () => { };
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

            this.callbackOnFile(userName, stringbase64ToFile(file));
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