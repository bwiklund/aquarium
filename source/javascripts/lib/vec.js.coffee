@aqua.define 'Vec', ->
  # Standard 3d vector class. 
  #
  # All operations work on the current vector, and return it, 
  # except mag(), which returns the length of the vector
  #
  # That way, mostly everything can be chained.
  class Vec
    constructor: (@x=0,@y=0,@z=0) ->
    set: (@x=0,@y=0,@z=0) -> @
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
      @