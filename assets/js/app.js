// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

/** Event Functions */
const chatBox = document.getElementById('chat-messages');
// Function to scroll the chat box to the bottom
function scrollToBottom() {
    chatBox.scrollTop = chatBox.scrollHeight;
}

// From push_event function invoked in the Liveview.
window.addEventListener("phx:new-message", (e) => {
  scrollToBottom();
})

window.addEventListener("phx:someone-typing", (e) => {
  let username = e.detail.username;
  const userCardDiv = document.getElementById(`${username}-card`);
  // get second child of the chatSignDiv
  const chatSign = userCardDiv.children[1].children[0];
  // remove hidden class of chatSign for 2 seconds and then add it back if hidden is enabled
  if (chatSign.classList.contains('hidden')) {
    chatSign.classList.remove('hidden');
    setTimeout(() => {
      chatSign.classList.add('hidden');
    }, 2000);
  }
})
