@aqua.define 'Link', -> 

  # A 'rope' between two particles.
  class Link
    constructor: (@a,@b) ->
      @thrust = 0

    update: ->
      dist = @a.pos.get().sub(@b.pos)
      combinedRadius = @a.rad + @b.rad
      spaceBetween = dist.mag() - combinedRadius
      force = spaceBetween * 0.03# * (@b.age*0.1) / ( (@b.age*0.1) + 1 )
      forceVec = dist.normalize().mul force
      if force > 0 # links should only pull, repulsion is already taken care of
        @a.acc.sub forceVec
        @b.acc.add forceVec

      # and apply and flaggelumations
      forceVec.normalize().mul(@thrust)
      @a.acc.add forceVec
      @b.acc.add forceVec
      undefined