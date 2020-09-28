import nico
import nico/vec
import dom
import strutils


const
  tile_width = 12
  column_length = 12
  row_length = 12


type
  Orientation = enum North, South, West, East

  Ship = ref object of RootObj
    orig: Vec2f
    pos: Vec2f
    vel: Vec2f
    bounce: float32
    side: float32
    base: float32
    orientation: Orientation

proc update(self: Ship, dt: float32) =
  var yoffset = abs(self.orig.y - self.pos.y)

  if (yoffset > self.bounce):
    self.vel.y *= -1

  self.pos.y += self.vel.y * dt

proc draw(self: Ship) =
  setColor(3)

  let (ax, ay, bx, by, cx, cy) = case self.orientation:
  of North:
    (self.pos.x, self.pos.y - self.side, 
     self.pos.x - self.base, self.pos.y + self.side, 
     self.pos.x + self.base, self.pos.y + self.side)
  of East:
    (self.pos.x + self.side, self.pos.y, 
     self.pos.x - self.side, self.pos.y + self.base, 
     self.pos.x - self.side, self.pos.y - self.base)
  of South:
    (self.pos.x, self.pos.y + self.side,
     self.pos.x - self.base, self.pos.y - self.side,
     self.pos.x + self.base, self.pos.y - self.side)
  of West:
    (self.pos.x - self.base, self.pos.y,
     self.pos.x + self.side, self.pos.y - self.base,
     self.pos.x + self.side, self.pos.y + self.base)

  line(ax, ay, bx, by)
  line(bx, by, cx, cy)
  line(cx, cy, ax, ay)

type
  Tile = ref object of RootObj
    center: Vec2i
    side: int

var ship: Ship
var tiles: seq[Tile]
var help: Element

proc moveShipTo(x, y: float32) =
  if x > 0 and x < screenWidth and y > 0 and y < screenHeight:
    ship.pos.x = x
    ship.pos.y = y

proc handleInput(value: cstring) =
  case ($value).strip()
  of "left":
    case ship.orientation
    of North: ship.orientation = West
    of East: ship.orientation = North
    of South: ship.orientation = East
    of West: ship.orientation = South
  of "right":
    case ship.orientation
    of North: ship.orientation = East
    of East: ship.orientation = South
    of South: ship.orientation = West
    of West: ship.orientation = North
  of "forward":
    case ship.orientation
    of North: moveShipTo(ship.pos.x, ship.pos.y - tile_width)
    of East: moveShipTo(ship.pos.x + tile_width, ship.pos.y)
    of South: moveShipTo(ship.pos.x, ship.pos.y + tile_width)
    of West: moveShipTo(ship.pos.x - tile_width, ship.pos.y)
  else:
    echo("Unrecognized command: ", value)

proc gameInit() =
  loadFont(0, "font.png")

  # Remove key listeners...we'll be handling game movements.
  dom.window.onkeydown = proc(event: dom.Event) =
    discard
  dom.window.onkeyup = proc(event: dom.Event) =
    discard

  ship = new(Ship)
  ship.orig.x = 6 * tile_width + tile_width div 2
  ship.orig.y = 6 * tile_width + tile_width div 2
  ship.pos.x = ship.orig.x
  ship.pos.y = ship.orig.y
  ship.vel.x = 5.0
  ship.vel.y = ship.vel.x
  ship.bounce = 1.5
  ship.side = 3
  ship.base = 3
  ship.orientation = East

  for x in 0..column_length:
    for y in 0..row_length:
      var tile = new(Tile)

      let currx = x * tile_width
      let curry = y * tile_width

      tile.center.x = currx + tile_width div 2
      tile.center.y = curry + tile_width div 2
      tile.side = tile_width div 2

      tiles.add(tile)

  # let console = getElementById("console")
  # let btn = getElementById("btn")
  # btn.addEventListener("click") do(e: dom.Event):
  #   handleInput(console.value)
  help = getElementById("help-text")
  help.innerText = "Help goes here"

  let commands = getElementsByClassName(document, "command")
  for command in commands:
    command.addEventListener("click") do (e: dom.Event):
      echo("command clicked", e.target.innerText)
      handleInput(e.target.innerText)
  

proc gameUpdate(dt: float32) =
  ship.update(dt)


proc gameDraw() =
  cls()
  ship.draw()

  setColor(3)
  for tile in tiles:
    rect(tile.center.x - tile.side, tile.center.y - tile.side, tile.center.x + tile.side, tile.center.y + tile.side)

nico.init("inchfwd", "Lookfar")
nico.createWindow("Lookfar", 145, 145, 4, false)
nico.run(gameInit, gameUpdate, gameDraw)
