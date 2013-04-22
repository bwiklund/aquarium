# hello

# all cells send out at least one signal, their own name
# they can send additional signals with logic


clumpy =
  think: ->
    @split() if @sniff('clumpy') < 100



class Vec
  constructor: (@x=0,@y=0) ->
  set: (@x=0,@y=0) ->
  add: (o) -> @x+=o.x; @y+=o.y; @
  sub: (o) -> @x-=o.x; @y-=o.y; @
  mul: (n) -> @x*=n; @y*=n; @
  div: (n) -> @x/=n; @y/=n; @
  mag: (n) -> Math.sqrt( @x*@x + @y*@y )
  bound: (x1,y1,x2,y2) ->
    @x = Math.min x2, Math.max(x1, @x)
    @y = Math.min y2, Math.max(y1, @y)


class Cell
  constructor: (@pos = new Vec(), @dna) ->
    @vel = new Vec
    @acc = new Vec
    @drag = 0.1
    @rad = 5
  applyPhysics: ->
    @vel.add @acc
    @pos.add @vel
    @acc.set 0,0
    @vel.mul 1-@drag
  interact: ->


class Aquarium
  constructor: (@w=500,@h=500) ->
    @cells = for i in [1..1000]
      new Cell @randPos(), clumpy

  randPos: ->
    new Vec Math.random()*@w, Math.random()*@h

  step: ->
    for cell in @cells
      cell.acc.set Math.random()-0.5, Math.random()-0.5
      cell.pos.bound(0,0,@w,@h)
      cell.applyPhysics()



class CanvasRenderer
  constructor: (@aq, @c) ->
    @c.clearRect(0,0,@c.canvas.width,@c.canvas.height)
    for cell in @aq.cells
      @c
      .fillStyle("#333")
      .beginPath()
      .arc(cell.pos.x,cell.pos.y,cell.rad,0,Math.PI*2,true)
      .fill()
    

w = h = 500
aq = new Aquarium 500,500


$ ->
  cq(w,h).framework(
    onStep: ->
      aq.step()
    onRender: -> 
      new CanvasRenderer aq, @
  ).appendTo("body")