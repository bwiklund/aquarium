# hello

# all cells send out at least one signal, their own name
# they can send additional signals with logic


clumpy =
  think: ->
    @split() if @sniff('clumpy') < 100



class Vec
  constructor: (@x=0,@y=0) ->
  add: (o) -> @x+=o.x; @y+=o.y; @
  sub: (o) -> @x-=o.x; @y-=o.y; @
  mul: (n) -> @x*=n; @y*=n; @
  div: (n) -> @x/=n; @y/=n; @
  mag: (n) -> Math.sqrt( @x*@x + @y*@y )


class Cell
  constructor: (@pos = new Vec(), @dna) ->


class Aquarium
  constructor: (@w=500,@h=500) ->
    @cells = for i in [1..10]
      new Cell @randPos(), clumpy

  randPos: ->
    new Vec Math.random()*@w, Math.random()*@h


class CanvasRenderer
  constructor: (@aq, @c) ->
    for cell in @aq.cells
      @c
      .fillStyle("#333")
      .beginPath()
      .arc(cell.pos.x,cell.pos.y,10,10,0,Math.PI*2,true)
      .fill()
    

w = h = 500
aq = new Aquarium 500,500


$ ->
  cq(w,h).framework(
    onRender: -> 
      new CanvasRenderer aq, @
  ).appendTo("body")