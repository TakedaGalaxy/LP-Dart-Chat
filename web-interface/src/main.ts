import PageChat from "./components/pages/chat/chat";
import PageLogIn from "./components/pages/log-in/log-in";
import PageSignIn from "./components/pages/sign-in/sign-in";
import StructureRouter from "./components/structures/router/router";

const app = document.getElementById("App");

if (app === null) throw "App not found !";

const router = new StructureRouter({});

router.addPage("sign-in", new PageSignIn({}));
router.addPage("log-in", new PageLogIn({}));
router.addPage("chat", new PageChat({}));

app.appendChild(router);

export { router };
