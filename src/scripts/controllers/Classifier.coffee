define (require, exports, module) ->
  $ = require 'jQuery'

  config = require 'zooniverse/config'
  {delay, remove, arraysMatch} = require 'zooniverse/util'

  ZooniverseClassifier = require 'zooniverse/controllers/Classifier'

  Classification = require 'zooniverse/models/Classification'
  Annotation = require 'zooniverse/models/Annotation'
  User = require 'zooniverse/models/User'

  CreaturePicker = require 'controllers/CreaturePicker'
  MarkerIndicator = require 'controllers/MarkerIndicator'
  Pager = require 'zooniverse/controllers/Pager'

  TEMPLATE = require 'views/Classifier'

  class Classifier extends ZooniverseClassifier
    template: TEMPLATE

    picker: null
    indicator: null

    events:
      'click .species .toggles button'          : 'changeSpecies'
      'click .species .other-creatures button'  : 'changeOther'
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

    reset: =>
      @picker.reset()

      super
      @otherSpeciesAnnotation = new Annotation
        classification: @classification
        value: otherSpecies: null

      @changeSpecies null

      @steps.removeClass 'finished'

      delay 500, =>
        @updateFavoriteButtons()

    render: =>
      @renderSpeciesPage()

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
      @otherYes.toggleClass 'active', @otherSpeciesAnnotation.value.otherSpecies is true
      @otherNo.toggleClass 'active', @otherSpeciesAnnotation.value.otherSpecies is false

      @speciesFinishedButton.attr 'disabled', not @otherSpeciesAnnotation.value.otherSpecies?

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

    changeOther: (e) =>
      target = $(e.target)
      value = target.val() is 'yes'
      @otherSpeciesAnnotation.value.otherSpecies = value
      @classification.trigger 'change'

    finishSpecies: =>
      @picker.setDisabled true
      @steps.addClass 'finished'
      @saveClassification()

  module.exports = Classifier
