require ['lib/link',
         'lib/vec',
         'lib/cell',
         'lib/canvas_query_adapter',
         'lib/aquarium'], (Link,Vec,Cell,RenderAdapter,Aquarium) ->

  egg = ->
    @i ?= 0
    @attract = 0b0
    @repel = 0b1
    @color = [200,0,0]
    if @i == 0
      @color = [150,150,160]

    if !@done? && @age > 10
      child = @divide( egg )
      child?.i = @i+1
      @motor = @link child
      @motor?.thrust = 0.1
      @done = true
  
  w = h = 500
  aq = new Aquarium 500,500
  aq.cells.push new Cell aq, aq.getCenter(), egg

  $ ->
    cq(w,h).framework(
      onStep: ->
        aq.step()
      onRender: -> 
        new RenderAdapter aq, @
    ).appendTo("body")
