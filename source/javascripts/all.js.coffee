# hello

MAX_CELL_COUNT = 100

clumpy = ->
  @child = clumpy if Math.random() < 0.1
  if @pos.x < 256
    @color = [200,0,0]
  else
    @color = [150,150,160]
  #@split() if @sniff('clumpy') < 5



class Vec
  constructor: (@x=0,@y=0,@z=0) ->
  set: (@x=0,@y=0,@z=0) ->
  get: -> new Vec @x, @y, @z
  add: (o) -> @x+=o.x; @y+=o.y; @z+=o.z; @
  sub: (o) -> @x-=o.x; @y-=o.y; @z-=o.z; @
  mul: (n) -> @x*=n; @y*=n; @z*=n; @
  div: (n) -> @x/=n; @y/=n; @z/=n; @
  mag: (n) -> Math.sqrt( @x*@x + @y*@y + @z*@z )
  normalize: -> mag = @mag(); @x/=mag; @y/=mag; @z/=mag; @
  bound: (x1,y1,z1,x2,y2,z2) ->
    @x = Math.min x2, Math.max(x1, @x)
    @y = Math.min y2, Math.max(y1, @y)
    @z = Math.min z2, Math.max(z1, @z)


class Cell
  constructor: (@pos = new Vec(), @dna) ->
    @age = 0
    @vel = new Vec
    @acc = new Vec
    @drag = 0.1
    @rad = 10
    @child = null

    c = ~~(Math.random()*50)
    @tint = [c,c,c]
    @color = [150,150,150]
  getColor: ->
    [@tint[0]+@color[0],@tint[1]+@color[1],@tint[2]+@color[2]]
  think: ->
    @dna.call @
  applyPhysics: ->
    @age+=0.0005
    @vel.add @acc
    @pos.add @vel
    @acc.set 0,0,0
    @vel.mul 1-@drag
  interactWith: (cells) ->
    for cell in cells
      continue if cell == @
      # collision
      dist = cell.pos.get().sub(@pos)
      combinedRadius = @rad + cell.rad
      f = (dist.mag()-combinedRadius)
      if f > 0
        f *= 5
        f = (1-f/(f+1))*0.2
      else
        f = f*0.2
        # new cells 'phase' in, so shit doesn't blow up
        f *= (@age) / ( (@age) + 1 )
      forceVec = dist.get().normalize().mul(f)
      @acc.add forceVec



class Aquarium
  constructor: (@w=500,@h=500) ->
    # @cells = for i in [1..100]
    #   new Cell @randPos(), clumpy
    @cells = []
    @cells.push new Cell new Vec(@w/2,@h/2,@h/2), clumpy

  randPos: ->
    new Vec Math.random()*@w, Math.random()*@h

  step: ->
    babies = []
    for cell in @cells
      break if @cells.length > MAX_CELL_COUNT
      if cell.child?
        child = new Cell cell.pos.get(), cell.child
        child.pos.x += Math.random()-0.5
        child.pos.y += Math.random()-0.5
        child.pos.z += Math.random()-0.5
        cell.child = null
        babies.push child


    @cells = @cells.concat babies


    for cell in @cells
      #cell.acc.set Math.random()-0.5, Math.random()-0.5
      cell.think()
      cell.pos.bound(0,0,0,@w,@h,@h)
      cell.interactWith @cells

    for cell in @cells
      cell.applyPhysics()



class CanvasRenderer
  constructor: (@aq, @c) ->
    @c.clearRect(0,0,@c.canvas.width,@c.canvas.height)
    cells = @aq.cells.slice 0
    cells.sort (a,b) -> a.z-b.z
    for cell in cells
      #continue if Math.abs((cell.pos.z-@aq.h/2)) > 20
      color = cell.getColor()
      color = cq.color(color[0],color[1],color[2],1.0).toHex()
      @c
      .fillStyle(color)
      .beginPath()
      .arc(cell.pos.x,cell.pos.y,cell.rad-1,0,Math.PI*2,true)
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
