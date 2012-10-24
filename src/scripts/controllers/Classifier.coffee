define (require, exports, module) ->
  $ = require 'jQuery'

  config = require 'zooniverse/config'
  {delay, remove, arraysMatch} = require 'zooniverse/util'

  ZooniverseClassifier = require 'zooniverse/controllers/Classifier'

  Classification  = require 'zooniverse/models/Classification'
  Annotation      = require 'zooniverse/models/Annotation'
  User            = require 'zooniverse/models/User'

  CreaturePicker  = require 'controllers/CreaturePicker'
  MarkerIndicator = require 'controllers/MarkerIndicator'
  Pager           = require 'zooniverse/controllers/Pager'

  TEMPLATE        = require 'views/Classifier'

  class Classifier extends ZooniverseClassifier
    template: TEMPLATE

    picker: null
    indicator: null

    events:
      'click .species .toggles button'          : 'changeSpecies'
      'click .species .other-creatures button'  : 'showArtifacts'
      'click .species .finished'                : 'finishSpecies'
      'click .favorite .create button'          : 'createFavorite'
      'click .favorite .destroy button'         : 'destroyFavorite'
      'click .talk [value="yes"]'               : 'goToTalk'
      'click .talk [value="no"]'                : 'nextSubjects'
      'click .tutorial-again'                   : 'startTutorial'

    elements:
      '.steps'                                  : 'steps'
      '.species .toggles button'                : 'speciesButtons'
      '.species .other-creatures [value="yes"]' : 'otherYes'
      '.species .other-creatures [value="no"]'  : 'otherNo'
      '.species .finished'                      : 'speciesFinishedButton'
      '.summary'                                : 'summary'
      '.overlay'                                : 'overlay'
      '.summary .favorite .create'              : 'favoriteCreation'
      '.summary .favorite .destroy'             : 'favoriteDestruction'

    constructor: ->
      super

      @indicator = new MarkerIndicator
        el: @el.find '.indicator'
        classifier: @

      @picker = new CreaturePicker
        el: @el.find '.image'
        classifier: @

      @picker.bind 'change-selection', @renderSpeciesPage

      new Pager el: pager for pager in @el.find('[data-page]').parent()

      User.bind 'sign-in', @updateFavoriteButtons
      @picker.el.bind 'create-half-axes-marker', @disableFinished
      @picker.el.bind 'create-axes-marker', @enableFinished

    disableFinished: => $('button[class="finished"]').attr('disabled', 'disabled')
    enableFinished: => $('button[class="finished"]').removeAttr('disabled')
        
    reset: =>
      console.log 'reset'
      @picker.reset()
      
      super
      @otherSpeciesAnnotation = new Annotation
        classification: @classification
        value: otherSpecies: null

      @changeSpecies null
      # @speciesFinishedButton.attr 'disabled'
      
      @steps.removeClass 'finished'

      delay 500, =>
        @updateFavoriteButtons()

    render: =>
      @renderSpeciesPage()
      
      # Star cluster selected by default
      active = false
      for item in $('button[data-marker]')
        if $(item).hasClass('active')
          active = true
          break
      $('button[value="cluster"]').click() unless active

    renderSpeciesPage: =>
      selectedMarker = (m for m in @picker.markers when m.selected)[0]
      if selectedMarker
        @speciesButtons.filter("[value='#{selectedMarker.annotation.value.species}']").trigger 'click'

      @speciesButtons.find('.count').html '0'
      for annotation in @classification.annotations
        button = @speciesButtons.filter "[value='#{annotation.value.species}']"
        countElement = button.find '.count'
        countElement.html parseInt(countElement.html(), 10) + 1

      return unless @otherSpeciesAnnotation
      # @otherYes.removeClass 'active' if @otherSpeciesAnnotation.value.otherSpecies is null
      # @otherNo.removeClass 'active' if @otherSpeciesAnnotation.value.otherSpecies is null

      # @speciesFinishedButton.attr 'disabled', not @otherSpeciesAnnotation.value.otherSpecies? 
      # $('#artefact-list').hide() if @otherSpeciesAnnotation.value.otherSpecies is null

    updateFavoriteButtons: =>
      signedIn = User.current?
      tutorial = arraysMatch @workflow.selection, @workflow.tutorialSubjects
      @el.toggleClass 'can-favorite', signedIn and not tutorial

    changeSpecies: (e) =>
      e ?= target: $('<input />') # Dummy for when we deselect a button

      target = $(e.target)
      species = target.val()

      @picker.selectedSpecies = species
      @picker.selectedMarkerType = target.data 'marker'

      @picker.setDisabled not species

      @indicator.setSpecies species

      @speciesButtons.removeClass 'active'
      target.addClass 'active'

    showArtifacts: (e) =>
      target = $(e.target)
      $('#artefact-list').slideDown() if target.val() is "yes"
      $('#artefact-list').slideUp() if target.val() is "no"
      
      @otherSpeciesAnnotation.value.otherSpecies = 1 if target.val() is "yes"
      @otherSpeciesAnnotation.value.otherSpecies = 0 if target.val() is "no"
      
      @otherYes.addClass 'active' if target.val() is "yes" 
      @otherNo.addClass 'active' if target.val() is "no" 
      @otherYes.removeClass 'active' if target.val() is "no" 
      @otherNo.removeClass 'active' if target.val() is "yes"
      
      @speciesFinishedButton.removeAttr 'disabled'
 
    changeOther: (e) =>
      target = $(e.target)
      value = target.val()
      @otherSpeciesAnnotation.value.otherSpecies = value
      console.log("value"+@otherSpeciesAnnotation.value.otherSpecies)
      @classification.trigger 'change'

    finishSpecies: =>
      @picker.setDisabled true
      @steps.addClass 'finished'
      
      subject = @picker.classifier.workflow.selection[0]
        
      # Show center of field on small map
      center = subject.metadata.subimageCenter
      if center?
        x = parseFloat(center.x)
        y = 248 - parseFloat(center.y)
        radius = 4
        
        context = @overlay[0].getContext('2d')
        context.clearRect(0, 0, 215, 248)
        
        context.beginPath()
        context.arc(x, y, radius, 0, 2 * Math.PI, false)
        context.fillStyle = "#F1F1F1"
        context.lineWidth = 1
        context.strokeStyle = "#505050"
        context.stroke()
        context.fill()
      
      # Show year 1 catalog on subject
      year1 = subject.metadata.year1
      if year1?
        
        for cluster in year1
          x = parseFloat(cluster.x)
          y = parseFloat(cluster.y)
          pixradius = parseFloat(cluster.pixradius)
          @picker.paper.circle(x, 500 - y, pixradius).attr({stroke: '#F1F1F1', 'stroke-width': 16})
      
      @saveClassification()

  module.exports = Classifier
