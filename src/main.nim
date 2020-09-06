import nico
import dom

var buttonDown = false
var x = screenWidth div 2
var y = screenHeight div 2

proc gameInit() =
  loadFont(0, "font.png")

  # Remove key listeners...we'll be handling game movements.
  dom.window.onkeydown = proc(event: dom.Event) =
    discard

  dom.window.onkeyup = proc(event: dom.Event) =
    discard

  # Testing
  var btn = getElementById("btn")
  btn.addEventListener("click") do(e: dom.Event):
    x += 5
    y += 5

proc gameUpdate(dt: float32) =
  buttonDown = btn(pcA)

proc gameDraw() =
  cls()
  setColor(if buttonDown: 7 else: 3)
  printc("hello world", x, y)

nico.init("inchfwd", "Lookfar")
nico.createWindow("Lookfar", 128, 128, 4, false)
nico.run(gameInit, gameUpdate, gameDraw)
