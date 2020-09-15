import nico
import nico/vec
import dom


type
  Ship = ref object of RootObj
    orig: Vec2f
    pos: Vec2f
    vel: Vec2f
    bounce: float32
    rad: int

var ship: Ship

proc gameInit() =
  loadFont(0, "font.png")

  # Remove key listeners...we'll be handling game movements.
  dom.window.onkeydown = proc(event: dom.Event) =
    discard
  dom.window.onkeyup = proc(event: dom.Event) =
    discard

  ship = new(Ship)
  ship.orig.x = screenWidth.float32 / 2.0
  ship.orig.y = screenHeight.float32 / 2.0
  ship.pos.x = ship.orig.x
  ship.pos.y = ship.orig.y
  ship.vel.x = 5.0
  ship.vel.y = ship.vel.x
  ship.rad = 3
  ship.bounce = 1.5

  # Testing
  var btn = getElementById("btn")
  btn.addEventListener("click") do(e: dom.Event):
    ship.pos.x += 5

proc gameUpdate(dt: float32) =
  var yoffset = abs(ship.orig.y - ship.pos.y)

  if (yoffset > ship.bounce):
    ship.vel.y *= -1

  ship.pos.y += ship.vel.y * dt


proc gameDraw() =
  cls()
  setColor(3)
  circ(ship.pos.x, ship.pos.y, ship.rad)

nico.init("inchfwd", "Lookfar")
nico.createWindow("Lookfar", 128, 128, 4, false)
nico.run(gameInit, gameUpdate, gameDraw)
