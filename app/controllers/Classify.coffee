Spine         = require('spine')
Subject       = require('models/Subject')
CircleMarker  = require('controllers/CircleMarker')


class Classify extends Spine.Controller
  className: 'classify'
  
  elements:
    '.field img'  : 'image'
  
  events:
    'mousedown'   : 'onMouseDown'
    'touchstart'  : 'onTouchStart'
    'touchmove'   : 'onTouchMove'
    'touchend'    : 'onTouchEnd'
  
  # Instance variables
  paper: null
  markers: null
  selectedType: null
  selectedMarkerType: null
  disabled: false
  
  # Mouse interactions
  mouseIsDown: false
  
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
  
  onMouseDown: =>
    console.log 'onMouseDown'
    return if @disabled
    
    
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