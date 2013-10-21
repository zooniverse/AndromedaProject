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
    feedback: ["Well done", "Awesome", "Nice", "Congratulations"]
    
    events:
      'click .species .toggles button'          : 'changeSpecies'
      'click .species .other-creatures button'  : 'showArtifacts'
      'click .species .finished'                : 'finishSpecies'
      'click .favorite .create button'          : 'createFavorite'
      'click .favorite .destroy button'         : 'destroyFavorite'
      'click .talk [value="yes"]'               : 'goToTalk'
      'click .talk [value="no"]'                : 'nextSubjects'
      'click .favorite [value="no"]'            : 'nextSubjects'
      'click .tutorial-again'                   : 'startTutorial'
      'click .feedback'                         : 'showLabels'
      'click .toggle-subject'                   : 'toggleSubject'
      'click .reset-subject'                    : 'resetClassification'
      'click .show-hide'                        : 'showHide'

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
      '.feedback .box'                          : 'feedbackBox'

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
      @picker.reset()
      
      super
      @otherSpeciesAnnotation = new Annotation
        classification: @classification

      @changeSpecies null
      # @speciesFinishedButton.attr 'disabled'
      
      @steps.removeClass 'finished'
      $('#toggleCol').text('B/W')
      
      delay 500, =>
        @updateFavoriteButtons()
        
    resetClassification: (e) =>
      e.preventDefault()
      @reset()
    
    render: =>
      @renderSpeciesPage()
      
      # Hide the feedback box
      @feedbackBox.hide()
      
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
      @classification.trigger 'change'

    showLabels: =>
      for m in @picker.markers
        m.label.show()
        m.label.animate opacity: 1, 100
        
    toggleSubject: (e) =>
      
      target = $(e.target)
      e.preventDefault()
      img = jQuery('.selection-area img')
      src = img.attr('src')
      if src.indexOf("standard") > -1
        src = src.replace('standard', 'inverted')
        target.text("Color")
      else
        src = src.replace('inverted', 'standard')
        target.text("B/W")
      img.attr('src', src)

    showHide: =>
      if $('.show-hide').text() == 'Hide' and @picker.markers.length > 0
        $('.show-hide').text('Show')
        $('svg').hide()
      else
        $('.show-hide').text('Hide')
        $('svg').show()
    
    finishSpecies: =>
      
      $('svg').show()
      @picker.setDisabled true
      @steps.addClass 'finished'
      
      subject = @picker.classifier.workflow.selection[0]
      # Show center of field on small map
      if subject
        width = 240
        height = 309
        center = subject.metadata.center
        if center?
          nx = parseFloat(center[0])
          ny = parseFloat(center[1])
        
          x = width * nx
          y = height * ny
          radius = 4
        
          @overlay[0].width = width
          @overlay[0].height = height
          context = @overlay[0].getContext('2d')
        
          context.beginPath()
          context.arc(x, y, radius, 0, 2 * Math.PI, false)
          context.fillStyle = "#FAFAFA"
          context.fill()
          context.lineWidth = 1
          context.strokeStyle = "#505050"
          context.stroke()
          context.closePath()
        
          # Position the feedback box
          coords = subject.coords
          if coords
            @feedbackBox.show()
            @feedbackBox.find('.value:nth-child(2)').text("#{coords[0].toFixed(3)}")
            @feedbackBox.find('.value:nth-child(5)').text("#{coords[1].toFixed(3)}")
            @feedbackBox.css({top: "#{y + 40}px", left: "#{x + 20}px"})
      
        # Check if subject has synthetics
        synthetics = subject.metadata.synthetic
        if synthetics
          # Check if user marked near a synthetic cluster
          if 'annotations' of @classification
            for annotation in @classification.annotations
              if 'value' of annotation
                if 'species' of annotation.value
                  if annotation.value.species is 'cluster'
                    points = annotation.value.points
                    centerPoint = points[0]
                    x1 = 725 * centerPoint.x
                    y1 = 500 * centerPoint.y
                  
                    for synthetic in synthetics
                      x2 = parseFloat(synthetic.x)
                      y2 = 500 - parseFloat(synthetic.y)
                      distance = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2))
                      pixradius = parseFloat(synthetic.pixradius)
                      
                      if distance < 20
                        if x2 > 500
                          xtext = x2 - pixradius - 8
                          anchor = 'end'
                        else
                          xtext = x2 + pixradius + 8
                          anchor = 'start'
                        @picker.paper.circle(x2, y2, pixradius).attr({'stroke': '#F1F1F1', 'stroke-width': 6})
                        @picker.paper.circle(x2, y2, pixradius).attr({'stroke': '#000000', 'stroke-width': 3})
                        words = @feedback[Math.floor(Math.random() * @feedback.length)]
                        @picker.paper.text(xtext, y2, "#{words}, you found a synthetic cluster!").attr("font", "bold 11px 'Open Sans', sans-serif").attr("text-anchor", anchor).attr({"fill": "#F1F1F1"})

        @saveClassification()

  module.exports = Classifier
