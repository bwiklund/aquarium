@aqua.define 'Cell', (Vec,Link) ->

  # The cell class. Still hugely in flux, no point documenting yet.
  MAX_CELL_COUNT = 10
  
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
      @age+=1
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
          f *= (@age*0.001) / ( (@age*0.001) + 1 )
        forceVec = dist.get().normalize().mul(f)
        @acc.add forceVec

    link: (cell) ->
      return null if !cell?
      link = new Link @,cell
      @aq.links.push link
      link

    divide: (childProto) ->
      return null if @aq.cells.length > MAX_CELL_COUNT
      child = new Cell @aq, @pos.get(), childProto
      child.pos.x += Math.random()-0.5
      child.pos.y += Math.random()-0.5
      child.pos.z += Math.random()-0.5
      @aq.babies.push child
      child
