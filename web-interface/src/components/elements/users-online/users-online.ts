import "./users-online.scss";

export type PropsElementUsersOnline = {
}

export default class ElementUsersOnline extends HTMLElement {
  constructor(props: PropsElementUsersOnline) {
    super();
  }

  addUser(userName: string) {
    if (this.querySelector(`CardUserInput${userName}`) != null) return;

    const cardUserInput = document.createElement("div");
    cardUserInput.className = "card-user-input";
    cardUserInput.id = `CardUserInput${userName}`;

    const name = document.createElement("h3");
    name.innerText = userName;

    const input = document.createElement("p");
    input.id = `UserInput${userName}`;

    cardUserInput.append(name);
    cardUserInput.append(input);

    this.append(cardUserInput);
  }

  removeUser(userName: string) {
    const element = this.querySelector(`#CardUserInput${userName}`);

    if (element === null) return;

    element.remove();
  }

  updateUserInput(userName: string, input: string) {
    const element = this.querySelector(`#UserInput${userName}`);

    if (element === null) return;

    element.innerHTML = input;
  }
}

customElements.define('element-users-online', ElementUsersOnline);