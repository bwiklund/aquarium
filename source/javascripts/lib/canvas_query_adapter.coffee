@aqua.define 'CanvasQueryAdapter', ->

  # a class that represents a render pass.
  # accepts the Aquarium instance, and the canvasQuery instance.
  # meant to be swappable with another adapter, for say, threejs
  class CanvasQueryAdapter
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