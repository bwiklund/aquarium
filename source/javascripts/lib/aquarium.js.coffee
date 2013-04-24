# main Aquarium instance. holds entity lists, and is the entry point for update loops.
@aqua.define 'Aquarium', (Vec) ->

  class Aquarium
    constructor: (@w=500,@h=500) ->
      @cells = []
      @babies = []
      @links = []

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

    randPos: -> new Vec Math.random()*@w, Math.random()*@h

    getCenter: -> new Vec(@w/2,@h/2,@h/2)
