#= require ./core
#= require_tree ./lib

@aqua.define 'Test', (Link,Vec,Cell,CanvasFrame,Aquarium) ->

  # a snake that shows some basic features
  egg = ->
    # you can define your own parameters, it's just javascript
    @i ?= 0

    # using the built in attraction/repulsion masks.
    # in this case, we're making the cells all repel,
    # to straighten the chain
    @mask = 0x1
    @attract = 0b0
    @repel = 0b1

    # base color
    @color = [200,0,0]

    # choosing a unique color for the 'head'
    if @i == 0
      @color = [150,150,160]

    # our growth logic
    if !@child? && @age > 10
      @child = @divide( egg )
      @child?.i = @i+1
      # linking to the next cell. note that links can
      # also have thrust, which is force directed along
      # their axis, like flagellum.
      @rope = @link @child
      @rope?.thrust = 0.1
  
  # spinning up our instance of aquarium
  w = h = 500
  aq = new Aquarium 500,500
  aq.cells.push new Cell aq, aq.getCenter(), egg

  # and hooking it into our canvas renderer
  $ ->
    cq(w,h).framework(
      onStep: ->
        aq.step()
      onRender: -> 
        new CanvasFrame aq, @
        return false
    ).appendTo("body")


app = @aqua.instance().resolve 'Test'