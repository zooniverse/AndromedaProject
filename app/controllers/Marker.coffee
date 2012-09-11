style = require('lib/Styles')

class Marker extends Spine.Controller
  picker:       null
  label:        null
  labelText:    null
  deleteButton: null
  labelRect:    null
  centerPoint:  null
  selected:     false

  constructor: ->
    super

    @drawLabel()
    @hideLabel()

    @centerCircle = @picker.paper.circle()
    @centerCircle.attr style.crossCircle
    @centerCircle.hover @showLabel, @hideLabel
    @centerCircle.click @stopPropagation
    @centerCircle.drag @centerCircleDrag, @dragStart, @dragEnd

  delay: (duration, callback) ->
    if typeof duration is 'function'
      callback = duration
      duration = 0
    setTimeout callback, duration

  drawLabel: (text) =>
    @labelText = @picker.paper.text()
    @labelText.attr style.label.text
    @labelText.transform 'T20,0'

    labelHeight = (style.crossCircle.r * 2) + style.crossCircle['stroke-width']

    @deleteButton = @picker.paper.rect 0, 0, labelHeight, labelHeight
    @deleteButton.attr style.label.deleteButton
    @deleteButton.click @onClickDelete

    @deleteText = @picker.paper.text 0, 0, '\u00D7' # Multiplication sign
    @deleteText.attr style.label.deleteButton.text
    @deleteText.click @onClickDelete

    @labelRect = @picker.paper.rect 0, 0, 0, labelHeight
    @labelRect.toBack()
    @labelRect.attr style.label.rect
    @labelRect.transform "T0,#{-labelHeight / 2}"

    @label = @picker.paper.set @labelText, @labelRect, @deleteButton, @deleteText

    @label.hover @showLabel, @hideLabel

  showLabel: =>
    @dontHide = true
    @label.show()
    @label.animate opacity: 1, 100

  hideLabel: =>
    delete @dontHide
    @delay 500, =>
      unless @dontHide then @label.animate opacity: 0, 100, => @label.hide()

  onClickDelete: =>

  render: =>
    return if @centerCircle.removed
    @labelText.attr text: 'Star Cluster'
    textBox = @labelText.getBBox()
    @labelRect.attr width: 20 + Math.round(textBox.width) + 10
    @deleteButton.transform "T#{@labelRect.attr('width') - 1},#{-style.crossCircle.r - (style.crossCircle['stroke-width'] / 2)}"
    @deleteText.transform "T#{@labelRect.attr('width') + 3},-1}"
    @labelRect.attr fill: style['seastar']
    @deleteButton.attr fill: style['seastar']

  select: =>
    @selected = true
    @trigger 'select', @

  deselect: =>
    @selected = false
    @trigger 'deselect', @

  dragStart: =>
    return unless $(@centerCircle.node).closest(':disabled, .disabled').length is 0

    # @startPoints = ({x: point.x, y: point.y} for point in @annotation.value.points)
    @startPoints = ({x: point.x, y: point.y} for point in [{x: 0.5, y: 0.5}, {x: 0.55, y: 0.55}])
    @wasSelected = @selected
    @select() unless @wasSelected

  centerCircleDrag: (dx, dy) =>
    return unless @startPoints?
    @moved = true

    {width: w, height: h} = @picker.getSize()

    # for point, i in @annotation.value.points
    for point, i in [{x: 0.5, y: 0.5}, {x: 0.55, y: 0.55}]
      point.x = ((@startPoints[i].x * w) + dx) / w
      point.y = ((@startPoints[i].y * h) + dy) / h

  dragEnd: =>
    @deselect() if @wasSelected and not @moved # Basically, a click

    delete @startPoints
    delete @wasSelected
    delete @moved

  stopPropagation: (e) =>
    e.stopPropagation()

  lineBetween: (point1, point2) =>
    unless 'x' of point1 and 'y' of point1
      point1 =
        x: point1.attr 'cx'
        y: point1.attr 'cy'

    unless 'x' of point2 and 'y' of point2
      point2 =
        x: point2.attr 'cx'
        y: point2.attr 'cy'

    "M #{point1.x} #{point1.y} L #{point2.x} #{point2.y}"

  destroy: =>
    @centerCircle.remove()
    @label.remove()

  limit: (value, threshold) ->
    if 0 - threshold < value < 0 + threshold then value = 0
    if 1 - threshold < value < 1 + threshold then value = 1
    value

module.exports = Marker