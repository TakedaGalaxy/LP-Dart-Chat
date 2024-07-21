import { fileToStringBase64 } from "../../../utils/functions";
import ElementCardUserMessage from "../card-user-messsage/card-user-messsage";
import "./chat-box.scss";

export type PropsElementChatBox = {
  className?: string
}

export default class ElementChatBox extends HTMLElement {
  constructor(props: PropsElementChatBox) {
    super();
    this.className = props.className ?? "";
    
    const observer = new MutationObserver(() => {
      this.scrollTop = this.scrollHeight;
    });

    observer.observe(this, { childList: true });
  }

  addMessage(userName: string, message: string) {
    const text = document.createElement("p");
    text.innerText = message;
    this.append(new ElementCardUserMessage({ userName, children: text }));
  }

  addImg(userName: string, file: File) {
    if (file.type.startsWith("image/")) {
      const img = document.createElement("img");
      fileToStringBase64(file).then((data) => { img.src = data });

      this.append(new ElementCardUserMessage({ userName, children: img }));
    }
  }
}

customElements.define('element-chat-box', ElementChatBox);