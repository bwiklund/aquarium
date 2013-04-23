# hello

###

options for managing forces

bitfield: assign a formula to each bit in an N-bit field, and have arbitrary rules for each

limited: each cell has a @mask, @attractMask, @repelMask


###

MAX_CELL_COUNT = 100



egg = ->
  @color = [200,0,0]
  if !@done?
    @link @divide( egg )
  @done = true



class Link
  constructor: (@a,@b) ->

  update: ->
    dist = @a.pos.get().sub(@b.pos)
    combinedRadius = @a.rad + @b.rad
    spaceBetween = dist.mag() - combinedRadius
    force = spaceBetween * 0.001
    forceVec = dist.normalize().mul force
    @a.acc.sub forceVec
    @b.acc.add forceVec
    undefined




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
  constructor: (@aq, @pos = new Vec(), @dna) ->
    @age = 0
    @vel = new Vec
    @acc = new Vec
    @drag = 0.1
    @rad = 10
    @child = null

    c = ~~(Math.random()*50)
    @tint = [c,c,c]
    @color = [150,150,150]
    @mask = 0b1
    @attract = 0b1
    @repel = 0b0

    @links = []

  getColor: ->
    [@tint[0]+@color[0],@tint[1]+@color[1],@tint[2]+@color[2]]
  
  think: ->
    @dna.call @

  applyPhysics: ->
    @age+=0.05
    @vel.add @acc
    @pos.add @vel
    @acc.set 0,0,0
    @vel.mul 1-@drag

  interactWith: (cells) ->
    for cell in cells
      continue if cell == @
      
      attractStrength = 0
      if @attract & cell.mask > 0
        attractStrength += 1
      if @repel & cell.mask > 0
        attractStrength -= 1

      # collision
      dist = cell.pos.get().sub(@pos)
      combinedRadius = @rad + cell.rad
      f = (dist.mag()-combinedRadius)
      if f > 0
        f *= 5
        f = (1-f/(f+1))*0.2
        f *= attractStrength
      else
        f = f*0.2
        # new cells 'phase' in, so shit doesn't blow up
        f *= (@age) / ( (@age) + 1 )
      forceVec = dist.get().normalize().mul(f)
      @acc.add forceVec

  link: (cell) ->
    return if !cell?
    @aq.links.push new Link @,cell

  divide: (childProto) ->
    return null if @aq.cells.length > MAX_CELL_COUNT
    child = new Cell @aq, @pos.get(), childProto
    child.pos.x += Math.random()-0.5
    child.pos.y += Math.random()-0.5
    child.pos.z += Math.random()-0.5
    @aq.babies.push child
    child


class Aquarium
  constructor: (@w=500,@h=500) ->
    # @cells = for i in [1..100]
    #   new Cell @randPos(), clumpy

    @cells = []
    @cells.push new Cell @, new Vec(@w/2,@h/2,@h/2), egg
    @babies = []

    @links = []

  randPos: ->
    new Vec Math.random()*@w, Math.random()*@h

  step: ->
    @cells = @cells.concat @babies
    @babies.length = 0


    for cell in @cells
      cell.acc.set Math.random()-0.5, Math.random()-0.5
      cell.acc.mul 0.1
      cell.think()
      cell.pos.bound(0,0,0,@w,@h,@h)
      cell.interactWith @cells

    for link in @links
      link.update()

    for cell in @cells
      cell.applyPhysics()



class CanvasRenderer
  constructor: (@aq, @c) ->
    @c.clearRect(0,0,@c.canvas.width,@c.canvas.height)
    cells = @aq.cells.slice 0
    window.cells = cells
    cells.sort (a,b) -> a.z-b.z
    for cell in cells
      #continue if Math.abs((cell.pos.z-@aq.h/2)) > 20
      color = cell.getColor()
      color = "rgba(#{color[0]},#{color[1]},#{color[2]},1.0)"
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
