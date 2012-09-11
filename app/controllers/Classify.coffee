Spine         = require('spine')
Subject       = require('models/Subject')
Marker        = require('controllers/Marker')
CircleMarker  = require('controllers/CircleMarker')
Style         = require('lib/Styles')


class Classify extends Spine.Controller
  className: 'classify'
  
  elements:
    '.field img'  : 'image'
  
  events:
    'mousedown'   : 'onMouseDown'
    'mousemove'   : 'onMouseMove'
    'mouseup'     : 'onMouseUp'
    'touchstart'  : 'onTouchStart'
    'touchmove'   : 'onTouchMove'
    'touchend'    : 'onTouchEnd'
  
  # Instance variables
  paper: null
  markers: []
  strayCircles: []
  strayAxes: []
  selectedType: null
  selectedMarkerType: null
  disabled: false
  
  # Mouse interactions
  mouseIsDown: false
  dragThreshold: 3
  mouseMoves: 0
  movementCircle: null
  movementAxis: null
  movementBoundingCircle: null
  
  constructor: ->
    super
  
  active: ->
    super
    @nextSubject()
    @render()
    @setupPaper()
    
  render: =>
    return unless @isActive()
    @html require('views/classify')(@subject)
  
  # Simulated for now
  nextSubject: =>
    @subject = new Subject()
    
  setupPaper: =>
    @field = document.querySelector('.field')
    @paper = Raphael(@field, '100%', '100%')
    # new CircleMarker({picker: @})
  
  getSize: =>
    width: @image.width(), height: @image.height()
  
  
  createStrayCircle: (cx, cy) =>
    circle = @paper.circle cx, cy
    circle.attr Style.circle
    @strayCircles.push circle

    @el.trigger 'create-stray-circle'
    return circle
  
  createStrayAxis: =>
    # It will always be between the last two stray circles
    length = @strayCircles.length
    strayCircle1 = @strayCircles[length - 2]
    strayCircle2 = @strayCircles[length - 1]
    
    line = @paper.path Marker::lineBetween strayCircle1, strayCircle2
    line.toBack()
    line.attr Style.boundingBox
    @strayAxes.push line
    
    @el.trigger 'create-stray-axis'
    return line
  
  onMouseDown: (e) =>
    console.log 'onMouseDown'
    return if @disabled
    
    # Deselect all markers if selected
    marker.deselect() for marker in @markers when marker.selected
    
    @mouseIsDown = true
    @createStrayCircle(e.offsetX, e.offsetY)
    
    e.preventDefault?()
  
  onMouseMove: (e) =>
    console.log 'onMouseMove'
    return unless @mouseIsDown and not @disabled
    
    @mouseMoves += 1
    return if @mouseMoves < @dragThreshold
    
    {width, height} = @getSize()
    
    @movementCircle ||= @createStrayCircle()
    
    fauxPoint =
      x: Marker::limit (e.offsetX) / width, 0.01
      y: Marker::limit (e.offsetY) / height, 0.01
    
    @movementCircle.attr
      cx: fauxPoint.x * width
      cy: fauxPoint.y * height
    
    @movementAxis ||= @createStrayAxis()
    secondLastCircle = @strayCircles[@strayCircles.length - 2]
    @movementAxis.attr
      path: Marker::lineBetween secondLastCircle, @movementCircle
    
    if @selectedMarkerType is 'circle'
      @movementBoundingCircle ||= @createStrayBoundingCircle()
      @movementBoundingCircle.attr
        r: @movementAxis.getTotalLength()
  
  onMouseUp: (e) =>
    console.log 'onMouseUp'
    return unless @mouseIsDown and not @disabled
    @mouseIsDown = false
    @mouseMoves = 0
    
    @checkStrays()
    @movementCircle = null
    @movementAxis = null
    @movementBoundingCircle = null
  
  checkStrays: =>
    console.log 'checkStrays'
    
    if @strayCircles.length is 1
      @resetStrays()
    if @strayCircles.length is 2
      if @selectedMarkerType is 'circle'
        marker = @createCircleMarker()
      else
        @el.trigger 'create-half-axes-marker'
    else if @strayCircles.length is 3
      @strayCircles.pop().remove()
    else if @strayCircles.length is 4
      marker = @createAxesMarker()

    if marker?
      @markers.push marker

      setTimeout marker.deselect, 250

      marker.bind 'select', (marker) =>
        m.deselect() for m in @markers when m isnt marker
        @trigger 'change-selection'

      marker.bind 'deselect', =>
        @trigger 'change-selection'

      marker.bind 'release', =>
        @markers.splice(i, 1) for m, i in @markers when m is marker

      @resetStrays()
  
  resetStrays: =>
    console.log 'resetStrays'
    @strayCircles?.remove()
    @strayCircles = @paper.set()

    @strayAxes?.remove()
    @strayAxes = @paper.set()
  
  onTouchStart: =>
    console.log 'onTouchStart'
    
  onTouchMove: =>
    console.log 'onTouchMove'
    
  onTouchEnd: =>
    console.log 'onTouchEnd'
  
  # mousedown: (e) =>
  #   e.preventDefault()
  #   @drag = true
  #   @centerLoc = [e.offsetX, e.offsetY]
  # 
  # mousemove: (e) =>
  #   e.preventDefault()
  #   console.log @anchor
  #   if @isItemDragging()
  #     @resetInteraction()
  #     return
  #   
  #   if @drag
  #     @radiusLoc = [e.offsetX, e.offsetY]
  #     radius = Classify.getRadius(@centerLoc, @radiusLoc)
  #     
  #     if @curCircle?
  #       [circle, anchor] = @curCircle.getChildren()
  #       circle.setRadius(radius)
  #       anchor.setX(@radiusLoc[0])
  #       anchor.setY(@radiusLoc[1])
  #       
  #     else
  #       return if @anchor
  #     
  #       # Initialize a new layer
  #       @curCircle = new Kinetic.Group({draggable: true, listening: true})
  #       
  #       # Initialize a circle
  #       circleOptions =
  #         x: @centerLoc[0]
  #         y: @centerLoc[1]
  #         radius: radius
  #         stroke: "#F1F1F1"
  #         strokeWidth: 2
  #       circle = new Kinetic.Circle(circleOptions)
  #       
  #       # Initialize an anchor
  #       circleOptions['x'] = @radiusLoc[0]
  #       circleOptions['y'] = @radiusLoc[1]
  #       circleOptions['radius'] = 4
  #       circleOptions['fill'] = "#F1F1F1"
  #       circleOptions['listening'] = true
  #       circleOptions['draggable'] = true
  #       anchor = new Kinetic.Circle(circleOptions)
  #       
  #       # Anchor events
  #       anchor.on("dragmove", (e) =>
  #         console.log 'dragmove'
  #         shape = e.shape
  #         parent = shape.getParent()
  #         circle = parent.getChildren()[0]
  #         
  #         p1 = [shape.getX(), shape.getY()]
  #         p2 = [circle.getX(), circle.getY()]
  #         radius = Classify.getRadius(p1, p2)
  #         circle.setRadius(radius)
  #         
  #         shape.getLayer().draw()
  #       )
  #       anchor.on("mousedown touchstart", ->
  #         group = @.getParent()
  #         group.setDraggable(false)
  #         @.moveToTop()
  #       )
  #       anchor.on("dragend", ->
  #         @anchor = false
  #         group = @.getParent()
  #         group.setDraggable(true)
  #         layer = @.getLayer()
  #         layer.draw()
  #       )
  #       
  #       anchor.on("mouseover", (e) =>
  #         @anchor = true
  #         shape = e.shape
  #         shape.setFill("#081935")
  #         shape.getLayer().draw()
  #       )
  #       anchor.on("mouseout", (e) =>
  #         @anchor = false
  #         shape = e.shape
  #         shape.setFill("#F1F1F1")
  #         shape.getLayer().draw()
  #       )
  #       
  #       # Add circle and anchor to marker group
  #       @curCircle.add circle
  #       @curCircle.add anchor
  #       
  #       # Add marker layer to main layer
  #       @layer.add @curCircle
  #     @layer.draw()
  # 
  # mouseup: (e) =>
  #   e.preventDefault()
  #   @resetInteraction()
  # 
  # mouseleave: (e) =>
  #   e.preventDefault()
  #   @resetInteraction()
  # 
  # mouseenter: (e) =>
  #   e.preventDefault()
  #   @resetInteraction()
  # 
  # resetInteraction: =>
  #   @drag       = false
  #   @anchor     = false
  #   @centerLoc  = null
  #   @radiusLoc  = null
  #   @curCircle  = null
  # 
  # # Does this function exist in the Kinetic API?
  # isItemDragging: =>
  #   items = @layer.getChildren()
  #   for item in items
  #     return true if item.isDragging()
  #   return false
  
  #
  # Class Methods
  #
  
  @getRadius: (p1, p2) ->
    [x1, y1] = p1
    [x2, y2] = p2
    x = x2 - x1
    y = y2 - y1
    
    return Math.sqrt(x * x + y * y)

module.exports = Classify