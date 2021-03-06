define (require, exports, module) ->
  Spine = require 'Spine'
  Raphael = require 'Raphael'

  template = require 'views/MarkerIndicator'

  style = require 'style'

  class MarkerIndicator extends Spine.Controller
    species: ''
    step: NaN

    circles: null
    paper: null

    template: template

    helpers:
      galaxy:
        image: 'images/indicator/galaxy.png'
        points: [{x: 40, y: 35}, {x: 68, y: 28}]
      cluster:
        image: 'images/indicator/cluster.png'
        points: [{x: 40, y: 35}, {x: 40, y: 5}]
      ghost:
        image: 'images/indicator/ghost.png'
        points: [{x: 72, y: 37.5}, {x: 95, y: 48}]  
      cross:
        image: 'images/indicator/cross.png'
        points: [{x: 17, y: 5}, {x: 59, y: 68}, {x: 4, y: 59}, {x: 71, y:14}]    
      linear:
        image: 'images/indicator/linear.png'
        points: [{x: 10, y: 9}, {x: 130, y: 64}]    

    elements:
      'img': 'image'
      '.points': 'points'

    constructor: ->
      super
      @html @template
      @paper = Raphael @points.get(0), '100%', '100%'

    reset: =>

    setSpecies: (species) =>
      return if species is @species
      @species = species

      @circles?.remove()
      @image.css display: 'none'

      @step = -1

      if @species of @helpers
        @image.attr 'src', @helpers[@species].image
        @image.css display: ''
        @image.one 'load', =>
          @paper.setSize @image.width(), @image.height()

        @circles = @paper.set()

        for coords in @helpers[@species].points
          circle = @paper.circle()
          circle.attr style.helperCircle
          circle.attr cx: coords.x, cy: coords.y, fill: style[@species]
          @circles.push circle

        @setStep 0

    setStep: (step) =>
      return unless @species
      step %= @helpers[@species].points.length
      return if step is @step
      @step = step

      @circles.attr style.helperCircle

      # Flicker the active dot.
      @circles[@step].animate style.helperCircle.active, 100, =>
        @circles[@step].animate style.helperCircle, 100, =>
          @circles[@step].animate style.helperCircle.active, 100

  module.exports = MarkerIndicator
