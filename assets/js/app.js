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
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let Hooks = {}
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())
window.addEventListener("phx:streaming-chunk-received", e => {
  let container = document.querySelector(".messages");
  let lastSuccessMessage = document.querySelector(".messages > div:last-child .success-message")
  let lastErrorMessage = document.querySelector(".messages > div:last-child .error-message")
  let atBottom = container.scrollTop + container.clientHeight >= container.scrollHeight

  lastSuccessMessage.textContent += e.detail.chunk || ""
  lastErrorMessage.textContent += e.detail.error || ""
  if (atBottom) container.scrollTop = container.scrollHeight
})
window.addEventListener("scroll-to-bottom", e => e.target.scrollTop = e.target.scrollHeight)
window.addEventListener("phx:switch-theme", e => switchTheme(e.detail.name, save = true))
window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", e => {
  if (localStorage.theme === "system") e.matches ? switchTheme("dark") : switchTheme("light")
})

function switchTheme(theme, save = false) {
  if (save) localStorage.theme = theme
  document.documentElement.classList.toggle("dark", theme === "system" && window.matchMedia("(prefers-color-scheme: dark)").matches || theme === "dark")
}
switchTheme(localStorage.theme || "system")

Hooks.EnterSubmit = {
  mounted() {
    this.el.addEventListener("keydown", e => {
      // Submit form on Enter press (without Shift)
      if (e.key === "Enter" && !e.shiftKey) {
        // Click submit button
        this.el.nextElementSibling.click()
        e.preventDefault()
      }
    })

    // Prevent form submission when typed content consists only of whitespace
    this.el.addEventListener("keyup", _e => {
      if (this.el.value.trim() === "") {
        this.el.setCustomValidity(" ")
      }
      else {
        this.el.setCustomValidity("")
      }
    })

    // Prevent form submission when pasted content consists only of whitespace
    this.el.addEventListener("paste", e => {
      if (e.clipboardData.getData("text").trim() === "") {
        this.el.setCustomValidity(" ")
      }
      else {
        this.el.setCustomValidity("")
      }
    })
  }
}

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
