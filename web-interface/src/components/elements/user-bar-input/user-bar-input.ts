import "./user-bar-input.scss";

export type PropsElementUserBarInput = {
  onInput: (text: string) => void;
  onSubmitInput: (text: string) => void;
  onSubmitFile: (file: File) => void;
}

export default class ElementUserBarInput extends HTMLElement {
  constructor(props: PropsElementUserBarInput) {
    super();

    const inputText = document.createElement("input");
    inputText.addEventListener("input", (event) => {
      const { value } = event.target as any;
      props.onInput(value);
    })

    const buttonSubmitText = document.createElement("button");
    buttonSubmitText.className = "button-submit-text";
    buttonSubmitText.innerText = "Enviar";

    const forms = document.createElement("form");
    forms.append(inputText);
    forms.append(buttonSubmitText);

    forms.addEventListener("submit", (event) => {
      event.preventDefault();

      const { value } = inputText;

      if (value == undefined || value == "") return;

      inputText.value = "";
      props.onSubmitInput(value);
    })

    const buttonSubmitImg = document.createElement("button");
    buttonSubmitImg.className = "button-submit-img";
    buttonSubmitImg.innerText = "Enviar Imagem";

    buttonSubmitImg.addEventListener("click", () => {
      const inputImg = document.createElement("input");
      inputImg.type = 'file';
      inputImg.accept = 'image/*';

      inputImg.addEventListener('change', (event) => {
        const arquivo = inputImg.files ? inputImg.files[0] : null;
        if (arquivo)
          props.onSubmitFile(arquivo);
      });
      inputImg.click();
    });

    this.append(forms)
    this.append(buttonSubmitImg);
  }
}

customElements.define('element-user-bar-input', ElementUserBarInput);