import ElementNotification from "./components/elements/notification/notification";
import PageChat from "./components/pages/chat/chat";
import PageLogIn from "./components/pages/log-in/log-in";
import PageSignIn from "./components/pages/sign-in/sign-in";
import StructureRouter from "./components/structures/router/router";

const app = document.getElementById("App");

if (app === null) throw "App not found !";

const notification = new ElementNotification({});
const router = new StructureRouter({});

const pageChat = new PageChat({});

router.addPage("sign-in", new PageSignIn({}), () => { });
router.addPage("log-in", new PageLogIn({}), () => { });
router.addPage("chat", pageChat, pageChat.onLoad);

app.appendChild(notification);
app.appendChild(router);

router.setPage("sign-in");

export { notification, router };
